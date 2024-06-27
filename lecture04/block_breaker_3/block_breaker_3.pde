void setup() {
  size(1280, 720);
  arrangeBlocks();
  initBallPosition();
}

void draw() {
  background(255, 255, 255);
  barController();
  moveBall();
  blockCollider();
  renderBar();
  renderBall();
  renderBlock();
}
