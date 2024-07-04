PImage testImage;
float angle;

void setup(){
  size(800, 600, P3D);
  testImage = loadImage("./data/image/blue.png");
  imageMode(CENTER);
  soundSetup();
  playBgm();
  triggerSE();
}

void draw(){
  background(255);
  angle += 0.1f;
  pushMatrix();
    translate(100, 100);
    rotate(angle);
    image(testImage, 0, 0);
  popMatrix();
}
