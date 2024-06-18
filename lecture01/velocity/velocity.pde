int x = 0;
int v = 0;
float mx = 0;
float my = 0;

void setup() {
  size(800, 600);
}

void draw() {
  background(255, 255, 255);
  draw_mid();
  draw_mouse();
}

void draw_mid() {
  if (x > width) {
    v = 0;
    x = 0;
  }
  v = v + 1;
  x = x + v;
  println("x = " + x);
  ellipse(x, height / 2, 50, 50);
}

void draw_mouse() {
  mx = mx + (mouseX - mx) / 10;
  my = my + (mouseY - my) / 10;
  ellipse(mx, my, 50, 50);
}
