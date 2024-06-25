int x, y;

void setup() {
  size(800, 600);
}

void draw() {
  background(255, 255, 255);
  if (mousePressed) {
    x = mouseX;
    y = mouseY;
  }
  ellipse(x, y, 300, 300);
}
