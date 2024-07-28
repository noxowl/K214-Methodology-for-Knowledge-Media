import java.util.Map;

class Ball {
  Coord coord;
  Collider collider;
  Sprite sprite;
  MessageReceiver ownReceiver;
  Map<Actor, MessageSender> senderMap;
  PVector initPos;
  int initVelocity;
  
  Ball(MessageReceiver ownReceiver, Map<Actor, MessageSender> senderMap) {
    initVelocity = 5;
    coord = new Coord(initVelocity);
    coord.setDirection(new PVector(0, 1));
    collider = new Collider(ballInitSize, ColliderType.CL_ELLIPSE, coord);
    sprite = new Sprite(ballInitSize, FallbackShape.FB_CIRCLE, "");
    this.initPos = new PVector(0, 0);
    this.ownReceiver = ownReceiver;
    this.senderMap = senderMap;
  }
  
  void setInitPosition(PVector initPos) {
    this.initPos = new PVector(initPos.x, initPos.y);
  }
  
  void initPosition() {
    coord.setCenter(new PVector(initPos.x, initPos.y));
  }
  
  void onRender() {
    sprite.render(coord);
  }
  
  void onUpdate() {
    pollMessage();
    move();
    sendMessage();
    //blockMessageSender.send(new CurrentColliderInfoMessage(collider));
  }
  
  void pollMessage() {
    Optional<Message> optMsg = Optional.empty();
    while ((optMsg = ownReceiver.receive()).isPresent()) {
      onMessage(optMsg.get());
    }
  }
  
  void onMessage(Message msg) {
    if (msg instanceof CollisionDetectedMessage) {
      CollisionDetectedMessage cast = (CollisionDetectedMessage) msg;
      onCollisionMessage(cast);
    } else if (msg instanceof RetryGameMessage) {
      RetryGameMessage cast = (RetryGameMessage) msg;
      onRetryMessage(cast);
    }  else if (msg instanceof RestartGameMessage) {
      RestartGameMessage cast = (RestartGameMessage) msg;
      onRestartMessage(cast);
    } else if (msg instanceof StartPitchingMessage) {
      StartPitchingMessage cast = (StartPitchingMessage) msg;
      onStartPitchingMessage(cast);
    } else if (msg instanceof EndPitchingMessage) {
      EndPitchingMessage cast = (EndPitchingMessage) msg;
      onEndPitchingMessage(cast);
    }
    
    else {
      println("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void sendMessage() {
    var current = new CurrentColliderInfoMessage(collider);
    this.senderMap.values().forEach(sender -> sender.send(current));
  }
  
  void onCollisionMessage(CollisionDetectedMessage msg) {
    //println("Collided");
    coord.setDirection(msg.reflectVector);
    if (msg.reflector == Reflecter.RF_FRAME) {
      coord.setBoosted(10);
    }
  }
  
  void onRetryMessage(RetryGameMessage msg) {
    println("[Ball] Do retry");
    coord.setVelocity(initVelocity);
    coord.setDirection(new PVector(0, 1));
    coord.moveAbsolute(initPos);
    initPosition();
  }
  
  void onRestartMessage(RestartGameMessage msg) {
    println("[Ball] Do restart");
    coord.setVelocity(initVelocity);
    coord.setDirection(new PVector(0, 1));
    coord.moveAbsolute(initPos);
    initPosition();
  }

  void onStartPitchingMessage(StartPitchingMessage msg) {
    coord.setVelocity(0);
    coord.moveAbsolute(msg.moveTo);
  }

  void onEndPitchingMessage(EndPitchingMessage msg) {
    coord.setDirection(msg.reflectVector);
    coord.setBoosted(msg.reflectSpeed);
  }
  
  void move() {
    coord.moveToward();
    collider.update();
  }
  
  void onDebug() {
    coord.debug();
    collider.debug();
  }
}
