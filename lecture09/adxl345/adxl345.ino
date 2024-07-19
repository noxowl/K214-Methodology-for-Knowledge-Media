#include <Wire.h>
#include <ADXL345.h>

ADXL345 adxl;
int x, y, z;

void setup() {
  Serial.begin(9600);
  adxl.powerOn();
}

void loop() {
  adxl.readXYZ(&x, &y, &z);
  Serial.print(x);
  Serial.print(" ");
  Serial.print(y);
  Serial.print(" ");
  Serial.println(z);
  delay(10);
}
