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

    LEDpin1Level = map(spectrumValue[2], 100, 1023, 0, 255); 
    LEDpin2Level = map(spectrumValue[3], 100, 1023, 0, 255); 
    LEDpin3Level = map(spectrumValue[4], 100, 1023, 0, 255); 
    LEDpin4Level = map(spectrumValue[5], 100, 1023, 0, 255); 
    LEDpin5Level = map(spectrumValue[6], 100, 1023, 0, 255); 

  analogWrite(LEDpin1, (255 - LEDpin1Level)); 
  analogWrite(LEDpin2, LEDpin2Level); 
  analogWrite(LEDpin3, LEDpin3Level); 
  analogWrite(LEDpin4, LEDpin4Level); 
  analogWrite(LEDpin5, LEDpin5Level); 

  digitalWrite(strobePin, HIGH);
  }

  Serial.println();
}

