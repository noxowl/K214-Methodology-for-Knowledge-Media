import java.util.Optional;

enum Reflecter {
  RF_FRAME,
  RF_BLOCK,
}

enum ColliderType {
  CL_RECT,
  CL_ELLIPSE,
}

class Collider {
  PVector[] rect;
  Coord anchor;
  ColliderType colType;
  PVector[] lastP2S;
  boolean debug = false;
    
  Collider(PVector size, ColliderType colType, Coord anchor) {
    rect = relativeRect(size);
    this.colType = colType;
    this.anchor = anchor;
    this.lastP2S = pointsToScreen(rect);
  }
  
  Collider(PVector size, ColliderType colType, Coord anchor, PVector distance) {
    rect = relativeRectWithDistance(size, distance);
    this.colType = colType;
    this.anchor = anchor;
    this.lastP2S = pointsToScreen(rect);
  }
  
  void debug() {
    debug = true;
  }
  
  void update() {
    pushMatrix();
      translate(anchor.center.x, anchor.center.y);
      rotate(radians(anchor.rotation));
      lastP2S = pointsToScreen(rect);
      
      if (debug) {
        fill(color(255, 204, 0));
        strokeWeight(1);
        beginShape();
          Arrays.stream(rect).forEach(pt -> vertex(pt.x, pt.y));
        endShape(CLOSE);
        noFill();
      }
    popMatrix();
  }
  
  PVector reflect(PVector velocity, PVector normal) {
    float dotProduct = velocity.dot(normal);
    //return PVector.sub(velocity, PVector.mult(normal, 2 * dotProduct));
    return new PVector(
      min(max(velocity.x - 2 * dotProduct * normal.x, -1), 1),
      min(max(velocity.y - 2 * dotProduct * normal.y, -1), 1)
    );
  }
  
  boolean isCollidedWithLine(PVector p, PVector a, PVector b, float size) {
    PVector ab = PVector.sub(b, a);
    PVector ap = PVector.sub(p, a);
    float ab_ap = ab.dot(ap);
    float ab_ab = ab.dot(ab);
    float t = ab_ap / ab_ab;
    if (t < 0.0 || t > 1.0) return false;
    PVector closest = PVector.add(a, PVector.mult(ab, t));
    float distance = PVector.dist(p, closest);
    return distance < size;
  }
  
  Optional<PVector> reflectVector(Collider other) {
    Optional<PVector> result = Optional.empty();
    for (int i = 0; i < lastP2S.length; i++) {
      PVector a = lastP2S[i];
      PVector b = lastP2S[(i + 1) % lastP2S.length];
      if (isCollidedWithLine(other.anchor.center, a, b, (abs(other.rect[0].x) + abs(other.rect[1].x)))) {
        PVector normal = PVector.sub(b, a).rotate(HALF_PI).normalize();
        result = Optional.ofNullable(reflect(other.anchor.direction, normal));
      }
    }
    return result;
  }
  
  boolean isCollided(Collider other) {
    //println("do collision check");
    return polyCollisionCheck(lastP2S, other.lastP2S);
  }
  
  boolean polyCollisionCheck(PVector[] p1, PVector[] p2) {
    int next = 0;
    for (int current = 0; current < p1.length; current++) {
      next = current + 1;
      if (next == p1.length) next = 0;
      
      PVector vc = p1[current];
      PVector vn = p1[next];
      
      boolean collision = lineCollisionCheck(p2, vc.x, vc.y, vn.x, vn.y);
      if (collision) return true;
      
      collision = pointCollisionCheck(p1, p2[0].x, p2[0].y);
      if (collision) return true;
    }
    return false;
  }
  
  boolean lineCollisionCheck(PVector[] vertices, float x1, float y1, float x2, float y2) {
    int next = 0;
    for (int current = 0; current < vertices.length; current++) {
      next = current + 1;
      if (next == vertices.length) next = 0;
      
      float x3 = vertices[current].x;
      float y3 = vertices[current].y;
      float x4 = vertices[next].x;
      float y4 = vertices[next].y;
      
      boolean hit = lineByLine(x1, y1, x2, y2, x3, y3, x4, y4);
      if (hit) return true;
    }
    return false;
  }
  
  boolean lineByLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    float uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
    float uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
  
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) return true;
    return false;
  }
  
  boolean pointCollisionCheck(PVector[] vertices, float px, float py) {
    boolean collision = false;
    int next = 0;
    for (int current = 0; current < vertices.length; current++) {
      next = current + 1;
      if (next == vertices.length) next = 0;
      
      PVector vc = vertices[current];
      PVector vn = vertices[next];
      
      if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) && (px < (vn.x - vc.x) * (py - vc.y) / (vn.y - vc.y) + vc.x)) {
        collision = !collision;
      }
    }
    return collision;
  }
}
