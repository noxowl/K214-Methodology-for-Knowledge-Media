void barController() {
  if ( keyPressed ){
    if ( keyCode == RIGHT ){
      if (barX + barWidth < width) {
        barX = barX + barVX;
      }
    } else if ( keyCode == LEFT ) {
      if (barX > 0) {
        barX = barX - barVX;
      }
    }
  }
}
