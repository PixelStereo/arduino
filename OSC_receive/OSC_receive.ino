#include <OSCMessage.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <SPI.h>    

EthernetUDP Udp;

//the Arduino's IP
IPAddress ip(192, 168, 0, 111);
//destination IP
IPAddress outIp(192, 168, 0, 29);
const unsigned int outPort = 9999;

 byte mac[] = {  
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; // you can find this written on the board of some Arduino Ethernets or shields
void setup() {
  Ethernet.begin(mac,ip);
    Udp.begin(8888);

}


void loop(){
  OSCMessage msg("/alpha");
msg.add(analogRead(0));
msg.dispatch("/alpha", callback); //full match callback invoked and returns true
}


void callback(OSCMessage & msg){
   int val = msg.getInt(1); 
  //the message wants an OSC address as first argument
  OSCMessage Smsg("/analog/0");
  Smsg.add(analogRead(0));
  Udp.beginPacket(outIp, outPort);
  Smsg.send(Udp); // send the bytes to the SLIP stream
  Udp.endPacket(); // mark the end of the OSC Packet
  Smsg.empty(); // free space occupied by message
  delay(20);
}


