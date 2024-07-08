float modelsAngle;

void drawModels() {
  background(255);
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  modelsAngle += 0.01f;

  // model 1
  fill(255, 255, 0);
  pushMatrix();
    translate(0, 0, 0);
    rotateZ(modelsAngle);
    beginShape(TRIANGLES);
      vertex(0, -300, 0);
      vertex(300.0f, 300.0f, 0.0f);
      vertex(-300.0f, 300.0f, 0.0f);
    endShape();
  popMatrix();
  
  // model 2
  fill(255, 0, 255);
  pushMatrix();
    translate(-500, 0, 0);
    rotateY(modelsAngle);
    box(100, 200, 300);
  popMatrix();
  
  // model 3
  fill(0, 255, 255);
  pushMatrix();
    translate(500, 0, 0);
    rotateX(modelsAngle);
    sphere(100);
  popMatrix();
}
