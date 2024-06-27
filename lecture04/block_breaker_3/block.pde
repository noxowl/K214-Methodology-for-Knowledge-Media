void blockCollider() {
  for (int i = 0; i < MAX_BLOCKS; i++) { 
    if ( blockHitFlags[i] == false ){
      if ( ballX > blockXs[i] && ballX < blockXs[i] + blockWidths[i] ){
        if ( ballY > blockYs[i] && ballY < blockYs[i] + blockHeights[i] ){
          ballVY = -ballVY; // ボールが跳ね返る処理
          blockHitFlags[i] = true; // 当たったことにする
        }
      }
    }
  }
}

void arrangeBlocks(){
  for ( int i = 0; i < MAX_BLOCKS; i++ ){
    blockWidths[i] = 100.0f;
    blockHeights[i] = 20.0f;
    blockHitFlags[i] = false;
    blockXs[i] = BLOCK_GAP + i % BLOCK_ROWS * (blockWidths[i] + BLOCK_GAP);
    blockYs[i] = BLOCK_GAP + i / BLOCK_ROWS * (blockHeights[i] + BLOCK_GAP);
  }
}
