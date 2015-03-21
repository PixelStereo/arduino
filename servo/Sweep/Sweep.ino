/* Sweep
 by BARRAGAN <http://barraganstudio.com> 
 This example code is in the public domain.

 modified 8 Nov 2013
 by Scott Fitzgerald
 http://arduino.cc/en/Tutorial/Sweep
*/ 

#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // twelve servo objects can be created on most boards
 
int speedd = 10;    // variable to store the servo position 
int speedd2;
void setup() 
{ 
  myservo.attach(5);  // attaches the servo on pin 9 to the servo object 
} 
 
void loop() 
{ 
  if (speedd2 != speedd) {
    myservo.write(speedd); 
    delay(15); 
    speedd2 = speedd;
  }
    delay(5000);
      myservo.write(100); 
  delay(500000);
} 
