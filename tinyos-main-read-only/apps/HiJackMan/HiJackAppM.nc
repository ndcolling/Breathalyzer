/**
 * Copyright (c) 2010 The Regents of the University of Michigan. All
 * rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * - Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the
 *  distribution.
 * - Neither the name of the copyright holder nor the names of
 *  its contributors may be used to endorse or promote products derived
 *  from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Author: Thomas Schmid
 */

module HiJackAppM
{
  uses {
      interface Boot;
      interface Leds;

      interface HplMsp430GeneralIO as ADCIn;

      interface Timer<TMilli> as ADCTimer;

      interface HiJack;
	  
	  //DS CODE
	  //interface Timer<TMilli> as Timer1;
	  //DS CODE END
  }

}
implementation
{

    uint32_t samplePeriod;
    uint8_t uartByteTx;
    uint8_t uartByteRx_first;
    uint8_t uartByteRx;
    uint8_t busy;
	uint8_t state;
	uint16_t lastADC;
	uint16_t avgADC;
	uint8_t n_avg;
	uint8_t n_cnt;
	uint8_t timeout;

    event void Boot.booted()
    {
	    //DS CODE
		//call Timer1.startPeriodic( 250 );
		//DS CODE END
	
		
		
        atomic
        {
            samplePeriod = 200; //ms
            busy = 0;
			state = 0;
			lastADC = 0;
			avgADC = 0;
			n_avg = 8;
			n_cnt = 0;
			timeout = 0;
        }

        // enable ADC6
        call ADCIn.makeInput();
        call ADCIn.selectModuleFunc();

        // manually enable ADC12
        atomic
        {
            ADC12CTL0 = ADC12ON + SHT0_7;         // Turn on ADC12, set sampling time
            ADC12CTL1 = CSTARTADD_0 + SHP;              // use ADC12MEM0, use sampling timer
            ADC12MCTL0 = INCH_6;              // select A6, Vref=1.5V
            //ADC12IE = 0x01;                           // Enable ADC12IFG.0

            call ADCTimer.startOneShot(samplePeriod);
        }
    }

		
	//DS CODE
	/*
	event void Timer1.fired()
	{
		dbg("BlinkC", "Timer 1 fired @ %s.\n", sim_time_string());
		call Leds.led0Toggle();
		call Leds.led1Toggle();
		call Leds.led2Toggle();
	}*/
	//DS CODE END
		
    void task sendTask()
    {
		
        uint8_t i;
			
			call Leds.led1Toggle();
			
        atomic
        {
            ADC12CTL0 |= ENC;                       // enable ADC conversion
            ADC12CTL0 |= ADC12SC;                   // start conversion
        }

        for(i=0; i<100; i++);

        atomic
        {
			uint8_t diff;

			lastADC = ADC12MEM0; 
			// lastADC = (uint8_t)(ADC12MEM0>>5); // use the top 7 bits only
			
			switch (state)
			{
				case 0: //IDLE
					uartByteTx = 0x80; //128
					avgADC = 0;
					n_cnt = 0;
					timeout = 0;

					//uartByteTx = (uint8_t)(ADC12MEM0>>4); // use the top 8 bits only

					//call Leds.led1Toggle();
					if (uartByteRx == 0x11) //17
						{
							if (lastADC>>4 >= 14) // 
							{
								state = 4;
							}
							else
							{
								state = 1;
							}
						}
						
					break;
				case 1: //TESTING
					uartByteTx = 0x83; //131
					//Sample ADC, if breath detected, switch to state 2
					// lastADC = (uint8_t)(ADC12MEM0>>5); // use the top 7 bits only
					if (lastADC>>4 >= 15) // Detected Breath
					{
						state = 2;
					}
					
					timeout++;
					if (timeout >= 25) // 5s
					{
						avgADC = 0x0000;
						state = 3;
					}
					//uartByteTx = lastADC;
					
					if (uartByteRx == 0x14) // CANCEL 20
					{
						state = 0;
					}
					
					break;
				case 2: //READING
					uartByteTx = 0x86; //134
					//Sample ADC, when readings level off, save and switch to state 3
					// lastADC = (uint8_t)(ADC12MEM0>>4); // use the top 8 bits only
					
					if (lastADC > avgADC) // Abs Value
					{
						avgADC = avgADC + (lastADC - avgADC)/n_avg; // Rolling Averge
						diff = lastADC - avgADC;
					}
					else
					{
						avgADC = avgADC - (avgADC - lastADC)/n_avg; // Rolling Averge
						diff = avgADC - lastADC;
					}
					if (diff < 32) //Wait until readings plateau
					{
						n_cnt++;
					}
					if (n_cnt >= n_avg)
					{
						state = 3;
					}
					
					if (uartByteRx == 0x14) // CANCEL
					{
						state = 0;
					}
					
					break;
				case 3: //DONE (report value)
					uartByteTx = (uint8_t)((avgADC>>5) & 0x7f); // 0-127
					
					if (uartByteRx == 0x14) // CANCEL
					{
						state = 0;
					}
					
					break;
				case 4: //Not ready to test, still alcohol on sensor
					uartByteTx = 0x89; // 137
					if (uartByteRx == 0x14) // CANCEL
					{
						state = 0;
					}
					break;
			}
		
		
		
             // uartByteTx = (uint8_t)(ADC12MEM0>>4); // use the top 8 bits only

            //uartByteTx = 0xaa;
            //uartByteTx = uartByteRx;
            //uartByteTx += 1;
            //uartByteTx = 0x55;
			
			//DS CODE
			// if (state == 1)
			// {
				// call Leds.led1Toggle();
			// }
			
			//DS CODE END
        }
        call HiJack.send(uartByteTx);
    }

    event void ADCTimer.fired()
    {
        atomic
        {
            if(!busy)
            {
                busy = 1;
                post sendTask();
            }
            call ADCTimer.startOneShot(samplePeriod);
        }

    }

    async event void HiJack.sendDone( uint8_t byte, error_t error )
    {
        atomic
        {
            busy = 0;
        }
    }

    async event void HiJack.receive( uint8_t byte) {
        atomic
        {
			// call Leds.led1Toggle();

			if ((byte == 0) | (byte == 255))
			{
				return;
			}
			// if (uartByteRx_first == byte)
			// {
				// map the byte to sampling rate
				// samplePeriod = (uint16_t)2560.0/(byte+1)/2;
				uartByteRx = byte;
			// }
            // uartByteRx_first = byte;
			
			// // map the byte to sampling rate
            // samplePeriod = (uint16_t)2560.0/(byte+1)/2;
            // uartByteRx = byte;
            //call ADCTimer.stop();
            //call ADCTimer.startOneShot(samplePeriod
			
			// if (byte < 0x80)
			// {state = 1;}
			// else
			// {state = 0;}
			
			// switch (byte)
			// {
				// case 0x11:
					// if (state == 0)
					// {
						// state = 1;
					// }
					// break;
				// case 0x14:
					// state = 0;
					// break;
			// }
			
        }
    }
}

