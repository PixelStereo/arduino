int inByte = 0;         // incoming serial byte

void setup() {
  Serial.begin(9600);
  pinMode(5, OUTPUT);

}

void loop() {
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    Serial.println(inByte);
    analogWrite(5, inByte);
  }
}

