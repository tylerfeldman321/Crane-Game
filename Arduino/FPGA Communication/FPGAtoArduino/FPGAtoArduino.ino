const int fpgaInputPin = 2;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(fpgaInputPin, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  // The reading will be 3.3V, which is still read as HIGH / 1
  int reading = digitalRead(fpgaInputPin);
  Serial.println(reading);
}
