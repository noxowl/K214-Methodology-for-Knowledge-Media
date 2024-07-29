enum BATTING_RESULT {
  JUST,
  GOOD,
  BAD,
  NON
}

class Pitcher {
  PVector pitcherBox = new PVector(1, 1);
  Coord pitcherBoxCoord = new Coord(1);
  Collider pitcherBoxCollider;
  Sprite sprite;
  PVector[] rect = new PVector[4];
  PVector pitcherInitPos = new PVector(0, 0);
  MessageReceiver ownReceiver;
  Map<Actor, MessageSender> senderMap;
  boolean pitching = false;
  boolean batted = false;

  PVector pitchingBallInitPos = new PVector(0, 0);
  int pitchingBallInitDistance = 30;
  int pitchingBallDistance = 0;
  int pitchingStartInitTiming = 85;
  int pitchingStartTiming = 0;
  BATTING_RESULT battingResult = BATTING_RESULT.NON;
  
  Pitcher(MessageReceiver ownReceiver, Map<Actor, MessageSender> senderMap, PVector pitcherInitSize, PVector pitcherInitPos) {
    this.ownReceiver = ownReceiver;
    this.senderMap = senderMap;
    sprite = new Sprite(pitcherInitSize, FallbackShape.FB_SQUARE, "");
    rect = relativeRect(pitcherInitSize);
    pitcherBoxCoord.setCenter(new PVector(0, 0));
    pitcherBoxCollider = new Collider(pitcherInitSize, ColliderType.CL_RECT, pitcherBoxCoord);
    pitcherBoxCoord.setCenter(new PVector(pitcherInitPos.x, pitcherInitPos.y));
    this.pitcherInitPos = new PVector(pitcherInitPos.x, pitcherInitPos.y);
    this.pitchingBallInitPos = new PVector(pitcherInitPos.x, pitcherInitPos.y + 150);
    this.pitchingBallDistance = 100;
    this.pitchingStartTiming = this.pitchingStartInitTiming;
    this.pitchingBallDistance = this.pitchingBallInitDistance;
  }
  
  void onRender() {
    drawFrame();
  }
  
  void drawFrame() {
    // sprite.render(pitcherBoxCoord);
    pushMatrix();
      translate(pitcherInitPos.x, pitcherInitPos.y);
      rotate(radians(pitcherBoxCoord.rotation));
      strokeWeight(1);
        beginShape();
          Arrays.stream(rect).forEach(pt -> vertex(pt.x, pt.y));
        endShape(CLOSE);
      noFill();
    popMatrix();
    if (pitching) {
      drawPitchingBall();
    }
    pushMatrix();
      strokeWeight(5);
      switch (battingResult) {
        case JUST:
          stroke(50, 205, 50);
          break;
        case GOOD:
          stroke(255, 204, 0);
          break;
        case BAD:
          stroke(255, 0, 0);
          // stroke(255, 255, 0);
          break;
        case NON:
          stroke(255, 0, 0);
          break;
      }
      beginShape();
        rect(pitcherInitPos.x, pitcherInitPos.y * 1.9, 100, 130);
      endShape(CLOSE);
      stroke(0, 0, 0);
    popMatrix();
  }
  
