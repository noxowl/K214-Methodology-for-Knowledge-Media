import java.util.LinkedList;
import java.util.Queue;
import java.util.HashMap;
import java.util.Optional;

enum Actor {
  AC_BALL,
  AC_BLOCK,
  AC_FRAME,
  AC_SYSTEM,
}

interface Message {
}

class PingMessage implements Message {
}

class CurrentColliderInfoMessage implements Message {
  Collider collider;

  CurrentColliderInfoMessage(Collider col) {
    collider = col;
  }
}

class CollisionDetectedMessage implements Message {
  Reflecter reflector;
  PVector reflectVector;
  
  CollisionDetectedMessage(Reflecter reflector, PVector reflectVector) {
    this.reflector = reflector;
    this.reflectVector = reflectVector;
  }
}

class RetryGameMessage implements Message {
}

class GameOverMessage implements Message { }

class RestartGameMessage implements Message {}

class GameClearMessage implements Message {}

class MessageBox {
  Queue<Message> messageBox = new LinkedList<>();
}

class SenderReceiver {
  MessageSender sender;
  MessageReceiver receiver;
  
  SenderReceiver(MessageSender s, MessageReceiver r) {
    sender = s;
    receiver = r;
  }
}

class MessageSender {
  Actor actor;
  Queue<Message> messageQueue;
  
  MessageSender(Actor a, Queue<Message> mq) {
    actor = a;
    messageQueue = mq;
  }
  
  void send(Message message) {
    messageQueue.add(message);
  }
}

class MessageReceiver {
  Actor actor;
  Queue<Message> messageQueue;
  
  MessageReceiver(Actor a, Queue<Message> mq) {
    actor = a;
    messageQueue = mq;
  }
  
  Optional<Message> receive() {
    var msg = Optional.ofNullable(messageQueue.poll());
    return msg;
   }
}

class MessageCenter {
  HashMap<Actor, Queue<Message>> center = new HashMap<>();
  
  SenderReceiver generateChannel(Actor actor) {
    center.put(actor, new LinkedList<>());
    var sender = new MessageSender(actor, center.get(actor));
    var receiver = new MessageReceiver(actor, center.get(actor));
    return new SenderReceiver(sender, receiver);
  }
}
