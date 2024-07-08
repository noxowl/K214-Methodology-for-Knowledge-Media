PShape model;

void setup(){
  size(1280, 720, P3D);
  perspective();
  //perspective(radians(30.0f), width / height, 10.0f, 5000.0f);
  initPeasyCam();
  loadModel();
}

void draw(){
  eulerRotate();
}

void drawBoxAndMoveCamera() {
  background(255);
  //camera(1000, -1000, 1000, 0, 0, 0, 0, 1, 0);
  camera(mouseX - width / 2, -1000.0f, mouseY - height / 2, 0, 0, 0, 0, 1, 0);
  box(500, 500, 500);
}

void drawVertex() {
  strokeWeight(15); // this should be on the setup
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  beginShape(POINTS);
    vertex(0, 0, 0);
    vertex(100.0f, 100.0f, 0.0f);
    vertex(-100.0f, 100.0f, 0.0f);
  endShape();
}


void drawLines() {
  strokeWeight(15); // this should be on the setup
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  beginShape(LINES);
    vertex(0, 0, 0);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
    vertex(0.0f, 0.0f, 0.0f);
  endShape();
}

void drawTriangles() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  
  beginShape(TRIANGLES);
    fill(255, 0, 255);
    vertex(0, 0, 0);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
    
    fill(0, 255, 255);
    vertex(0, 0, 0);
    vertex(300.0f, -300.0f, 0.0f);
    vertex(-300.0f, -300.0f, 0.0f);
  endShape();
}

void drawQuads() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  beginShape(QUADS);
    vertex(-300.0f, -300.0f, 0);
    vertex(300.0f, -300.0f, 0.0f);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
  endShape();
}

void drawTriangleStrip() {
  strokeWeight(10);
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  beginShape(TRIANGLE_STRIP);
    vertex(-300.0f, -300.0f, 0);
    vertex(300.0f, -300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
    vertex(300.0f, 300.0f, 0.0f);
  endShape();
}


void draw3dCube() {
  //camera(1000, -1000, 1000, 0, 0, 0, 0, 1, 0);
  strokeWeight(10);
  background(255);
  beginShape(TRIANGLE_STRIP);
    // front
    vertex(-300.0f, -300.0f, 0);
    vertex(300.0f, -300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
    vertex(300.0f, 300.0f, 0.0f);
    
    // bottom
    vertex(300.0f, 300.0f, -300.0f);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
    vertex(300.0f, 300.0f, -300.0f);
    
    // left
    //vertex(-300.0f, -300.0f, 0);
    //vertex(300.0f, -300.0f, 0.0f);
    //vertex(-300.0f, 300.0f, 0.0f);
    //vertex(300.0f, 300.0f, 0.0f);
    
    // back
    vertex(-300.0f, -300.0f, -300.0f);
    vertex(300.0f, -300.0f, -300.0f);
    vertex(-300.0f, 300.0f, -300.0f);
    vertex(300.0f, 300.0f, -300.0f);
    
    // right
    // top
    // 나중에 
  endShape();
}

void loadModel() {
  model = loadShape("../data/model/test.obj");
}

void drawPshape() {
  background(255);
  shape(model);
}

void drawAndMoveTriangle() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  fill(255, 255, 0);
  beginShape(TRIANGLES);
    vertex(0.0f + mouseX, -300.0f + mouseY, 0.0f);
    vertex(300.0f + mouseX, 300.0f + mouseY, 0.0f);
    vertex(-300.0f + mouseX, 300.0f + mouseY, 0.0f);
  endShape();
}

void translateTriangle() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  fill(255, 255, 0);
  translate(mouseX, mouseY, 0);
  beginShape(TRIANGLES);
    vertex(0.0f, -300.0f, 0.0f);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
  endShape();
}

void drawAndZoomTriangle() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  fill(255, 255, 0);
  beginShape(TRIANGLES);
    vertex(0.0f * mouseX / 100.0f, -300.0f * mouseY / 100.0f, 0.0f);
    vertex(300.0f * mouseX / 100.0f, 300.0f * mouseY / 100.0f, 0.0f);
    vertex(-300.0f * mouseX / 100.0f, 300.0f * mouseY / 100.0f, 0.0f);
  endShape();
}

void scaleTriangle() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  fill(255, 255, 0);
  scale(mouseX / 100.0f, mouseY / 100.0f, 1.0f);
  beginShape(TRIANGLES);
    vertex(0.0f, -300.0f, 0.0f);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
  endShape();
}

float x1 = 0;
float y1 = -300;
float x2 = 300;
float y2 = 300;
float x3 = -300;
float y3 = 300;
float z1 = 0, z2 = 0, z3 = 0; float angle = radians(30.0f);

void rotateTriangle() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  angle += 0.01f;
  beginShape(TRIANGLES);
    vertex(x1 * cos(angle) - y1 * sin(angle), x1 * sin(angle) + y1 * cos(angle), z1);
    vertex(x2 * cos(angle) - y2 * sin(angle), x2 * sin(angle) + y2 * cos(angle), z2);
    vertex(x3 * cos(angle) - y3 * sin(angle), x3 * sin(angle) + y3 * cos(angle), z3);
  endShape();
}

void rotateZTriangle() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  rotateZ(mouseX / 100.0f);
  beginShape(TRIANGLES);
    vertex(0, -300, 0);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
  endShape();
}

void eulerRotate() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  angle += 0.01f;
  rotateZ(angle);
  rotateY(angle);
  rotateX(angle);
  beginShape(TRIANGLES);
    vertex(0, -300, 0);
    vertex(300.0f, 300.0f, 0.0f);
    vertex(-300.0f, 300.0f, 0.0f);
  endShape();
}
