int analogPin = 0; // read from multiplexer using analog input 0
int strobePin = 4; // strobe is attached to digital pin 2
int resetPin = 5; // reset is attached to digital pin 3
int spectrumValue[7]; // to hold a2d values
int LEDpin1 = 6;
int LEDpin2 = 8;
int LEDpin3 = 9;
int LEDpin4 = 10;
int LEDpin5 = 11;
int LEDpin1Level;
int LEDpin2Level;
int LEDpin3Level;
int LEDpin4Level;
int LEDpin5Level;

void setup() 
{
  pinMode(analogPin, INPUT);
  pinMode(LEDpin1, OUTPUT);
  pinMode(LEDpin2, OUTPUT);
  pinMode(LEDpin3, OUTPUT);
  pinMode(LEDpin4, OUTPUT);
  pinMode(LEDpin5, OUTPUT);
  pinMode(strobePin, OUTPUT);
  pinMode(resetPin, OUTPUT);
  analogReference(DEFAULT);
  digitalWrite(resetPin, LOW);
  digitalWrite(strobePin, HIGH);
}

void loop() 
{
  digitalWrite(resetPin, HIGH);
  digitalWrite(resetPin, LOW);

  for (int i = 0; i < 7; i++)
  {
    digitalWrite(strobePin, LOW);
    delayMicroseconds(30); // to allow the output to settle
    spectrumValue[i] = analogRead(analogPin);
if  (spectrumValue[i] > 400) {
  LEDpin1Level = map(spectrumValue[2], 0, 900, 0, 255); 

  analogWrite(LEDpin1, LEDpin1Level); 
} else {
 analogWrite (LEDpin1Level, 0);
 analogWrite (LEDpin2Level, 0);
 analogWrite (LEDpin3Level, 0);
 analogWrite (LEDpin4Level, 0);
 analogWrite (LEDpin5Level, 0);

}
  digitalWrite(strobePin, HIGH);
  }
}

