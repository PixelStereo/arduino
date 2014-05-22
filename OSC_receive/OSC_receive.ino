#include <OSCMessage.h>
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <SPI.h>    

EthernetUDP Udp;

//the Arduino's IP
IPAddress ip(192, 168, 0, 111);
//destination IP
IPAddress outIp(192, 168, 0, 145);
const unsigned int outPort = 9999;

 byte mac[] = {  
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; // you can find this written on the board of some Arduino Ethernets or shields
void setup() {
  Ethernet.begin(mac,ip);
    Udp.begin(8888);

}


void loop(){
OSCMessage msg("/alpha");
msg.add(125); 
msg.dispatch("/alpha", callback); //full match callback invoked and returns true
msg.dispatch("/beta", callback); //no match returns false. 


}

void callback(OSCMessage & m){
   int val = m.getInt(); 
}
