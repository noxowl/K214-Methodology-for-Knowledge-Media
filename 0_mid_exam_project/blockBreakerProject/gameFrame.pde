import java.util.Arrays;
import java.util.Optional;
import java.util.stream.IntStream;

enum RotationState {
  RS_IDLE,
  RS_RIGHT,
  RS_LEFT,
}

RotationState matchState(int keyEventCode) {
  switch(keyEventCode) {
    case LEFT:
      return RotationState.RS_LEFT;
    case RIGHT:
      return RotationState.RS_RIGHT;
    default:
      return RotationState.RS_IDLE;
  }
}

RotationState fixState(RotationState before, int currentkeyEventCode) {
  if (before != RotationState.RS_IDLE && Arrays.stream(LEFTRIGHT).anyMatch(item -> item == currentkeyEventCode)) {
    return matchState(currentkeyEventCode);
  } else if (before == RotationState.RS_IDLE) {
    return matchState(currentkeyEventCode);
  }
  return before;
}

class GameFrame {
  PVector size;
  Coord coord;
  PVector initCenter;
  PVector[] initRect = new PVector[4];
  Collider[] cols = new Collider[4];
  MessageReceiver ownReceiver;
  MessageSender ballMessageSender;
  RotationState lastState = RotationState.RS_IDLE;
  
  GameFrame(PVector size, MessageReceiver ownReceiver, MessageSender ballMessageSender) {
    this.size = size;
    coord = new Coord(1);
    initCenter = new PVector(width / 2, height / 2);
    coord.setCenter(initCenter);
    initRect = relativeRect(size);
    for (int i = 0; i < cols.length; i++) {
      //println(new PVector(initRect[i].x, initRect[i].y));
      if ((initRect[i].x < 0 && initRect[i].y < 0) || (initRect[i].x > 0 && initRect[i].y > 0)) {
        cols[i] = new Collider(new PVector((initRect[i].x * 2) + 3, 10), ColliderType.CL_RECT, coord, new PVector(0, initRect[i].y));
      } else { 
        cols[i] = new Collider(new PVector(10, (initRect[i].y * 2) + 3), ColliderType.CL_RECT, coord, new PVector(initRect[i].x, 0));
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
    this.lastState = fixState(lastState, keyCode);
    if (matchState(keyCode) != RotationState.RS_IDLE) {
      coord.setVelocity(min(coord.getVelocity() + 1, 2));
    }
  }
  
  void onKeyReleased() {
    coord.setVelocity(1);
  }
  
  void onUpdate() {
    pollMessage();
    doRotation();
    Arrays.stream(cols).forEach(col -> col.update());
  }
  
  void doRotation() {
    switch (this.lastState) {
      case RS_RIGHT:
        coord.increaseRotation();
        break;
      case RS_LEFT:
        coord.decreaseRotation();
        break;
      default:
        break;
    }
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
    IntStream.range(0, cols.length).forEach(i -> {
      if (cols[i].isCollided(msg.collider)) {
        cols[i].reflectVector(msg.collider).ifPresent(c -> ballMessageSender.send(new CollisionDetectedMessage(Reflecter.RF_FRAME, c)));
      }
    });
  }
  
  void onRestartMessage(RestartGameMessage msg) {
    println("[Frame] Do restart");
    coord.rotation = 0;
    this.lastState = RotationState.RS_IDLE;
  }
  
  void onDebug() {
    coord.debug();
    Arrays.stream(cols).forEach(col -> col.debug());
  }
}
