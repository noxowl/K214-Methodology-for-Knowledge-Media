int vx = 5;
int vy = 5;
int size = 50;
int border = size / 2;
int x = border;
int y = border;

void setup() {
  size(800, 600);
  frameRate(60);
}

void draw() {
  background(255, 255, 255);
  x = x + vx;
  y = y + vy;
  if (x > width - border || x < border) {
    vx = -vx;
  }
  if (y > height - border || y < border) {
    vy = -vy;
  }
  ellipse(x, y, size, size);
}