  void onUpdate() {
    if (!pitching) {
      pollMessage();
    } else {
      onPitching();
    }
    pitcherBoxCoord.increaseRotation();
    pitcherBoxCollider.update(); 
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
    } else {
      print("Message not supported: " + msg);
    }
    msg = null;
  }
  
  void onColliderMessage(CurrentColliderInfoMessage msg) {
    if (pitcherBoxCollider.isCollided(msg.collider)) {
      senderMap.get(Actor.AC_BALL).send(new StartPitchingMessage(new PVector(pitcherInitPos.x, pitcherInitPos.y - 90)));
      initPitching();
    }
  }
  
  void onDebug() {
    //pitcherBoxCollider.debug();
  }

  void onKeyReleased() {
    if (pitching && pitchingStartTiming <= 0) {
      println("batted timing: " + pitchingBallDistance);
      batted = true;
    }
  }

  void onSerialRead(int data) {
    if (pitching && pitchingStartTiming <= 0) {
      println("sensor data: " + data);
      if (data < 30) {
        batted = true;
      }
    }
  }

  void togglePitching() {
    this.pitching = !this.pitching;
  }

  void initPitching() {
    this.battingResult = BATTING_RESULT.NON;
    this.pitching = true;
    this.batted = false;
    this.pitchingStartTiming = this.pitchingStartInitTiming;
    this.pitchingBallDistance = this.pitchingBallInitDistance;
  }
  
  void onPitching() {
    if (pitchingStartTiming > 0) {
      pitchingStartTiming--;
    } else if (pitchingBallDistance > 0) {
      // println("pitching ball distance: " + pitchingBallDistance);
      if (batted) {
        onBatting();
      }
      if (pitchingBallDistance > 0) {
        pitchingBallDistance--;
      }
    } else {
      onNonBatting();
    }
  }

  void onBatting() {
    // pitching ball timing (speed: 30):
    // ~23: too early
    // 22: too early (but ok)
    // 21: good
    // 20: just
    // ~17: good
    // ~15: too late
    // pitching ball timing (speed: 15):
    // ~22: too early
    // 21: too early (but ok)
    // 20: good
    // 16: just
    // pitching ball timing (speed: 35):
    // ~27: too early
    // 26: good
    // 25~23: just
    // 22: good
    // 21~: too late
    if (pitchingBallDistance > 26) {
      onBadBatting();
    } else if (pitchingBallDistance > 25) {
      onGoodBatting();
    } else if (pitchingBallDistance > 22) {
      onJustBatting();
    } else if (pitchingBallDistance > 20) {
      onGoodBatting();
    } else {
      onBadBatting();
    }
  }

  void onGoodBatting() {
    battingResult = BATTING_RESULT.GOOD;
    println("good batting");
    float x = random(-1, 1);
    float y = random(-0.7, -0.5);
    onHit(new PVector(x, y), 5);
  }

  void onJustBatting() {
    battingResult = BATTING_RESULT.JUST;
    float x = random(-0.5, 0.5);
    float y = random(-1, -0.8);
    println("just batting");
    onHit(new PVector(x, y), 10);
  }

  void onBadBatting() {
    battingResult = BATTING_RESULT.BAD;
    println("bad batting");
    onNonBatting();
  }

  void onHit(PVector vector, int boost) {
    hitSound.play();
    senderMap.get(Actor.AC_BALL).send(new EndPitchingMessage(vector, boost));
    togglePitching();
  }

  void onNonBatting() {
    battingResult = BATTING_RESULT.NON;
    hitFailedSound.play();
    senderMap.get(Actor.AC_SYSTEM).send(new EndPitchingMessage(new PVector(0, 0), 0));
    togglePitching();
  }

  int computePitchingBallDistance() {
    int diff = pitchingBallInitDistance - pitchingBallDistance;
    return diff;
  }

  void drawPitchingBall() {
    pushMatrix();
      fill(255, 0, 0);
      textSize(64);
      textAlign(CENTER);
      if (pitchingStartTiming > pitchingStartInitTiming - 30) {
        if (pitchingStartTiming == pitchingStartInitTiming) {
          countdownReadySound.play();
        }
        text("3", pitchingBallInitPos.x, pitchingBallInitPos.y + 220);
      } else if (pitchingStartTiming > pitchingStartInitTiming - (30 * 2)) {
        if (pitchingStartTiming == pitchingStartInitTiming - 30) {
          countdownReadySound.play();
        }
        text("2", pitchingBallInitPos.x, pitchingBallInitPos.y + 220);
      } else if (pitchingStartTiming > 0) {
        if (pitchingStartTiming == pitchingStartInitTiming - (30 * 2)) {
          countdownGoSound.play();
        }
        text("1", pitchingBallInitPos.x, pitchingBallInitPos.y + 220);
      }
      noFill();

      strokeWeight(1);
        beginShape();
        if (pitchingStartTiming > 0) {
          ellipse(pitchingBallInitPos.x, pitchingBallInitPos.y, 30, 30);
        } else {
          if (pitchingBallDistance > 0) {
            if (pitchingBallDistance == pitchingBallInitDistance) {
              pitchingSound.play();
            }
            int diff = computePitchingBallDistance();
            PVector pitchingBallCurrentPos = new PVector(pitchingBallInitPos.x, pitchingBallInitPos.y + (35 * diff));
            ellipse(pitchingBallCurrentPos.x, pitchingBallCurrentPos.y, 30 + (diff * 3), 30 + (diff * 3));
          }
        }
        endShape(CLOSE);
      noFill();
    popMatrix();
  }
}
