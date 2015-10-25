#include <Ethernet.h>
#include <SPI.h>


byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 10, 0, 0, 10 };
byte vp1[] = { 10, 0, 0, 11 };
byte vp2[] = { 10, 0, 0, 12 };
byte vp3[] = { 10, 0, 0, 13 };

EthernetClient client;

void setup()
{
  Ethernet.begin(mac, ip);
  Serial.begin(9600);
  delay(1000);
  Serial.println("connecting...");

  if (client.connect(vp1, 4352)) {
    Serial.println("connected vp1");
  } else {
    Serial.println("connection vp1 failed");
  }
  if (client.connect(vp2, 4352)) {
    Serial.println("connected vp2");
  } else {
    Serial.println("connection vp2 failed");
  }
  if (client.connect(vp3, 4352)) {
    Serial.println("connected vp3");
  } else {
    Serial.println("connection vp3 failed");
  }
}

void loop()

{
  if (client.available()) {
    char c = client.read();
    Serial.print(c);
  }


     if (client.connected()) {
   client.println("%1AVMT 30");
   }
  
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    for(;;)

      ;
  }

}
