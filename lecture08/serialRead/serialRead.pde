import processing.serial.*;
Serial serial;
String serialPortName = "/dev/cu.wchusbserial110";

void setup() {
  serial = new Serial(this, serialPortName, 9600);
}

void draw() {
  serialEvent(serial);
}

void serialEvent(Serial withPort) {
  while (withPort.available() > 0) {
    char c = serial.readChar();
    print(c);
  }
}
