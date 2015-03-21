// include the library code:
#include <Wire.h>
#include <Adafruit_MCP23017.h>
#include <Adafruit_RGBLCDShield.h>

// The shield uses the I2C SCL and SDA pins. On classic Arduinos
// this is Analog 4 and 5 so you can't use those for analogRead() anymore
// However, you can connect other I2C sensors to the I2C bus and share
// the I2C bus.
Adafruit_RGBLCDShield lcd = Adafruit_RGBLCDShield();

void setup() {
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  lcd.print("span 0.0.1");
  lcd.setBacklight(0x7);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(13, OUTPUT);
  delay(500);
  lcd.clear();
}

boolean buttons_active = false;
int pwm[6] = {5,6,9,10,11,13};
int val[6] = {0,0,0,0,0,0};
String label[6] = {"value 1 - pin 5" , "value 2 - pin 6", "value 3 - pin 9", "value 4 - pin 10" , "value 5 - pin 11" , "value 6 - pin 13"};
int current = 0;

void loop() {
  // set the cursor to column 0, line 0
  lcd.setCursor(0, 0);
  lcd.print(label[current]);
  // set the cursor to column 0, line 1
  lcd.setCursor(0, 1);
  lcd.print(val[current]);

  uint8_t buttons = lcd.readButtons();
  if (buttons) {
    if (buttons_active != true) {
      lcd.clear();
      lcd.setCursor(0,0);
      if (buttons & BUTTON_UP) {
        if (val[current] == 255) {
          val[current] = 0;
        }
        else {
          val[current] = val[current]+1;
        }
      }
      if (buttons & BUTTON_DOWN) {
        if (val[current] == 0) {
          val[current] = 255;
        }
        else {
          val[current] = val[current]-1;
        }
      }
      if (buttons & BUTTON_LEFT) {
        if (current == 0) {
          current =5;
        }
        else {
          current = current - 1;
        }
      }
      if (buttons & BUTTON_RIGHT) {
        if (current == 5) {
          current = 0;
        }
        else {
          current = current + 1;
        }      
      }
      if (buttons & BUTTON_SELECT) {
        lcd.print("SELECT ");
      }
    }
    buttons_active = true; 
  }
  else {
    buttons_active = false;
  }

  for (int i = 0; i < 5; i++) { 
    analogWrite(pwm[i], val[i]); 
  }
}






