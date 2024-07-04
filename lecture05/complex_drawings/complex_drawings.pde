float angleValue = 0.1f;

void setup() {
  size(800, 600);
  background(255, 255, 255);
}

void draw() {
  pattern_animation();
}

void simple_rect() {
  pushMatrix();
  rectMode(CENTER);
  translate(width / 2, height /2);
  
  //rotate(radians(30.f));
  rotate(radians(45.f));
  
  scale(0.5f);
  
  rect(0, 0, 300, 300);
  //rect(width / 2, height / 2, 300, 300);
  popMatrix();
}

void rotated_rect() {
  rectMode(CENTER);
  translate(width / 2, height /2);
  background(255, 255, 255);
  for (int i = 0; i < 100; i++){
    //rotate(radians(360.0f / 100));
    rotate(i/3.0f);
    scale(0.9f);
    rect(0, 0, 300, 300);
  }
}

void rotated_ellipse() {
  ellipseMode(CORNER);
  translate(width / 2, height /2);
  background(255, 255, 255);
  for (int i = 0; i < 100; i++){
    //rotate(radians(360.0f / 100));
    rotate(i/3.0f);
    scale(0.99f);
    ellipse(0, 0, 500, 500);
  }
}

void pattern_rect() {
  translate(width / 2, height /2);
  scale(20.0f);
  for (int i = 0; i < 1000; i++){
    fill(i, 255, i / 2);
    rotate(0.1);
    scale(0.99);
    rect(0, 0, 50, 50); 
  }
}

void pattern_animation() {
  background(255);
  translate(mouseX, mouseY);
  scale(20.0f);
  if (keyPressed){
    angleValue = angleValue + 0.01f;
  }
  
  for (int i = 0; i < 1000; i++){
    fill(i, 255, i / 2);
    rotate(angleValue);
    scale(0.99f);
    rect(0, 0, 50, 50);
  }
}
