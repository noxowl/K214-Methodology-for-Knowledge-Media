import java.util.Arrays;

class BlockManager {
  Block[] blocks = new Block[20];
  MessageReceiver ownReceiver;
  MessageSender systemMessageSender;
  MessageSender ballMessageSender;
  PVector gameFrameSize;
  
  BlockManager(MessageReceiver ownReceiver, MessageSender systemMessageSender, MessageSender ballMessageSender, PVector gameFrameSize) {
    this.ownReceiver = ownReceiver;
    this.systemMessageSender = systemMessageSender;
    this.ballMessageSender = ballMessageSender;
    this.gameFrameSize = new PVector(gameFrameSize.x, gameFrameSize.y);
    var gameFrameReference = relativeRect(gameFrameSize);
    IntStream.range(0, blocks.length).forEachOrdered(i -> {
      blocks[i] = new Block();
      blocks[i].setInitPosition(new PVector(
        ((width / 1.8) + gameFrameReference[0].x + blockInitSize.x) + i % BLOCKCOLS * (blockInitSize.x + BLOCKGAP),
        ((height / 1.8) - gameFrameReference[0].y + blockInitSize.y) + i / BLOCKCOLS * (blockInitSize.y + BLOCKGAP)));
    });
  }
  
  void onRender() {
    Arrays.stream(blocks).forEach(b -> b.render());
  }
  
  void onUpdate() {
    pollMessage();
    Arrays.stream(blocks).forEach(b -> b.onUpdate());
    if (Arrays.stream(blocks).filter(b -> b.alive).toArray().length == 0) {
      systemMessageSender.send(new GameClearMessage());
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
    } else if (msg instanceof RestartGameMessage) {
      RestartGameMessage cast = (RestartGameMessage) msg;
      onRestartMessage(cast);
    } else {
      print("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void onColliderMessage(CurrentColliderInfoMessage msg) {
    Arrays.stream(this.blocks).forEach(block -> {
      if (block.alive && block.collider.isCollided(msg.collider)) {
        block.collider.reflectVector(msg.collider).ifPresent(c -> {
          block.toggleAlive();
          ballMessageSender.send(new CollisionDetectedMessage(Reflecter.RF_BLOCK, c));
        });
      }
    });
  }
  
  void onRestartMessage(RestartGameMessage msg) {
    print("[Block] do restart");
    Arrays.stream(this.blocks).forEach(block -> {
      block.forceAlive();
    });
  }
  
  void onDebug() {
    Arrays.stream(blocks).forEach(b -> b.onDebug());
  }
}

class Block {
  Coord coord;
  Collider collider;
  Sprite sprite;
  boolean alive = true;
  
  Block() {
    coord = new Coord(0);
    collider = new Collider(new PVector(blockInitSize.x, blockInitSize.y), ColliderType.CL_RECT, coord);
    sprite = new Sprite(blockInitSize, FallbackShape.FB_SQUARE, "");
  }
  
  void setInitPosition(PVector initPosition) {
    coord.setCenter(initPosition);
    collider.update();
    render();
  }
  
  void render() {
    if (alive) {
      sprite.render(coord);
    }
  }
  
  void onUpdate() {
    collider.update();
  }
  
  void toggleAlive() {
    this.alive = !this.alive;
  }
  
  void forceAlive() {
    this.alive = true;
  }
  
  void onDebug() {
    coord.debug();
    collider.debug();
  }
}
