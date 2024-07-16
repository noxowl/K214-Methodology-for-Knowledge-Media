void setup() {
  Serial.begin(9600);
  pinMode(2, OUTPUT);
}

void loop() {
  digitalWrite(2, LOW);
  while (Serial.available() > 0) {
    if ( Serial.read() == 'k' ) {
      digitalWrite(2, HIGH);
    }
  }
  delay(10);
}
