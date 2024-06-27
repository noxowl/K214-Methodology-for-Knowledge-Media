void renderBar() {
  rect(barX, barY, barWidth, barHeight);
}

void renderBall() {
  ellipse(ballX, ballY, ballRadius * 2, ballRadius * 2);
}

void renderBlock() {
  for (int i = 0; i < MAX_BLOCKS; i++) {
    if ( blockHitFlags[i] == false ){
        rect(blockXs[i], blockYs[i], blockWidths[i], blockHeights[i]);
    }
  }
}
