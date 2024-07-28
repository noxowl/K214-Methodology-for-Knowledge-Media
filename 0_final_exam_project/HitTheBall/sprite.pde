import java.util.Optional;

enum FallbackShape {
  FB_CIRCLE,
  FB_SQUARE,
};

class Sprite {
  Optional<PImage> _sprite = Optional.empty();
  PVector size;
  FallbackShape fallback;
  
  Sprite(PVector size, FallbackShape fb, String imgPath) {
    this.size = size;
    fallback = fb;
    loadSprite(imgPath);
  }
  
  void loadSprite(String path) {
    PImage img;
    try {
      img = loadImage(path);
    } catch (NullPointerException e) {
      img = null;
    }
    _sprite = Optional.ofNullable(img);
  }
  
  void render(Coord coord) {
    pushMatrix();
      _sprite.ifPresentOrElse(
        img -> image(img, coord.getPosX(), coord.getPosY()),
        () -> renderFallback(coord.getPosX(), coord.getPosY())
      );
    popMatrix();
  }
  
  void renderFallback(float cx, float cy) {
    strokeWeight(1);
    switch (fallback) {
      case FB_CIRCLE:
        rectMode(CENTER);
        ellipse(cx, cy, size.x, size.y);
        break;
      case FB_SQUARE:
        rect(cx, cy, size.x, size.y);
        break;
    }
  }
}
