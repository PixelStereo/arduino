

// Capteur 1;
int valeurCapteur1 = 0;
int pinCapteur1 = A0;

void setup () {
Serial.begin(9600);
}


void loop () {
  if (Serial.available > 0) {
    if (Serial.read == 'r') {
          valeurCapteur1 = analogRead(pinCapteur1);
    Serial.println(valeurCapteur1)
    }
 }
}
