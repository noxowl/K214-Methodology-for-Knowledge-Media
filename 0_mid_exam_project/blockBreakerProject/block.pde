import java.util.Arrays;

class BlockManager {
  Block[] blocks = new Block[1];
  MessageReceiver ownReceiver;
  MessageSender ballMessageSender;
  
  BlockManager(MessageReceiver ownReceiver, MessageSender ballMessageSender) {
    Arrays.fill(blocks, new Block());
    //Arrays.stream(blocks).forEach(b -> b.init());
    this.ownReceiver = ownReceiver;
    this.ballMessageSender = ballMessageSender;
  }
  
  void onRender() {
    Arrays.stream(blocks).forEach(b -> b.render());
  }
  
  void onUpdate() {
    pollMessage();
    //ballMessageSender.send(new PingMessage());
  }
  
  void pollMessage() {
    Optional<Message> optMsg = Optional.empty();
    while ((optMsg = ownReceiver.receive()).isPresent()) {
      onMessage(optMsg.get());
    }
  }
  
  void onMessage(Message msg) {
    Arrays.stream(blocks).forEach(b -> b.toggleAlive());
    msg = null;
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
    collider = new Collider(blockInitSize, ColliderType.CL_RECT, coord);
    sprite = new Sprite(blockInitSize, FallbackShape.FB_SQUARE, "");
  }
  
  void render() {
    if (alive) {
      sprite.render(coord);
    }
  }
  
  void toggleAlive() {
    this.alive = !this.alive;
  }
  
  void onDebug() {
    coord.debug();
  }
}
