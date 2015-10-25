 // Led VU Meter Example

// Version 1.0

// Written by James Newbould




int led[10] = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}; // Assign the pins for the leds

int leftChannel = 0;  // left channel input

int left, i;


// from the smoothing exampel of arduino
const int numReadings = 10;
int readings[numReadings];      // the readings from the analog input
int index = 0;                  // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average



void setup()

{

for (i = 0; i < 10; i++)  // Tell the arduino that the leds are digital outputs

  pinMode(led[i], OUTPUT);


//  Serial.begin(9600); // Uncomment to enable troubleshooting over serial.

// from the smoothing exampel of arduino
  // initialize all the readings to 0: 
  for (int thisReading = 0; thisReading < numReadings; thisReading++)
    readings[thisReading] = 0;          
    
}


void loop()

{
  
  
   // subtract the last reading:
  total= total - readings[index];         
  // read from the sensor:  
  readings[index] = analogRead(leftChannel); 
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
  
  
  
left = average;  // read the left channel

// Serial.println(left);  // uncomment to check the raw input.

   left = left / 10;    // adjusts the sensitivity 

//  Serial.println(left);  // uncomment to check the modified input.

// left = 1500;  // uncomment to test all leds light.

// left = 0;    // uncomment to check the leds are not lit when the input is 0.


  if (left == 0)  // if the volume is 0 then turn off all leds

   {

   for(i = 0; i < 10; i++)

     {

     digitalWrite(led[i], LOW);

     }

  }

 

  else

  {
    

   for (i = 0; i < left; i++) // turn on the leds up to the volume level

    {

     digitalWrite(led[i], HIGH);

    }

   

    for(i = i; i < 10; i++)  // turn off the leds above the voltage level

     {

      digitalWrite(led[i], LOW);

     }

  }

}



