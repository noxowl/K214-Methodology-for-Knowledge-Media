class Ball {
  Coord coord;
  Collider collider;
  Sprite sprite;
  MessageReceiver ownReceiver;
  MessageSender systemMessageSender;
  MessageSender frameMessageSender;
  MessageSender blockMessageSender;
  PVector initPos;
  
  Ball(MessageReceiver ownReceiver, MessageSender systemMessageSender, MessageSender frameMessageSender, MessageSender blockMessageSender) {
    coord = new Coord(5);
    coord.setDirection(new PVector(0, 1));
    collider = new Collider(ballInitSize, ColliderType.CL_ELLIPSE, coord);
    sprite = new Sprite(ballInitSize, FallbackShape.FB_CIRCLE, "");
    this.initPos = new PVector(0, 0);
    this.ownReceiver = ownReceiver;
    this.systemMessageSender = systemMessageSender;
    this.frameMessageSender = frameMessageSender;
    this.blockMessageSender = blockMessageSender;
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
    } else {
      println("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void sendMessage() {
    var current = new CurrentColliderInfoMessage(collider);
    systemMessageSender.send(current);
    frameMessageSender.send(current);
    blockMessageSender.send(current);
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
    coord.setDirection(new PVector(0, 1));
    initPosition();
  }
  
  void onRestartMessage(RestartGameMessage msg) {
    println("[Ball] Do restart");
    coord.setDirection(new PVector(0, 1));
    coord.moveAbsolute(initPos);
    initPosition();
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
