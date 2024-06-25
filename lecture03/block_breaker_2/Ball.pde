void moveBall() {
  checkBallFallen();
  checkBallCollision();
  ballX = ballX + ballVX;
  ballY = ballY + ballVY;
  if (ballX > width - ballRadius || ballX < ballRadius) {
    flipBallVelocityX();
  }
  if (ballY < ballRadius) { // ballY > height - ballRadius || 
    flipBallVelocityY();
  }
}

void checkBallCollision() {
  if (ballX > barX && ballX < barX + barWidth) {
    if (ballY + ballRadius > barY && ballY - ballRadius < barY - barHeight) {
      flipBallVelocityY();
      if ( random(2) > 1.0f || barVX > 0.0f ) {
        ballVX = abs(ballVX);
      } else if ( barVX < 0.0f ) {
        ballVX = -abs(ballVX);
      }
    }
  }
}

void checkBallFallen() {
  if (ballY > height) {
    missCounter++;
    ballX = width / 2;
    ballY = 200;
  }
  
  if (missCounter >= 5) {
    println("Game Over!!");
    missCounter = 0;
  }
}

void flipBallVelocityX() {
  ballVX = -ballVX;
}

void flipBallVelocityY() {
  ballVY = -ballVY;
}
  
