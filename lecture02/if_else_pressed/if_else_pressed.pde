void setup() {
  size(800, 600);
}

void draw() {
  background(255, 255, 255);
  if (mousePressed) {
    rect(100, 100, 200, 200);
  } else {
    ellipse(200, 200, 300, 300);
  }
}
