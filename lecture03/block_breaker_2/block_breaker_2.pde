void setup() {
  size(1280, 720);
}

void draw() {
  background(255, 255, 255);
  barController();
  moveBall();
  renderBar();
  renderBall();
}
