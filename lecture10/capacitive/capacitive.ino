unsigned long counter;

void setup() {
  Serial.begin(9600);
  pinMode(4, OUTPUT);
  pinMode(8, INPUT);
}

void loop() {
  counter = 0;
  digitalWrite(4, HIGH);

  while ( !digitalRead(8) ) {
    counter++;
  }

  digitalWrite(4, LOW);
  Serial.println(counter);
  delay(10);
}
