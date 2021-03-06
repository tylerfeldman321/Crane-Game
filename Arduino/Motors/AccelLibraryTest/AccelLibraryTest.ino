// Include the AccelStepper Library
#include <AccelStepper.h>

// Define pin connections
const int stepPin = 4;  // STEP
const int dirPin = 7;  // DIR

// Define motor interface type
#define motorInterfaceType 1

// Creates an instance
AccelStepper myStepper(motorInterfaceType, stepPin, dirPin);

void setup() {
  // set the maximum speed, acceleration factor,
  // initial speed and the target position
  myStepper.setMaxSpeed(1000);
  myStepper.setAcceleration(50);
  myStepper.setSpeed(200);
  myStepper.moveTo(100);

  Serial.begin(9600);
}

void loop() {
  // Change direction once the motor reaches target position
  if (myStepper.distanceToGo() == 0) 
    myStepper.moveTo(-myStepper.currentPosition());

  Serial.println(myStepper.currentPosition());
    
  // Move the motor one step
  myStepper.run();
}
