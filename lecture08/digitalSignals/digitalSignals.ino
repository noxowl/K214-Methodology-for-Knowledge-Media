const int LED = 2;
const int BUTTON = 3;

// the setup function runs once when you press reset or power the board
void setup() {
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
  pinMode(BUTTON, INPUT_PULLUP);
}

// the loop function runs over and over again forever
void loop() {
  Serial.println(digitalRead(BUTTON));
  digitalWrite(LED, !digitalRead(BUTTON));
  delay(10);
}
