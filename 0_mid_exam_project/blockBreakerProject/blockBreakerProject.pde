MessageCenter messageCenter;
GameSystem gameSystem;
GameFrame gameFrame;
BlockManager blockManager;
Ball ball;

void setup() {
  size(1280, 768);
  noCursor();
  frameRate(60);
  messageCenter = new MessageCenter();
  var systemChannel = messageCenter.generateChannel(Actor.AC_SYSTEM);
  var blockChannel = messageCenter.generateChannel(Actor.AC_BLOCK);
  var ballChannel = messageCenter.generateChannel(Actor.AC_BALL);
  var frameChannel = messageCenter.generateChannel(Actor.AC_FRAME);
  var gameFrameSize = new PVector(width / 2.3, height / 2);
  gameSystem = new GameSystem(systemChannel.receiver, ballChannel.sender, frameChannel.sender, blockChannel.sender);
  gameFrame = new GameFrame(gameFrameSize, frameChannel.receiver, ballChannel.sender);
  blockManager = new BlockManager(blockChannel.receiver, systemChannel.sender, ballChannel.sender, gameFrameSize);
  ball = new Ball(ballChannel.receiver, systemChannel.sender, frameChannel.sender, blockChannel.sender);
  ball.setInitPosition(new PVector(gameFrame.initCenter.x, gameFrame.initCenter.y + 20));
  ball.initPosition();
}

void draw() {
  background(255, 255, 255);
  render();
  //debug();
  update();
  delay(1);
}

void keyPressed() {
  gameSystem.onKeyPressed();
  gameFrame.onKeyPressed();
}

void keyReleased() {
  gameSystem.onKeyReleased();
  gameFrame.onKeyReleased();
}

void render() {
  blockManager.onRender();
  ball.onRender();
  gameFrame.onRender();
  gameSystem.onRender();
}

void update() {
  gameSystem.onUpdate();
  if (!GAMEOVER) {
    gameFrame.onUpdate();
    blockManager.onUpdate();
    ball.onUpdate();
  }
}

void debug() {
  gameFrame.onDebug();
  ball.onDebug();
  blockManager.onDebug();
}
