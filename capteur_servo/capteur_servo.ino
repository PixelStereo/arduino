#include <Servo.h>

Servo myServo;
int myServoPos = 0;

// Capteur 1;
int valeurCapteur1 = 0;
int pinCapteur1 = A0;

void setup () {
myServo.attach(9);
}

void loop () {
          valeurCapteur1 = analogRead(pinCapteur1);
          myServoPos = map(valeurCapteur1 , 0 , 1023 , -150 , 150);
          myServo.write(myServoPos);
          delay(15);
 }


