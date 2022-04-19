
boolean toggleState = false;
boolean newState = false;
boolean prevState = false;


// SET PINS
int relayButtonPin = 37;
int relayActivatePin = 39;

int FSRpinTL = A10;
int FSRpinTR = A11;
int FSRpinBL = A12;
int FSRpinBR = A13;
int score_pin = 41;


//Temp variable to hold FSR analog reading
int valueTL = 0;
int valueTR = 0;
int valueBL = 0; 
int valueBR = 0; 
int total_force_analogue = 0;
int total_force_old = 0;
int senVal[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int i = 0;
int avg = 0; 

void setup()
{
  pinMode(relayButtonPin, INPUT);
  pinMode(relayActivatePin, OUTPUT);
  pinMode(score_pin, OUTPUT);
  Serial.begin(9600);
}
void loop()
{

  // RELAY
  newState = digitalRead(relayButtonPin);
  if((newState != prevState) and (newState == LOW))
  {
      toggleState = !toggleState;
  }
  prevState = newState;

  if (toggleState == true) {
    digitalWrite(relayActivatePin, HIGH);
  } else {
    digitalWrite(relayActivatePin, LOW);
  }


  // PRESSURE SENSOR
  total_force_old = total_force_analogue;
  valueTL = analogRead(FSRpinTL);
  valueTR = analogRead(FSRpinTR);
  valueBL = analogRead(FSRpinBL);
  valueBR = analogRead(FSRpinBR);
  total_force_analogue = (valueTL+valueTR+valueBL+valueBR);

  for (i = 0; i < 10; i = i + 1) {
    avg += senVal[i];
  }
  avg /= 10;
  Serial.print("avg value: ");
  Serial.println(avg);

    //one newton of change will trigger the input pin, about 100 grams
  if(total_force_analogue - avg >= 150){
    digitalWrite(score_pin, HIGH);
    delay(50);
    digitalWrite(score_pin, LOW);
  }

  if (total_force_analogue == 0) {
    Serial.println("No pressure");  
  } 

  Serial.print("total force analog: ");
  Serial.println(total_force_analogue);

  senVal[0] = senVal[1];
  senVal[1] = senVal[2]; 
  senVal[2] = senVal[3];  
  senVal[3] = senVal[4];
  senVal[4] = senVal[5];
  senVal[5] = senVal[6]; 
  senVal[6] = senVal[7]; 
  senVal[7] = senVal[8]; 
  senVal[8] = senVal[9];
  senVal[9] = total_force_analogue;
}
