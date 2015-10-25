#include <Ethernet.h>
#include <SPI.h>


byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 10, 0, 0, 10 };
byte server[] = { 10, 0, 0, 4 };

EthernetClient client;

void setup()
{
  Ethernet.begin(mac, ip);
  Serial.begin(9600);
  delay(1000);
  Serial.println("connecting...");

  if (client.connect(server, 4352)) {
    Serial.println("connected");
  } else {
    Serial.println("connection failed");
  }
}

void loop()

{
  if (client.available()) {
    char c = client.read();
    Serial.print(c);
  }


     if (client.connected()) {
   client.println("%1AVMT ?");
     delay(1000);
     }
  
  
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    for(;;)

      ;
  }

}
