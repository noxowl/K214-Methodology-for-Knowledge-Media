void setup() {
  size(800, 600);
  frameRate(30);
  textSize(32);
  background(255, 255, 255);
  println("The window size is");
  println("Width: " + width + " " + "Height: " + height);
}

void draw() {
  display("X: " + mouseX + ", Y: " + mouseY);
  fill(255, 255, 255);
  ellipse(pmouseX, pmouseY, 10, 10);
  line(pmouseX, pmouseY, mouseX, mouseY);
}

void display(String message) {
  fill(255);
  noStroke();
  rect(0, 0, 180, 38);
  stroke(0);
  fill(255, 0, 255);
  text(message, 10, 30);
  return;
}
