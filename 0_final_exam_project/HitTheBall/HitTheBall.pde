import java.util.Map;
import processing.sound.*;

MessageCenter messageCenter;
GameSystem gameSystem;
GameFrame gameFrame;
BlockManager blockManager;
Ball ball;
Pitcher pitcher;
HTB_Serial serial;

SoundFile countdownReadySound;
SoundFile countdownGoSound;
SoundFile pitchingSound;
SoundFile hitSound;
SoundFile hitFailedSound;

void setup() {
  //size();
  windowResize(round(displayHeight / 1.5), round(displayHeight / 1.1));
  noCursor();
  frameRate(60);
  serial = new HTB_Serial("/dev/cu.wchusbserial110", 9600);
  messageCenter = new MessageCenter();
  var systemChannel = messageCenter.generateChannel(Actor.AC_SYSTEM);
  var blockChannel = messageCenter.generateChannel(Actor.AC_BLOCK);
  var ballChannel = messageCenter.generateChannel(Actor.AC_BALL);
  var frameChannel = messageCenter.generateChannel(Actor.AC_FRAME);
  var pitcherChannel = messageCenter.generateChannel(Actor.AC_PITCHER);
  var gameFrameSize = new PVector(width, height / 1.8);

  gameSystem = new GameSystem(
    systemChannel.receiver,
    Map.of(Actor.AC_BALL, ballChannel.sender, Actor.AC_FRAME, frameChannel.sender, Actor.AC_BLOCK, blockChannel.sender));
  gameFrame = new GameFrame(
    gameFrameSize,
    frameChannel.receiver,
    Map.of(Actor.AC_BALL, ballChannel.sender));
  blockManager = new BlockManager(
    blockChannel.receiver,
    Map.of(Actor.AC_BALL, ballChannel.sender, Actor.AC_SYSTEM, systemChannel.sender),
    new PVector(gameFrameSize.x / 1.5, gameFrameSize.y / 2));
  pitcher = new Pitcher(
    pitcherChannel.receiver,
    Map.of(Actor.AC_BALL, ballChannel.sender, Actor.AC_SYSTEM, systemChannel.sender),
    new PVector(100, 100),
    new PVector(gameFrameSize.x / 2, gameFrameSize.y - 80));
  ball = new Ball(
    ballChannel.receiver,
    Map.of(Actor.AC_BLOCK, blockChannel.sender, Actor.AC_SYSTEM, systemChannel.sender, Actor.AC_FRAME, frameChannel.sender, Actor.AC_PITCHER, pitcherChannel.sender));
  ball.setInitPosition(new PVector(gameFrame.initCenter.x, gameFrame.initCenter.y + 20));
  ball.initPosition();
  
  countdownReadySound = new SoundFile(this, "countdown-ready.wav");
  countdownGoSound = new SoundFile(this, "countdown-go.wav");
  pitchingSound = new SoundFile(this, "cymbal-kick-or-impact.wav");
  hitSound = new SoundFile(this, "snare-or-impact.wav");
  hitFailedSound = new SoundFile(this, "uh-oh-sound.wav");
}

void draw() {
  background(255, 255, 255);
  serialRead();
  render();
  //debug();
  update();
  // delay(1);
}

void keyPressed() {
  gameSystem.onKeyPressed();
  // gameFrame.onKeyPressed();
}

void keyReleased() {
  gameSystem.onKeyReleased();
  pitcher.onKeyReleased();
}

void serialRead() {
  if (serial.isAvailable) {
    int data = serial.read();
    if (data != -1) {
      pitcher.onSerialRead(data);
    }
  }
}

void render() {
  blockManager.onRender();
  pitcher.onRender();
  ball.onRender();
  gameFrame.onRender();
  gameSystem.onRender();
}

void update() {
  gameSystem.onUpdate();
  if (!GAMEOVER) {
    gameFrame.onUpdate();
    pitcher.onUpdate();
    blockManager.onUpdate();
    ball.onUpdate();
  }
}

void debug() {
  gameFrame.onDebug();
  pitcher.onDebug();
  ball.onDebug();
  blockManager.onDebug();
}
