#include <SPI.h>
#include <Ethernet.h>
#include <ArdOSC.h>

byte myMac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte myIp[]  = { 10, 0, 0, 10 };
int  serverPort  = 10000;
byte vp3[] = { 10, 0, 0, 11};

OSCServer server;

void setup(){ 
   Serial.begin(19200); 
   Ethernet.begin(myMac ,myIp); 
   server.begin(serverPort);
   server.addCallback("/pjlink.1/shutter",&func1);
  }
  
void loop(){
  if(server.aviableCheck()>0){
}
}

void func1(OSCMessage *_mes) {
  int value = _mes->getArgInt32(0);
  if(value == 1){
      Serial.println("UN");
  }
  else{
      Serial.println("ZERO");
   }
}


