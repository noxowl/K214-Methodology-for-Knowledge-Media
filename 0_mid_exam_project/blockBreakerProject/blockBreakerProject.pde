MessageCenter messageCenter;
GameFrame gameFrame;
BlockManager blockManager;
Ball ball;


void setup() {
  size(1280, 768);
  noCursor();
  frameRate(60);
  messageCenter = new MessageCenter();
  var blockChannel = messageCenter.generateChannel(Actor.AC_BLOCK);
  var ballChannel = messageCenter.generateChannel(Actor.AC_BALL);
  var frameChannel = messageCenter.generateChannel(Actor.AC_FRAME);
  var gameFrameSize = new PVector(width / 2, height / 2);
  gameFrame = new GameFrame(gameFrameSize, frameChannel.receiver, ballChannel.sender);
  blockManager = new BlockManager(blockChannel.receiver, ballChannel.sender);
  ball = new Ball(ballChannel.receiver, frameChannel.sender, blockChannel.sender);
  ball.initPosition(new PVector(gameFrame.initCenter.x, gameFrame.initCenter.y));
}

void draw() {
  background(255, 255, 255);
  render();
  debug();
  update();
  delay(1);
}

void keyPressed() {
  gameFrame.onKeyPressed();
}

void keyReleased() {
  gameFrame.onKeyReleased();
}

void render() {
  gameFrame.onRender();
  ball.onRender();
  blockManager.onRender();
}

void update() {
  gameFrame.onUpdate();
  ball.onUpdate();
  blockManager.onUpdate();
}

void debug() {
  gameFrame.onDebug();
  ball.onDebug();
  blockManager.onDebug();
}
