import java.util.Arrays;

class GameFrame {
  PVector size;
  Coord coord;
  PVector initCenter;
  PVector[] initRect = new PVector[4];
  Collider[] cols = new Collider[4];
  MessageReceiver ownReceiver;
  MessageSender ballMessageSender;
  
  GameFrame(PVector size, MessageReceiver ownReceiver, MessageSender ballMessageSender) {
    this.size = size;
    coord = new Coord(1);
    initCenter = new PVector(width / 2, height / 2);
    coord.setCenter(initCenter);
    initRect = relativeRect(size);
    for (int i = 0; i < cols.length; i++) {
      println(new PVector(initRect[i].x, initRect[i].y));
      if ((initRect[i].x < 0 && initRect[i].y < 0) || (initRect[i].x > 0 && initRect[i].y > 0)) {
        cols[i] = new Collider(new PVector(initRect[i].x * 2, 5), ColliderType.CL_RECT, coord, new PVector(0, initRect[i].y));
      } else { 
        cols[i] = new Collider(new PVector(5, initRect[i].y * 2), ColliderType.CL_RECT, coord, new PVector(initRect[i].x, 0));
      }
    }
    this.ownReceiver = ownReceiver;
    this.ballMessageSender = ballMessageSender;
  }
  
  void onRender() {
    drawFrame();
  }
  
  void drawFrame() {
    pushMatrix();
      strokeWeight(16);
      translate(initCenter.x, initCenter.y);
      rotate(radians(coord.rotation));
      beginShape();
        Arrays.stream(initRect).forEach(pt -> vertex(pt.x, pt.y));
      endShape(CLOSE);
      strokeWeight(1);
    popMatrix();
  }
  
  void onKeyPressed() {
    coord.setVelocity(min(coord.getVelocity() + 1, 10));
  }
  
  void onKeyReleased() {
    coord.setVelocity(1);
  }
  
  void onUpdate() {
    pollMessage();
    if (isPressed(RIGHT)) {
      coord.increaseRotation();
    }
    if (isPressed(LEFT)) {
      coord.decreaseRotation();
    }
    Arrays.stream(cols).forEach(col -> col.update());
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
    } else {
      print("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void onColliderMessage(CurrentColliderInfoMessage msg) {
    Arrays.stream(cols).forEach(col -> {
      if (col.isCollided(msg.collider)) {
        ballMessageSender.send(new CollisionDetectedMessage(true));
      }
    });
  }
  
  void onDebug() {
    coord.debug();
    Arrays.stream(cols).forEach(col -> col.debug());
  }
}
