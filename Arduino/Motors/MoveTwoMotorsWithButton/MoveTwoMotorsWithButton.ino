// Include the AccelStepper Library
#include <AccelStepper.h>

// ----- BUTTONS -----
// Input Pins
const int buttonPin_1_CW = 2;
const int buttonPin_1_CCW = 3;
const int buttonPin_2_CW = 4;
const int buttonPin_2_CCW = 5;

// Motor 1 Button CW
int buttonState_1_CW = LOW;             // the current reading from the input pin
int lastButtonState_1_CW = LOW;   // the previous reading from the input pin
int debouncedOutput_1_CW = HIGH;
unsigned long lastDebounceTime_1_CW = 0;  // the last time the output pin was toggled
unsigned long debounceDelay_1_CW = 50;    // the debounce time; increase if the output flickers

// Motor 1 Button CCW
int buttonState_1_CCW = LOW;
int lastButtonState_1_CCW = LOW;
int debouncedOutput_1_CCW = HIGH;
unsigned long lastDebounceTime_1_CCW = 0;
unsigned long debounceDelay_1_CCW = 50;

// Motor 2 Button CW
int buttonState_2_CW = LOW;
int lastButtonState_2_CW = LOW;
int debouncedOutput_2_CW = HIGH;
unsigned long lastDebounceTime_2_CW = 0;
unsigned long debounceDelay_2_CW = 50;

// Motor 2 Button CCW
int buttonState_2_CCW = LOW;
int lastButtonState_2_CCW = LOW;
int debouncedOutput_2_CCW = HIGH;
unsigned long lastDebounceTime_2_CCW = 0;
unsigned long debounceDelay_2_CCW = 50;

// ----- MOTORS -----
// Define motor interface type
#define motorInterfaceType 1
#define moveDistance 10

const int dirPin_1 = 8;
const int stepPin_1 = 9;
AccelStepper myStepper_1(motorInterfaceType, stepPin_1, dirPin_1);

const int dirPin_2 = 10;
const int stepPin_2 = 11;
AccelStepper myStepper_2(motorInterfaceType, stepPin_2, dirPin_2);


void setup() {

  Serial.begin(9600);
  
  pinMode(buttonPin_1_CW, INPUT);
  pinMode(buttonPin_1_CCW, INPUT);
  pinMode(buttonPin_2_CW, INPUT);
  pinMode(buttonPin_2_CCW, INPUT);

  myStepper_1.setCurrentPosition(0);
  myStepper_1.setMaxSpeed(1000);
  myStepper_1.setAcceleration(100);
  myStepper_1.setSpeed(400);

  myStepper_2.setCurrentPosition(0);
  myStepper_2.setMaxSpeed(1000);
  myStepper_2.setAcceleration(100);
  myStepper_2.setSpeed(400);
}

void loop() {

  // ----- DEBOUNCING -----
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

  // Debounce motor 2 button CW
  int reading_2_CW = digitalRead(buttonPin_2_CW);
  if (reading_2_CW != lastButtonState_2_CW) {
    lastDebounceTime_2_CW = millis();
  }
  if ((millis() - lastDebounceTime_2_CW) > debounceDelay_2_CW) {
    if (reading_2_CW != buttonState_2_CW) {
      buttonState_2_CW = reading_2_CW;
    }
  }
  lastButtonState_2_CW = reading_2_CW;

  // Debounce motor 2 button CCW
  int reading_2_CCW = digitalRead(buttonPin_2_CCW);
  if (reading_2_CCW != lastButtonState_2_CCW) {
    lastDebounceTime_2_CCW = millis();
  }
  if ((millis() - lastDebounceTime_2_CCW) > debounceDelay_2_CCW) {
    if (reading_2_CCW != buttonState_2_CCW) {
      buttonState_2_CCW = reading_2_CCW;
    }
  }
  lastButtonState_2_CCW = reading_2_CCW;


  // ----- CONTROLLING MOTORS -----
  bool motor_1_ButtonPressed = (buttonState_1_CW == HIGH) || (buttonState_1_CCW == HIGH);
  bool motor_1_BothButtonsPressed = (buttonState_1_CW == HIGH) && (buttonState_1_CCW == HIGH);

  bool motor_2_ButtonPressed = (buttonState_2_CW == HIGH) || (buttonState_2_CCW == HIGH);
  bool motor_2_BothButtonsPressed = (buttonState_2_CW == HIGH) && (buttonState_2_CCW == HIGH);  

  // Don't want both motors moving at the same time
  // For simplicity, will make motor1 have priority
  // Ideally, whatever motor button that was hit last would be running. Could use lastDebounceTime?  
  if (motor_1_ButtonPressed) {
    // If both buttons pressed, do nothing
    if (motor_1_BothButtonsPressed) {  
      myStepper_1.move(0);
    }
    else if (buttonState_1_CW == HIGH) {
      myStepper_1.move(moveDistance);  // Move clockwise
    }
    else if (buttonState_1_CCW == HIGH) {
      myStepper_1.move(-moveDistance);  // Move clockwise
    }
  } 
  else if (motor_2_ButtonPressed){
    // If both buttons pressed, do nothing
    if (motor_2_BothButtonsPressed) {  
      myStepper_2.move(0);
    }
    else if (buttonState_2_CW == HIGH) {
      myStepper_2.move(moveDistance);  // Move clockwise
    }
    else if (buttonState_2_CCW == HIGH) {
      myStepper_2.move(-moveDistance);  // Move clockwise
    }
  }


  myStepper_1.run();
  myStepper_2.run();
}
