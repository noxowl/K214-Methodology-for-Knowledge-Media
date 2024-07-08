class Ball {
  Coord coord;
  Collider collider;
  Sprite sprite;
  PVector directions;
  MessageReceiver ownReceiver;
  MessageSender frameMessageSender;
  MessageSender blockMessageSender;
  
  Ball(MessageReceiver ownReceiver, MessageSender frameMessageSender, MessageSender blockMessageSender) {
    coord = new Coord(5);
    collider = new Collider(ballInitSize, ColliderType.CL_ELLIPSE, coord);
    sprite = new Sprite(ballInitSize, FallbackShape.FB_CIRCLE, "");
    directions = new PVector(0, 1);
    this.ownReceiver = ownReceiver;
    this.frameMessageSender = frameMessageSender;
    this.blockMessageSender = blockMessageSender;
  }
  
  void initPosition(PVector initPos) {
    coord.setCenter(initPos);
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
    } else {
      println("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void sendMessage() {
    var current = new CurrentColliderInfoMessage(collider);
    frameMessageSender.send(current);
    blockMessageSender.send(current);
  }
  
  void onCollisionMessage(CollisionDetectedMessage msg) {
    println("Collided");
    directions.x = -directions.x;
    directions.y = -directions.y;
  }
  
  void move() {
    coord.moveToward(directions);
    collider.update();
    //collider.move(coord.center);
    sprite.move(coord.center);
  }
  
  void onDebug() {
    coord.debug();
    collider.debug();
  }
}
