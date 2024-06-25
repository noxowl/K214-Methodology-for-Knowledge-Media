void barController() {
  if ( keyPressed ){
    if ( keyCode == RIGHT ){
      if (barX + barWidth < width) {
        barVX = 10.0f;
      }
    } else if ( keyCode == LEFT ) {
      if (barX > 0) {
        barVX = -10.0f;
      }
    }
  } else {
    barVX = 0.0f;
  }
  barX = barX + barVX;
}
