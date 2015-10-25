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

// Smoothing
const int numReadings = 30;
int readings[numReadings];      // the readings from the analog input
int index = 0;                  // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average


void setup() 
{
    // initialize all the readings to 0:
  for (int thisReading = 0; thisReading < numReadings; thisReading++)
    readings[thisReading] = 0;         
    
    
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
    spectrumValue[i] = (analogRead(analogPin))*2;
    if  (spectrumValue[i] > 230) 
        {
        LEDpin1Level = (230, 1023, 0, 255, spectrumValue[2], 20);
        LEDpin2Level = map(spectrumValue[3], 230, 900, 0, 255); 
        LEDpin3Level = map(spectrumValue[4], 230, 900, 0, 255); 
        LEDpin4Level = map(spectrumValue[5], 230, 900, 0, 255); 
        LEDpin5Level = map(spectrumValue[6], 230, 900, 0, 255); 
        } else 
        {
                LEDpin1Level = 0;
                LEDpin2Level = 0;
                LEDpin3Level = 0;
                LEDpin4Level = 0;
                LEDpin5Level = 0;
        }
  digitalWrite(strobePin, HIGH);
  }
 
  
   // subtract the last reading:
  total= total - readings[index];        
  // read from the sensor:  
  readings[index] = LEDpin5Level;
  // add the reading to the total:
  total= total + readings[index];      
  // advance to the next position in the array:  
  index = index + 1;                    

  // if we're at the end of the array...
  if (index >= numReadings)              
    // ...wrap around to the beginning:
    index = 0;                          

  // calculate the average:
  average = total / numReadings;        
  // send it to the computer (as ASCII digits)
    analogWrite(LEDpin5, average); 
    analogWrite(LEDpin1,   LEDpin1Level); 
    analogWrite(LEDpin2,   LEDpin2Level); 
    analogWrite(LEDpin3,   LEDpin3Level); 
    analogWrite(LEDpin4,   LEDpin4Level); 
   //  analogWrite(LEDpin5,   255 - LEDpin5Level); 
}
