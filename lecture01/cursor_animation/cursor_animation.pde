void setup() {
  size(800, 600);
  frameRate(30);
}

void draw() {
  background(255, 255, 255);
  line(pmouseX, pmouseY, mouseX, mouseY);
}
