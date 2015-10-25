         // The DMX reciver
// DMX reciver code for arduino with ATmega 168
// It is based on Hendrik Hoelschers dmx code from http://www.hoelscher-hi.de/hendrik/
// This code was adapted for the ATmega 8 by big_mark_h
// And finaly Gustaf Gagge adapted it for ATmega 168 with lots of help from big_mark_h and Grumpy_Mike


// RGB strip librairy
#include "HL1606strip.h"
#define STRIP_D 4
#define STRIP_C 3
#define STRIP_L 2
// Here we have 16 LED, this is the last number. Change it if you have another amount of LED
HL1606strip strip = HL1606strip(STRIP_D, STRIP_L, STRIP_C, 16);

// Spectrum Shield
int analogPin = 0; // read from multiplexer using analog input 0
int strobePin = 4; // strobe is attached to digital pin 2
int resetPin = 5; // reset is attached to digital pin 3
int spectrumValue[7]; // to hold a2d values

// Daylight LEDs, powered by PWM
int LEDpin1 = 10;
int LEDpin2 = 11;

// Some value to stock LED levels
int LEDpin1Level;
int LEDpin2Level;

// Switchs on or off LED
int RGBswitch = 1; // Turn on/off RGB display
int LEDswitch = 1; // Turn on/off LED display 
int RGBmode = 0; // Choose mode for RGB display - 0 is colors by intensity, 1, is RED etc

// threshold to filter noise
int NoiseThreshold = 350;



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
  
  pinMode(analogPin, INPUT);
  pinMode(LEDpin1, OUTPUT);
  pinMode(LEDpin2, OUTPUT);
  pinMode(strobePin, OUTPUT);
  pinMode(resetPin, OUTPUT);
  analogReference(DEFAULT);
  digitalWrite(resetPin, LOW);
  digitalWrite(strobePin, HIGH);
  
  
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

  DmxAddress= 1;  //Set the base DMX address. Could use DIP switches for this.
}

void loop()			   // run over and over again
{
  
    // analogWrite(11, DmxField[0]);    // sets the LED off
    
    
    
     // this has to be done for spectrum shield
  digitalWrite(resetPin, HIGH);
  digitalWrite(resetPin, LOW);
//  analyze each band
  for (int i = 0; i < 7; i++)
              {
                  digitalWrite(strobePin, LOW);
                  delayMicroseconds(30); // to allow the output to settle
                  spectrumValue[i] = (analogRead(analogPin));         
                  // Analyze is done, so now we have 7 value and we will choose which we want
                  if  (spectrumValue[i] > NoiseThreshold)
                          {
                          LEDpin1Level = map(spectrumValue[2], 0, 1024, 0, 255); 
                          LEDpin2Level = map(spectrumValue[3], 0, 1024, 0, 255); 
                          } else {
                          LEDpin1Level = 0;
                          LEDpin2Level = 0;  
                          }
                digitalWrite(strobePin, HIGH);
              }
      
//  We have what we want, 2 Levels. So now we will send it to the output
// But before, we will choose to have filters or not
// LEDpin1Level = 0;
analogWrite(LEDpin1,   LEDpin1Level); 
    analogWrite(LEDpin2,   LEDpin2Level); 

if (!RGBswitch == 0) {  // if RGB display is requested
    if (!LEDpin1Level == 0) { // if SOUND, GIVE ME THE LEVEL
              if (RGBmode == 0) {  // if RGB mode is colorS
                          if (LEDpin1Level < 50) {                            
                             colorWipe(GREEN, 0);
                          }
                          else if (LEDpin1Level >  50 && LEDpin1Level <= 100) {
                             colorWipe(RED, 0);
                          }
                          else if (LEDpin1Level >  100 && LEDpin1Level <= 150) {
                             colorWipe(YELLOW, 0);
                          }
                          else if (LEDpin1Level >  150 && LEDpin1Level <= 200) {
                             colorWipe(BLUE, 0);
                          }
                          else if (LEDpin1Level >  200 ) {
                             colorWipe(BLUE, 0);
                          }
              }
              else if (RGBmode == 1) {  // if RGB mode is RED
              colorWipe(RED, 0);
              }
              else if (RGBmode == 2) {  // if RGB mode is GREEN
              colorWipe(GREEN, 0);
              }
              else if (RGBmode == 3) {  // if RGB mode is YELLOW
              colorWipe(YELLOW, 0);
              }
              else if (RGBmode == 4) {  // if RGB mode is BLUE
              colorWipe(BLUE, 0);
              }
              else if (RGBmode == 5) {  // if RGB mode is VIOLET
              colorWipe(VIOLET, 0);
              }
              else if (RGBmode == 6) {  // if RGB mode is WHITE
              colorWipe(WHITE, 0);
              }
              else if (RGBmode == 7) {  // if RGB mode is TEAL
              colorWipe(TEAL, 0);
              }
    }
    else { // if NO SOUND, BLACKOUT
         colorWipe(BLACK, 0);
         } // END of !LEDpin1Level == 0
   } // END of RGB switch
}// loop end

 x

// *************** DMX Reception ISR ****************
SIGNAL(SIG_USART_RECV)
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
 
 

// fill the entire strip, with a delay between each pixel for a 'wipe' effect
void colorWipe(uint8_t color, uint8_t wait) {
  uint8_t i;
  
  for (i=0; i < strip.numLEDs(); i++) {
      strip.setLEDcolor(i, color);
      strip.writeStrip();   
      delay(wait);
  }
}
