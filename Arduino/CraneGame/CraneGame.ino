// Include the AccelStepper Library
#include <AccelStepper.h>

// TODO
// Relay - button as input, which should toggle relay
// Take game active input, which should disable electromagnet and motors. (and send motors to waiting mode?)
// LEDS


// ----- BUTTONS -----
// Input Pins
const int right = 25;
const int left = 27;
const int buttonPin_3_CW = 29;
const int buttonPin_3_CCW = 31;

int FSRpinTL = A12;
int FSRpinTR = A13;
int FSRpinBL = A14;
int FSRpinBR = A15;
int score_pin = 49;

int valueTL = 0;
int valueTR = 0;
int valueBL = 0; 
int valueBR = 0; 
int total_force_analogue = 0;
int total_force_old = 0;
int senVal[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int i = 0;
int avg = 0; 


// ----- BUTTONS -----
// Right
int buttonState_right = LOW;             // the current reading from the input pin
int lastButtonState_right = LOW;   // the previous reading from the input pin
int debouncedOutput_right = HIGH;
unsigned long lastDebounceTime_right = 0;  // the last time the output pin was toggled
unsigned long debounceDelay_right = 50;    // the debounce time; increase if the output flickers

// Left
int buttonState_left = LOW;
int lastButtonState_left = LOW;
int debouncedOutput_left = HIGH;
unsigned long lastDebounceTime_left = 0;
unsigned long debounceDelay_left = 50;

// Motor 3 Button CW
int buttonState_3_CW = LOW;
int lastButtonState_3_CW = LOW;
int debouncedOutput_3_CW = HIGH;
unsigned long lastDebounceTime_3_CW = 0;
unsigned long debounceDelay_3_CW = 50;

// Motor 3 Button CCW
int buttonState_3_CCW = LOW;
int lastButtonState_3_CCW = LOW;
int debouncedOutput_3_CCW = HIGH;
unsigned long lastDebounceTime_3_CCW = 0;
unsigned long debounceDelay_3_CCW = 50;

// ----- MOTORS -----
// Define motor interface type
#define motorInterfaceType 1
#define moveDistance 10

const int stepPin_1 = 2;
const int dirPin_1 = 5;
AccelStepper myStepper_1(motorInterfaceType, stepPin_1, dirPin_1);

const int stepPin_2 = 3;
const int dirPin_2 = 6;
AccelStepper myStepper_2(motorInterfaceType, stepPin_2, dirPin_2);

const int stepPin_3 = 4;
const int dirPin_3 = 7;
AccelStepper myStepper_3(motorInterfaceType, stepPin_3, dirPin_3);


void setup() {

  Serial.begin(9600);
  
  pinMode(right, INPUT);
  pinMode(left, INPUT);
  pinMode(buttonPin_3_CW, INPUT);
  pinMode(buttonPin_3_CCW, INPUT);
  pinMode(score_pin, OUTPUT);

  myStepper_1.setCurrentPosition(0);
  myStepper_1.setMaxSpeed(1000);
  myStepper_1.setAcceleration(300);
  myStepper_1.setSpeed(1000);

  myStepper_2.setCurrentPosition(0);
  myStepper_2.setMaxSpeed(1000);
  myStepper_2.setAcceleration(300);
  myStepper_2.setSpeed(1000);

  myStepper_3.setCurrentPosition(0);
  myStepper_3.setMaxSpeed(1000);
  myStepper_3.setAcceleration(300);
  myStepper_3.setSpeed(1000);
}

void loop() {

  // ----- FORCE SENSORS -----
//  total_force_old = total_force_analogue;
//  valueTL = analogRead(FSRpinTL);
//  valueTR = analogRead(FSRpinTR);
//  valueBL = analogRead(FSRpinBL);
//  valueBR = analogRead(FSRpinBR);
//  total_force_analogue = (valueTL+valueTR+valueBL+valueBR);
//
//  if (total_force_analogue == 0) {
//    Serial.println("No pressure");  
//  }
//
//  Serial.print("total force analog: ");
//  Serial.println(total_force_analogue);
//  
//  for (i = 0; i < 10; i = i + 1) {
//    avg += senVal[i];
//  }
//  avg /= 10;
//  Serial.print("avg value: ");
//  Serial.println(avg);
//
//  if(total_force_analogue - avg >= 150){
//    digitalWrite(score_pin, HIGH);
//  }
//
//  senVal[0] = senVal[1];
//  senVal[1] = senVal[2]; 
//  senVal[2] = senVal[3];  
//  senVal[3] = senVal[4];
//  senVal[4] = senVal[5];
//  senVal[5] = senVal[6]; 
//  senVal[6] = senVal[7]; 
//  senVal[7] = senVal[8]; 
//  senVal[8] = senVal[9];
//  senVal[9] = total_force_analogue;


  // ----- DEBOUNCING -----
  // Debounce motor 1 button CW
  int reading_right = digitalRead(right);
  if (reading_right != lastButtonState_right) {
    lastDebounceTime_right = millis();
  }
  if ((millis() - lastDebounceTime_right) > debounceDelay_right) {
    if (reading_right != buttonState_right) {
      buttonState_right = reading_right;
    }
  }
  lastButtonState_right = reading_right;

  // Debounce motor 1 button CCW
  int reading_left = digitalRead(left);
  if (reading_left != lastButtonState_left) {
    lastDebounceTime_left = millis();
  }
  if ((millis() - lastDebounceTime_left) > debounceDelay_left) {
    if (reading_left != buttonState_left) {
      buttonState_left = reading_left;
    }
  }
  lastButtonState_left = reading_left;


  // Debounce motor 3 button CW
  int reading_3_CW = digitalRead(buttonPin_3_CW);
  if (reading_3_CW != lastButtonState_3_CW) {
    lastDebounceTime_3_CW = millis();
  }
  if ((millis() - lastDebounceTime_3_CW) > debounceDelay_3_CW) {
    if (reading_3_CW != buttonState_3_CW) {
      buttonState_3_CW = reading_3_CW;
    }
  }
  lastButtonState_3_CW = reading_3_CW;

  // Debounce motor 3 button CCW
  int reading_3_CCW = digitalRead(buttonPin_3_CCW);
  if (reading_3_CCW != lastButtonState_3_CCW) {
    lastDebounceTime_3_CCW = millis();
  }
  if ((millis() - lastDebounceTime_3_CCW) > debounceDelay_3_CCW) {
    if (reading_3_CCW != buttonState_3_CCW) {
      buttonState_3_CCW = reading_3_CCW;
    }
  }
  lastButtonState_3_CCW = reading_3_CCW;


  // ----- CONTROLLING MOTORS -----
  bool motor_ButtonPressed = (buttonState_right == HIGH) || (buttonState_left == HIGH);
  bool motor_BothButtonsPressed = (buttonState_right == HIGH) && (buttonState_left == HIGH);

  bool motor_3_ButtonPressed = (buttonState_3_CW == HIGH) || (buttonState_3_CCW == HIGH);
  bool motor_3_BothButtonsPressed = (buttonState_3_CW == HIGH) && (buttonState_3_CCW == HIGH);  

  // Don't want both motors moving at the same time
  // For simplicity, will make motor1 have priority
  // Ideally, whatever motor button that was hit last would be running. Could use lastDebounceTime?  
  if (motor_ButtonPressed) {
    // If both buttons pressed, do nothing
    if (motor_BothButtonsPressed) {  
      myStepper_1.move(0);
      myStepper_2.move(0);
    }
    else if (buttonState_right == HIGH) {
      myStepper_1.move(moveDistance);  // Move clockwise
      myStepper_2.move(moveDistance);
    }
    else if (buttonState_left == HIGH) {
      myStepper_1.move(-moveDistance);  // Move clockwise
      myStepper_2.move(-moveDistance);
    }
  } 

  if (motor_3_ButtonPressed) {
    // If both buttons pressed, do nothing
    if (motor_3_BothButtonsPressed) {  
      myStepper_3.move(0);
    }
    else if (buttonState_3_CW == HIGH) {
      myStepper_3.move(moveDistance);  // Move clockwise
    }
    else if (buttonState_3_CCW == HIGH) {
      myStepper_3.move(-moveDistance);  // Move clockwise
    }
  } 


  myStepper_1.run();
  myStepper_2.run();
  myStepper_3.run();
}
