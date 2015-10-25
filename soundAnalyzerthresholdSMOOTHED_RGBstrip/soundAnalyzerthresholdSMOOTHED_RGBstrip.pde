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
int RGBmode = 6; // Choose mode for RGB display - 0 is colors by intensity, 1, is RED etc
int Invert = 1; // Turn on/off RGB display

int spectrumValueAverage;

// threshold to filter noise
int NoiseThreshold = 350;

void setup() 
{
  pinMode(analogPin, INPUT);
  pinMode(LEDpin1, OUTPUT);
  pinMode(LEDpin2, OUTPUT);
  pinMode(strobePin, OUTPUT);
  pinMode(resetPin, OUTPUT);
  analogReference(DEFAULT);
  digitalWrite(resetPin, LOW);
  digitalWrite(strobePin, HIGH);  
}

void loop() 
{
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
                digitalWrite(strobePin, HIGH);
              }
      



if (Invert == 0) 
          {
 if  (spectrumValue[3] > NoiseThreshold)
                          {
                          LEDpin1Level = map(spectrumValue[3], 0, 1024, 0, 255); 
                          LEDpin2Level = map(spectrumValue[4], 0, 1024, 0, 255); 
                          } else {
                          LEDpin1Level = 0;
                          LEDpin2Level = 0;  
                          }
        }
else {
                          LEDpin1Level = map(spectrumValue[4], 0, 1024, 255, 0); 
                          LEDpin2Level = map(spectrumValue[4], 0, 1024, 255, 0); 
}


//  We have what we want, 2 Levels. So now we will send it to the output
// But before, we will choose to have filters or not
// LEDpin1Level = 0;
analogWrite(LEDpin1,   LEDpin1Level); 
analogWrite(LEDpin2,   LEDpin2Level); 

if (!RGBswitch == 0) {  // if RGB display is requested
if (Invert == 0) {  // if RGB display is requested
    if (!LEDpin1Level == 0) { // if SOUND, GIVE ME THE LEVEL
              if (RGBmode == 1) {  // if RGB mode is RED
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
              colorWipe(TEAL, 1);
              }
    }
    else { // if NO SOUND, BLACKOUT
         colorWipe(BLACK, 0);
         } // END of !LEDpin1Level == 0
                } // END of Invert
   } // END of RGB switch



if (!RGBswitch == 0) {  // if RGB display is requested
if (Invert == 1) {  // if RGB display is requested
    if (LEDpin1Level > 100) { // if SOUND, GIVE ME THE LEVEL
              if (RGBmode == 1) {  // if RGB mode is RED
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
              colorWipe(TEAL, 1);
              }
    }
    else { // if NO SOUND, BLACKOUT
         colorWipe(BLACK, 0);
         } // END of !LEDpin1Level == 0
       } // END of Invert
   } // END of RGB switch
}// loop end


// fill the entire strip, with a delay between each pixel for a 'wipe' effect
void colorWipe(uint8_t color, uint8_t wait) {
  uint8_t i;
  
  for (i=0; i < strip.numLEDs(); i++) {
      strip.setLEDcolor(i, color);
      strip.writeStrip();   
      delay(wait);
  }
}
