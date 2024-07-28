import java.util.Arrays;

PVector[] relativeRect(PVector size) {
  var result = new PVector[4];
  result[0] = new PVector(-(size.x / 2), size.y / 2);
  result[1] = new PVector(size.x / 2, size.y / 2);
  result[2] = new PVector(size.x / 2, -(size.y / 2));
  result[3] = new PVector(-(size.x / 2), -(size.y / 2));
  return result;
}

PVector[] relativeRectWithDistance(PVector size, PVector distance) {
  var result = new PVector[4];
  result[0] = new PVector(-(size.x / 2) + distance.x, (size.y / 2) + distance.y);
  result[1] = new PVector((size.x / 2) + distance.x, (size.y / 2) + distance.y);
  result[2] = new PVector((size.x / 2) + distance.x, -(size.y / 2) + distance.y);
  result[3] = new PVector(-(size.x / 2) + distance.x, -(size.y / 2) + distance.y);
  return result;
}

PVector pointToScreen(PVector point) {
  float sx = screenX(point.x, point.y);
  float sy = screenY(point.x, point.y);
  return new PVector(sx, sy);
}
  
PVector[] pointsToScreen(PVector[] points) {
  PVector[] screenPoints = new PVector[points.length];
  for (int i = 0; i < points.length; i++) {
     screenPoints[i] = pointToScreen(points[i]);
  }
  return screenPoints;
}

//double 

class Coord {
  PVector center;
  float defaultVelocity;
  float velocity;
  int rotation;
  PVector direction;
  int boost;
  
  Coord(float velo) {
    center = new PVector(0, 0);
    direction = new PVector(0, 0);
    velocity = velo;
    defaultVelocity = velo;
  }
  
  float getPosX() {
    return center.x;
  }
  
  float getPosY() {
    return center.y;
  }
  
  float getVelocity() {
    return this.velocity;
  }
  
  void setCenter(PVector newCenter) {
    this.center = new PVector(newCenter.x, newCenter.y);
  }
  
  void setDirection(PVector newDirection) {
    this.direction = new PVector(newDirection.x, newDirection.y);
  }
  
  void increaseRotation() {
    rotation += 1 * velocity;
  }
  
  void decreaseRotation() {
    rotation += -1 * velocity;
  }
  
  void setVelocity(float newV) {
    this.velocity = newV;
  }
  
  void setBoosted(int boost) {
    this.boost = boost;
  }
  
  void moveToward() {
    if (boost > 0) {
      this.velocity = this.defaultVelocity;
      this.velocity *= min(boost, 3);
      this.boost --;
    }
    this.center.x += this.direction.x * this.velocity;
    this.center.y += this.direction.y * this.velocity;
  }
  
  void moveRelative(PVector moveRel) {
    moveRel.x *= velocity;
    moveRel.y *= velocity;
    center.add(moveRel);
  }
  
  void moveAbsolute(PVector moveAbs) {
    center = moveAbs;
  }
  
  void debug() {
    //println("Velocity: " + velocity);
    pushMatrix();
      strokeWeight(3);
      translate(center.x, center.y);
      point(0, 0);
      strokeWeight(1);
    popMatrix();
  }
}
