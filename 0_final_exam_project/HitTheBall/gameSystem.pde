import java.util.Map;

class GameSystem {
  int life;
  int initLife;
  boolean serial;
  MessageReceiver ownReceiver;
  Map<Actor, MessageSender> senderMap;
  
  GameSystem(MessageReceiver ownReceiver, Map<Actor, MessageSender> senderMap) {
    initLife = LIFE;
    life = initLife;
    serial = false;
    this.ownReceiver = ownReceiver;
    this.senderMap = senderMap;
  }
  
  void reduceLife() {
    this.life --;
  }
  
  void resetLife() {
    this.life = initLife;
  }
  
  void retry() {
    reduceLife();
    sendRetryGameMessage();
  }

  void gameOver() {
    GAMEOVER = true;
  }
  
  void restart() {
    GAMECLEAR = false;
    GAMEOVER = false;
    resetLife();
    sendRestartGameMessage();
  }
  
  void onRender() {
    renderMenuBar();
    renderOverlay();
  }
  
  void onUpdate() {
    pollMessage();
  }
  
  void pollMessage() {
    Optional<Message> optMsg = Optional.empty();
    while ((optMsg = ownReceiver.receive()).isPresent()) {
      onMessage(optMsg.get());
    }
  }

  void doRetry() {
    if (life > 0) {
        retry();
      } else {
        gameOver();
      }
  }
  
  void onMessage(Message msg) {
    if (msg instanceof CurrentColliderInfoMessage) {
      CurrentColliderInfoMessage cast = (CurrentColliderInfoMessage) msg;
      onColliderMessage(cast);
    } else if (msg instanceof GameClearMessage) {
      GAMECLEAR = true;
    } else if (msg instanceof EndPitchingMessage) {
      doRetry();
    } else {
      print("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void onColliderMessage(CurrentColliderInfoMessage msg) {
    if (isColliderOnTheBorder(msg.collider)) {
      doRetry();
    }
  }
  
  boolean isColliderOnTheBorder(Collider col) {
    return (col.anchor.center.x < 0 || col.anchor.center.x > width) || (col.anchor.center.y < 0 || col.anchor.center.y > height);
  }
  
  void sendRetryGameMessage() {
    var msg = new RetryGameMessage();
    this.senderMap.get(Actor.AC_BALL).send(msg);
  }
  
  //void sendGameOverMessage() {
  //  var msg = new GameOverMessage();
  //  ballMessageSender.send(msg);
  //  frameMessageSender.send(msg);
  //  blockMessageSender.send(msg);
  //}
  
  void sendRestartGameMessage() {
    var msg = new RestartGameMessage();
    this.senderMap.values().forEach(sender -> sender.send(msg));
  }
  
  void onKeyPressed() {
    if (GAMEOVER && keyCode == ENTER) {
      restart();
    }
  }
  
  void onKeyReleased() {
  }

  void onSerialConnected() {
    this.serial = true;
  }

  void onSerialDisconnected() {
    this.serial = false;
  }
  
  void renderMenuBar() {
    var iconWidth = 20;
    pushMatrix();
      rect(width / 2, 15, width, 30, 0, 0, 48, 48);
      if (serial) {
        fill(0, 255, 0);
        circle(0 + (iconWidth), 15, 10);
      } else {
        fill(255, 0, 0);
        circle(0 + (iconWidth), 15, 10);
      }
      noFill();
      fill(0);
      textSize(16);
      textAlign(CENTER);
      text("Balls : ", width / 2 - (iconWidth * 4), 20);
      noFill();
      IntStream.range(0, initLife).forEachOrdered(i -> {
        if (i > life - 1) {
          fill(153);
        }
        circle(width / 2 - (iconWidth * ((initLife - i) - 1)), 15, 10);
        noFill();
      });
    popMatrix();
  }
  
  void renderOverlay() {
    if (GAMEOVER && !GAMECLEAR) {
      pushMatrix();
        fill(0, 0, 0);
        textSize(64);
        textAlign(CENTER);
        text("GAME OVER", width / 2, height / 1.5);
        textSize(32);
        text("Press 'ENTER' to Restart", width / 2, (height / 1.5) + 80);
        noFill();
      popMatrix();
    } else if (GAMECLEAR) {
      GAMEOVER = true;
      pushMatrix();
        fill(0, 0, 0);
        textSize(64);
        textAlign(CENTER);
        text("GAME CLEAR", width / 2, height / 2);
        textSize(24);
        text("Press 'ENTER' to Restart", width / 2, (height / 2) + 150);
        noFill();
      popMatrix();
    }
  }
}
