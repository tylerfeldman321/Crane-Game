const int outputPin = 2;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(outputPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  // The reading will be 3.3V, which is still read as HIGH / 1
  digitalWrite(outputPin, HIGH);
}
