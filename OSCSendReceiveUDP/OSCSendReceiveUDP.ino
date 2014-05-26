
#include <SPI.h>         // needed for Arduino versions later than 0018
#include <Ethernet.h>
#include <OSCMessage.h>
#include <EthernetUdp.h>         // UDP library from: bjoern@cs.stanford.edu 12/30/2008
byte mac[] = {  
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192, 168, 0, 111);
unsigned int localPort = 8888;      // local port to listen on
char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet,
char  ReplyBuffer[] = "acknowledged";       // a string to send back
EthernetUDP Udp;
int led = 13;


void setup() {
  // start the Ethernet and UDP:
  Ethernet.begin(mac,ip);
  Udp.begin(localPort);
}

void loop() {
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();
  if(packetSize)
  {
    IPAddress remote = Udp.remoteIP();
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

void callback(OSCMessage &msg){
   int val = msg.getInt(0); 
    OSCMessage OutMessage("/OSC");
    OutMessage.add(val);
    Udp.beginPacket(Udp.remoteIP(), 9999);
    OutMessage.send(Udp); // send the bytes to the SLIP stream
    Udp.endPacket(); // mark the end of the OSC Packet
    OutMessage.empty(); // free space occupied by message
}

