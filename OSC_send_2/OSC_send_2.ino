#include <OSCMessage.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <SPI.h>    

EthernetUDP Udp;

IPAddress ip(192, 168, 0, 111);
IPAddress outIp(192, 168, 0, 29);
const unsigned int outPort = 9999;

 byte mac[] = {  
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
void setup() {
  Ethernet.begin(mac,ip);
    Udp.begin(8888);

}


void loop(){
  //the message wants an OSC address as first argument
  OSCMessage msg("/analog/0");
  msg.add(analogRead(0));

  Udp.beginPacket(outIp, outPort);
  msg.send(Udp); // send the bytes to the SLIP stream
  Udp.endPacket(); // mark the end of the OSC Packet
  msg.empty(); // free space occupied by message

  delay(20);
}
