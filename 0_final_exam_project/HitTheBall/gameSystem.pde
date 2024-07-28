import java.util.Map;

class GameSystem {
  int life;
  int initLife;
  MessageReceiver ownReceiver;
  Map<Actor, MessageSender> senderMap;
  
  GameSystem(MessageReceiver ownReceiver, Map<Actor, MessageSender> senderMap) {
    initLife = LIFE;
    life = initLife;
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
  
  void renderMenuBar() {
    var iconWidth = 30;
    pushMatrix();
      rect(width / 2, 15, width, 30, 0, 0, 48, 48);
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
        fill(0, 408, 612);
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
        fill(0, 408, 612);
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
