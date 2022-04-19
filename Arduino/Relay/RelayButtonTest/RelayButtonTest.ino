int relayButtonPin = 4;
int relayActivatePin = 5;

boolean toggleState = false;
boolean newState = false;
boolean prevState = false;

void setup()
{
  pinMode(relayButtonPin, INPUT);
  pinMode(relayActivatePin, OUTPUT);
  Serial.begin(9600);
}
void loop()
{
  newState = digitalRead(relayButtonPin);
  if((newState != prevState) and (newState == LOW))
  {
      // button has been pressed
      toggleState = !toggleState;
  }
  prevState = newState;
  Serial.println(toggleState);

  if (toggleState == true) {
    digitalWrite(relayActivatePin, HIGH);
  } else {
    digitalWrite(relayActivatePin, LOW);
  }
  
}
