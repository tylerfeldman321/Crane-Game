// Include the AccelStepper Library
#include <AccelStepper.h>

// Define pin connections
const int dirPin_1 = 2;
const int stepPin_1 = 3;


// Motor 1 Button CW
const int buttonPin_1_CW = 7;
int buttonState_1_CW = LOW;             // the current reading from the input pin
int lastButtonState_1_CW = LOW;   // the previous reading from the input pin
int debouncedOutput_1_CW = HIGH;
unsigned long lastDebounceTime_1_CW = 0;  // the last time the output pin was toggled
unsigned long debounceDelay_1_CW = 50;    // the debounce time; increase if the output flickers

// Motor 2 Button CCW
const int buttonPin_1_CCW = 8;
int buttonState_1_CCW = LOW;
int lastButtonState_1_CCW = LOW;
int debouncedOutput_1_CCW = HIGH;
unsigned long lastDebounceTime_1_CCW = 0;
unsigned long debounceDelay_1_CCW = 50;

// Define motor interface type
#define motorInterfaceType 1

#define moveDistance 10

// Creates an instance
AccelStepper myStepper_1(motorInterfaceType, stepPin_1, dirPin_1);

void setup() {

  Serial.begin(9600);
  pinMode(buttonPin_1_CW, INPUT);

  myStepper_1.setCurrentPosition(0);
  myStepper_1.setMaxSpeed(1000);
  myStepper_1.setAcceleration(100);
  myStepper_1.setSpeed(400);
}

void loop() {

  // Debounce motor 1 button CW
  int reading_1_CW = digitalRead(buttonPin_1_CW);
  if (reading_1_CW != lastButtonState_1_CW) {
    lastDebounceTime_1_CW = millis();
  }
  if ((millis() - lastDebounceTime_1_CW) > debounceDelay_1_CW) {
    if (reading_1_CW != buttonState_1_CW) {
      buttonState_1_CW = reading_1_CW;
    }
  }
  lastButtonState_1_CW = reading_1_CW;


   // Debounce motor 1 button CCW
  int reading_1_CCW = digitalRead(buttonPin_1_CCW);
  if (reading_1_CCW != lastButtonState_1_CCW) {
    lastDebounceTime_1_CCW = millis();
  }
  if ((millis() - lastDebounceTime_1_CCW) > debounceDelay_1_CCW) {
    if (reading_1_CCW != buttonState_1_CCW) {
      buttonState_1_CCW = reading_1_CCW;
    }
  }
  lastButtonState_1_CCW = reading_1_CCW;


  if ((buttonState_1_CW == HIGH) || (buttonState_1_CCW == HIGH)) {
    // If both buttons pressed, do nothing
    if ((buttonState_1_CW == HIGH) && (buttonState_1_CCW == HIGH)) {  
      myStepper_1.move(0);
    }
    // 
    else if (buttonState_1_CW == HIGH) {
      myStepper_1.move(moveDistance);  // Move clockwise
    }
    else if (buttonState_1_CCW == HIGH) {
      myStepper_1.move(-moveDistance);  // Move clockwise
    }
  }


  myStepper_1.run();
}
