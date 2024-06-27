// bar
float barX = 500.0f;
float barY = 600.0f;
float barVX = 5.0f;
float barVY = 5.0f;
float barWidth = 200.0f;
float barHeight = 50.0f;

// ball
final float ballRadius = 10.0f;
final float ballCollider = ballRadius / 2;
float ballX;
float ballY;
float ballVX = 5.0f;
float ballVY = 5.0f;

int missCounter;

void initBallPosition() {
  ballX = barX + (barWidth / 2);
  ballY = barY - ballRadius;
}

// block
final int MAX_BLOCKS = 108;
final int BLOCK_ROWS = 12;
final int BLOCK_GAP = 5;
float [] blockXs = new float[MAX_BLOCKS];
float [] blockYs = new float[MAX_BLOCKS];
float [] blockWidths = new float[MAX_BLOCKS];
float [] blockHeights = new float[MAX_BLOCKS];
boolean [] blockHitFlags = new boolean[MAX_BLOCKS];
