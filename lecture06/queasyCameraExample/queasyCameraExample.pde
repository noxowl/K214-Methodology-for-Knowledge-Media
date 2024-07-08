import queasycam.*;
QueasyCam cam;
PShape model;

void setup() {
  size(1280, 720, P3D);
  perspective();
  queasyCamSetup();
}

void queasyCamSetup() {
  model = loadShape("../data/model/test.obj");
  cam = new QueasyCam(this);
}

void drawQueasySample() {
  background(255);
  pushMatrix();
    translate(200, 0, 200);
    shape(model);
  popMatrix();
  sphere(100);
}

void draw(){
  drawQueasySample();
}
