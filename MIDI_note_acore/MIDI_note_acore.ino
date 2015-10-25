void setup() {
  // put your setup code here, to run once:

}
// First parameter is the event type (0x09 = note on, 0x08 = note off).
// Second parameter is note-on/note-off, combined with the channel.
// Channel can be anything between 0-15. Typically reported to the user as 1-16.
// Third parameter is the note number (48 = middle C).
// Fourth parameter is the velocity (64 = normal, 127 = fastest).

void noteOn(byte channel, byte pitch, byte velocity) {
    MIDIEvent noteOn = {0x09, 0x90 | channel, pitch, velocity};
    MIDIUSB.write(noteOn);
}

void noteOff(byte channel, byte pitch, byte velocity) {
    MIDIEvent noteOff = {0x08, 0x80 | channel, pitch, velocity};
    MIDIUSB.write(noteOff);
}

void loop() {
    noteOn(0, 48, 64);   // Channel 0, middle C, normal velocity
    MIDIUSB.flush();
    delay(500);

    noteOff(0, 48, 64);  // Channel 0, middle C, normal velocity
    MIDIUSB.flush();
    delay(1500);
}
