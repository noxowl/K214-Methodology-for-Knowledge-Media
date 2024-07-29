void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.write(intToUint8(voltageToDistance(analogueToVoltage(readAnalogue(0)))));
  delay(50);
}

int readAnalogue(int pin) {
  long scan = 0;
  long scanRate = 30;
  int scanTried = scanRate;
  while (scanTried > 0) {
    scan = scan + analogRead(pin);
    scanTried--;
  }
  return scan / scanRate;
}

int analogueToVoltage(int source) {
  // convert to 0 to 5V (but GP2Y0E03 using 3.3V)
  // Serial.println(source);
  return map(source, 0, 1023, 0, 500);
} 

int voltageToDistance(int source) {
  // convert voltage to distance for sharp GP2Y0E03 by datasheet value (0.5V ~ 2.2V -> 50cm ~ 4cm)
  // Serial.println(source);
  return map(source, 4, 220, 50, 4);
}

uint8_t intToUint8(int source) {
  return source;
}
