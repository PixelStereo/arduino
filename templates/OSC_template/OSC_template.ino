#include <OSCMessage.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <SPI.h>    

EthernetUDP Udp;
char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet,

//the Arduino's IP
IPAddress ip(192, 168, 0, 111);
//destination IP
IPAddress ip_feedback;
const unsigned int outPort = 9999;

 byte mac[] = {  
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; // you can find this written on the board of some Arduino Ethernets or shields
void setup() {
  Ethernet.begin(mac,ip);
    Udp.begin(8888);
}


void loop(){
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();
  if(packetSize)
  {
    ip_feedback = Udp.remoteIP();
    // read the packet into packetBufffer
    Udp.read(packetBuffer,UDP_TX_PACKET_MAX_SIZE);

    // send a reply, to the IP address and port that sent us the packet we received
    OSCMessage InMessage;
    InMessage.add(packetBuffer);
    InMessage.dispatch("/tone", callback); 
    InMessage.empty(); // free space occupied by message
  }
  delay(10);
}


void callback(OSCMessage & msg){
   int val = msg.getInt(1); 
  //the message wants an OSC address as first argument
  OSCMessage Smsg("/analog/0");
  Smsg.add(analogRead(0));
  Udp.beginPacket(ip_feedback, outPort);
  Smsg.send(Udp); // send the bytes to the SLIP stream
  Udp.endPacket(); // mark the end of the OSC Packet
  Smsg.empty(); // free space occupied by message
  delay(20);
}


