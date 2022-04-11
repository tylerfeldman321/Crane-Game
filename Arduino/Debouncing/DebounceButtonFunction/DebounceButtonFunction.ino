int buttonState1 = LOW;
const int buttonPin1 = 7;

struct buttonDebounceInfo {
  const int buttonPin;
  int buttonState;
  int lastButtonState;
  unsigned long lastDebounceTime; 
  unsigned long debounceDelay;
};

buttonDebounceInfo* button1_ptr;

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin1, INPUT);

  buttonDebounceInfo button1 = {7, LOW, LOW, 0, 50};

  button1_ptr = &button1;
  Serial.print(button1_ptr -> buttonPin);

}

int debounceButton(struct buttonDebounceInfo * debounceInfo) {
//  int pin = ;
  int buttonState = debounceInfo -> buttonState;
  int lastButtonState = debounceInfo -> lastButtonState;
  unsigned long lastDebounceTime = debounceInfo -> lastDebounceTime;
  unsigned long debounceDelay = debounceInfo -> debounceDelay;  
  
  int reading = digitalRead(7);

  Serial.println(debounceInfo -> buttonPin);
  
  if (reading != lastButtonState) {
    // reset the debouncing timer
    debounceInfo -> lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // whatever the reading is at, it's been there for longer than the debounce
    // delay, so take it as the actual current state:

    // if the button state has changed:
    if (reading != buttonState) {
      debounceInfo -> buttonState = reading;
    }
  }

  debounceInfo -> lastButtonState = reading;
  return buttonState;
}


void loop() {

  

//  buttonState1 = debounceButton(button1_ptr);
//  // buttonState1, lastButtonState1, lastDebounceTime1 = debounceButton(buttonPin1, buttonState1, lastButtonState1, lastDebounceTime1, debounceDelay1);
//
//
//  if (buttonState1 == HIGH) {
//    Serial.println("hi");
//  }

}
