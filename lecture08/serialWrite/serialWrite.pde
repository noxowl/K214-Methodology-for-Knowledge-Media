import processing.serial.*;
Serial serial;
String serialPortName = "/dev/cu.wchusbserial110";

void setup() {
  serial = new Serial(this, serialPortName, 9600);
}

void draw() {
  if (keyPressed) {
    serial.write('k');
  }
}
