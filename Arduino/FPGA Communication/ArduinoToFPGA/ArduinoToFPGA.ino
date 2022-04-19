const int outputPin = 41;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(outputPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  digitalWrite(outputPin, HIGH);
  Serial.println("High");
  delay(1000);
  digitalWrite(outputPin, LOW);
  Serial.println("Low");
  delay(1000);
}
