#include <SPI.h>
#include <Ethernet.h>
#include <ArdOSC.h>

byte monIP[] = { 10 , 0 , 0 , 11 };
byte maMac[] = { 0xDE,0xAD,0xBE,0xEF,0xED };
int monUDP = 10000;

byte IP_dest[] = { 10 , 0 , 0 , 1 };
int UDP_dest = 12000;

OSCServer server;
OSCClient client;
// Creation d'un message
OSCMessage newMess;
OSCMessage minMess;
OSCMessage maxMess;

// Capteur 1;
int valeurCapteur1 = 0;
int minCapteur1 = 0;
int maxCapteur1 = 1023;
int calibCapteur1 = 0;
int pinCapteur1 = A0;

void setup () {
Ethernet.begin(maMac,monIP);
server.begin(monUDP);
server.addCallback("/capteur/1/min",&capteur1min);
server.addCallback("/capteur/1/max",&capteur1max);
}

void loop () {
  int result = server.aviableCheck();
          valeurCapteur1 = analogRead(pinCapteur1);
          calibCapteur1 = map(valeurCapteur1,minCapteur1,maxCapteur1,0,1023);
          if (calibCapteur1 < 0)
            calibCapteur1 = 0;
        // Creation d'une destination
        newMess.setAddress(IP_dest,UDP_dest);
        newMess.beginMessage("/capteur/1/val");
        newMess.addArgInt32(valeurCapteur1);
        client.send(&newMess);
        newMess.flush();
        // Creation d'une destination
        newMess.setAddress(IP_dest,UDP_dest);
        newMess.beginMessage("/capteur/1/calib");
        newMess.addArgInt32(calibCapteur1);
        client.send(&newMess);
        newMess.flush();
      }

void capteur1min(OSCMessage *_mes) {
    int value = _mes->getArgInt32(0);
    if (value < 0) {
        minCapteur1 = valeurCapteur1;
        minMess.setAddress(IP_dest,UDP_dest);
        minMess.beginMessage("/capteur/1/min");
        minMess.addArgInt32(minCapteur1);
        client.send(&minMess);
      }
    else {
      minCapteur1 = value;
    }
}

void capteur1max(OSCMessage *_mes) {
    int value = _mes->getArgInt32(0);
    if (value < 0) {
        maxCapteur1 = valeurCapteur1;
        maxMess.setAddress(IP_dest,UDP_dest);
        maxMess.beginMessage("/capteur/1/max");
        maxMess.addArgInt32(maxCapteur1);
        client.send(&maxMess);
    }
    else {
      maxCapteur1 = value;
    }
  }
