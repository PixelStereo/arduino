// HL1606strip is an adaptation of LEDstrip from  http://code.google.com/p/ledstrip/
#include "HL1606strip.h"

// use -any- 3 pins!
#define STRIP_D 11
#define STRIP_C 13
#define STRIP_L 10

// Pin S is not really used in this demo since it doesnt use the built in PWM fade
// The last argument is the number of LEDs in the strip. Each chip has 2 LEDs, and the number
// of chips/LEDs per meter varies so make sure to count them! if you have the wrong number
// the strip will act a little strangely, with the end pixels not showing up the way you like
HL1606strip strip = HL1606strip(STRIP_D, STRIP_L, STRIP_C, 4);

void setup(void) {
  // nothing to do!
}

void loop(void) { 
   // then a chase
   chaseSingle(RED, 40);
   chaseSingle(YELLOW, 40);
   chaseSingle(GREEN, 40);
   chaseSingle(TEAL, 40);
   chaseSingle(VIOLET, 40);
   chaseSingle(WHITE, 40);
}

// turn everything off (fill with BLACK)
void stripOff(void) {
  // turn all LEDs off!
  for (uint8_t i=0; i < strip.numLEDs(); i++) {
      strip.setLEDcolor(i, BLACK);
  }
  strip.writeStrip();   
}

// have one LED 'chase' around the strip
void chaseSingle(uint8_t color, uint8_t wait) {
  uint8_t i;
  
  // turn everything off
  for (i=0; i< strip.numLEDs(); i++) {
    strip.setLEDcolor(i, BLACK);
  }

  for (i=0; i < strip.numLEDs(); i++) {
    strip.setLEDcolor(i, color);
    if (i != 0) {
      // make the LED right before this one OFF
      strip.setLEDcolor(i-1, BLACK);
    }
    strip.writeStrip();
    delay(wait);  
  }
  // turn off the last LED before leaving
  strip.setLEDcolor(strip.numLEDs() - 1, BLACK);
}



