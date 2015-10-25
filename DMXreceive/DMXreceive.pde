         // The DMX reciver
// DMX reciver code for arduino with ATmega 168
// It is based on Hendrik Hoelschers dmx code from http://www.hoelscher-hi.de/hendrik/
// This code was adapted for the ATmega 8 by big_mark_h
// And finaly Gustaf Gagge adapted it for ATmega 168 with lots of help from big_mark_h and Grumpy_Mike



#include <avr/io.h>
#include <stdint.h>
#include <avr/interrupt.h>


// ********************* local definitions *********************
#define DMX_CHANNELS    (32)		//Define the number of DMX values to store

enum {IDLE, BREAK, STARTB, STARTADR};	//DMX states

uint8_t  gDmxState;
uint8_t  *gDmxPnt;
uint16_t DmxCount;

uint8_t  DmxField[DMX_CHANNELS];     //array of DMX vals (raw)
uint16_t DmxAddress;			 //start address

int ledPin = 13;			     // LED connected to digital pin 13

void setup()				   // run once, when the sketch starts
{
  // sets the digital pin as output
  pinMode(ledPin, OUTPUT);

  // Disable interrupts
  cli();

  // 250kbps baud - only works for 16MHz clock frequency. See the ATMega8 datasheet if you are using a different clock speed
  UBRR0H = 0;
  UBRR0L = 3;

  // enable rx and interrupt on complete reception of a byte
  UCSR0B = (1<<RXEN0)|(1<<RXCIE0);
  UCSR0C = (1<<UMSEL01)|(3<<UCSZ00)|(1<<USBS0);

  // Enable interrupts
  sei();

  gDmxState= IDLE;

  uint8_t i;
  for (i=0; i<DMX_CHANNELS; i++)
  {
    DmxField[i]= 0;
  }

  DmxAddress= 10;  //Set the base DMX address. Could use DIP switches for this.
}

void loop()			   // run over and over again
{
  if(DmxField[0] >=127)
  {
    digitalWrite(ledPin, HIGH);   // sets the LED on
  }
  else
  {
    digitalWrite(ledPin, LOW);    // sets the LED off
  }
}

// *************** DMX Reception ISR ****************
SIGNAL(USART_RX_vect)  // for ATMega328
{
uint8_t USARTstate= UCSR0A;					//get state
uint8_t DmxByte= UDR0;						//get data
uint8_t DmxState= gDmxState;					//just get once from SRAM!!!

if (USARTstate &(1<<FE0))					//check for break
	{
	UCSR0A &= ~(1<<FE0);					//reset flag
	DmxCount= DmxAddress;					//reset frame counter
	gDmxState= BREAK;
	}

else if (DmxState == BREAK)
	{
	if (DmxByte == 0)
		{
		gDmxState= STARTB;				//normal start code detected
		gDmxPnt= ((uint8_t*)DmxField +1);
		}
	else gDmxState= IDLE;
	}

else if (DmxState == STARTB)
	{
	if (--DmxCount == 0)					//start address reached?
		{
		gDmxState= STARTADR;
		DmxField[0]= DmxByte;
		}
	}

else if (DmxState == STARTADR)
	{
	uint8_t *DmxPnt;
	DmxPnt= gDmxPnt;
	*DmxPnt= DmxByte;
	if (++DmxPnt >= (DmxField +DMX_CHANNELS)) 		//all ch received?
		{
		gDmxState= IDLE;
		}
	else gDmxPnt= DmxPnt;
	}
}
 

