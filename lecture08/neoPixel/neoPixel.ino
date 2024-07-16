#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(2, 2, NEO_RGB + NEO_KHZ800);

void setup() {
  pixels.begin();
}
void loop() {
  pixels.setPixelColor( 0, pixels.Color(0, 0, 255) );
  pixels.setPixelColor( 1, pixels.Color(255, 0, 0) );
  pixels.show();
  delay(100);
}
