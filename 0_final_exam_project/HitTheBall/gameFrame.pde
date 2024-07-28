import java.util.Map;
import java.util.Arrays;
import java.util.Optional;
import java.util.stream.IntStream;

class GameFrame {
  PVector size;
  PVector initCenter;
  PVector[] screenDivider = new PVector[2];
  Coord screenDividerCoord = new Coord(1);
  Collider screenDividerCollider;
  PVector[] bottomWalls = new PVector[2];
  Coord[] bottomWallCoords = new Coord[2];
  Collider[] bottomWallCols = new Collider[2];

  PVector[] outerWalls = new PVector[3];
  Coord[] outerWallCoords = new Coord[3];
  Collider[] outerWallCols = new Collider[3];
  
  MessageReceiver ownReceiver;
  Map<Actor, MessageSender> senderMap;
  
  GameFrame(PVector size, MessageReceiver ownReceiver, Map<Actor, MessageSender> senderMap) {
    this.size = size; // the size PVector contains (width, height).
    screenDivider[0] = new PVector(0, size.y);
    screenDivider[1] = new PVector(size.x, size.y);
    screenDividerCollider = new Collider(new PVector(size.x, 16), ColliderType.CL_RECT, screenDividerCoord);
    screenDividerCoord.setCenter(new PVector(size.x / 2, size.y));
    for (int i = 0; i < bottomWalls.length; i++) {
      bottomWalls[i] = new PVector(size.x / 2, 0);
      bottomWallCoords[i] = new Coord(1);
      bottomWallCols[i] = new Collider(new PVector(size.x, 16), ColliderType.CL_RECT, bottomWallCoords[i]);
      if (i == 0) {
        bottomWallCoords[i].setCenter(new PVector(0, size.y / 1.9));
        bottomWallCoords[i].rotation = 45;
      } else {
        bottomWallCoords[i].setCenter(new PVector(size.x, size.y / 1.9));
        bottomWallCoords[i].rotation = 135;
      }
    }
    for (int i = 0; i < outerWalls.length; i++) {
      outerWalls[i] = new PVector(0, size.y);
      outerWallCoords[i] = new Coord(1);
      outerWallCols[i] = new Collider(new PVector(16, size.y), ColliderType.CL_RECT, outerWallCoords[i]);
      if (i == 0) {
        outerWallCoords[i].setCenter(new PVector(-8, size.y / 2));
      } else if (i == 1) {
        outerWallCoords[i].setCenter(new PVector(size.x + 8, size.y / 2));
      } else {
        outerWallCols[i] = new Collider(new PVector(size.x, 16), ColliderType.CL_RECT, outerWallCoords[i]);
        outerWallCoords[i].setCenter(new PVector(size.x / 2, 22));
      }
    }
    initCenter = new PVector(size.x / 2, size.y / 2);
    this.ownReceiver = ownReceiver;
    this.senderMap = senderMap;
  }
  
  void onRender() {
    drawFrame();
  }
  
  void drawFrame() {
     pushMatrix();
       strokeWeight(16);
       beginShape();
         Arrays.stream(screenDivider).forEach(pt -> vertex(pt.x, pt.y));
       endShape(CLOSE);
       beginShape();
         vertex(-15, size.y / 2);
         vertex(bottomWalls[0].x - 95, size.y);
       endShape(CLOSE);
       beginShape();
         vertex(bottomWalls[0].x + 95, size.y);
         vertex(size.x + 15, size.y / 2);
       endShape(CLOSE);
      strokeWeight(1);
      // lower screen
      beginShape();
        ellipse(size.x / 2, size.y * 1.6, size.x * 2.2, size.y);
        ellipse(size.x / 2, size.y * 1.3, size.x * 0.3, size.y * 0.1);
        ellipse(size.x / 2, size.y * 1.85, size.x * 0.7, size.y * 0.3);
      endShape(CLOSE);
      // beginShape();
        // vertex(0, size.y * 2);
        // vertex(bottomWalls[0].x - 95, size.y + (size.y / 3));
      //  endShape(CLOSE);
      // beginShape();
        //  vertex(bottomWalls[0].x + 95, size.y + (size.y / 3));
        //  vertex(size.x + 15, size.y * 2);
      //  endShape(CLOSE);
     popMatrix();
  }
  
  void onUpdate() {
    pollMessage();
    screenDividerCollider.update();
    Arrays.stream(bottomWallCols).forEach(col -> col.update());
    Arrays.stream(outerWallCols).forEach(col -> col.update());
  }
  
  void pollMessage() {
    Optional<Message> optMsg = Optional.empty();
    while ((optMsg = ownReceiver.receive()).isPresent()) {
      onMessage(optMsg.get());
    }
  }
  
  void onMessage(Message msg) {
    if (msg instanceof CurrentColliderInfoMessage) {
      CurrentColliderInfoMessage cast = (CurrentColliderInfoMessage) msg;
      onColliderMessage(cast);
    }  else if (msg instanceof RestartGameMessage) {
      RestartGameMessage cast = (RestartGameMessage) msg;
      onRestartMessage(cast);
    } else {
      print("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void onColliderMessage(CurrentColliderInfoMessage msg) {
    if (screenDividerCollider.isCollided(msg.collider)) {
      // println("[Frame] Frame collided");
      screenDividerCollider.reflectVector(msg.collider).ifPresent(c -> senderMap.get(Actor.AC_BALL).send(new CollisionDetectedMessage(Reflecter.RF_BLOCK, c)));
    }
    IntStream.range(0, bottomWallCols.length).forEach(i -> {
      if (bottomWallCols[i].isCollided(msg.collider)) {
        bottomWallCols[i].reflectVector(msg.collider).ifPresent(c -> senderMap.get(Actor.AC_BALL).send(new CollisionDetectedMessage(Reflecter.RF_BLOCK, c)));
      }
    });
    IntStream.range(0, outerWallCols.length).forEach(i -> {
      if (outerWallCols[i].isCollided(msg.collider)) {
        outerWallCols[i].reflectVector(msg.collider).ifPresent(c -> senderMap.get(Actor.AC_BALL).send(new CollisionDetectedMessage(Reflecter.RF_BLOCK, c)));
      }
    });
  }
  
  void onRestartMessage(RestartGameMessage msg) {
    println("[Frame] Do restart");
  }
  
  void onDebug() {
    screenDividerCollider.debug();
    Arrays.stream(bottomWallCols).forEach(col -> col.debug());
    Arrays.stream(outerWallCols).forEach(col -> col.debug());
  }
}
