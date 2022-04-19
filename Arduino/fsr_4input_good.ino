//Using FSR as an input to on an LED
//Written for ThatsEngineering
//Date: 13/01/2021

//Specify Pins
//int LEDpin = 2;
int FSRpinTL = A0;
int FSRpinTR = A1;
int FSRpinBL = A2;
int FSRpinBR = A3;
int score_pin = 2;

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

void setup() {
  Serial.begin(9600);
  //pinMode(LEDpin, OUTPUT);
  pinMode(score_pin, OUTPUT);
  
}

void loop() {
  //set values for individual sensors, calculate total force
  //digitalWrite(score_pin, LOW);
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
    //delay(50);
    //digitalWrite(score_pin, LOW);
    //declare output pin (any digital pin) -> if weight increases by
    //certain amount, set output pin to high, then low
  //need a delay btwn high and low
  }
  
  
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
    
  Serial.print("total force analog: ");
  Serial.println(total_force_analogue);
  
  
  
  
  if (total_force_analogue == 0) {
    Serial.println("No pressure");  
  } 
  

  
 /* //If FSR recieves a force the LED will light up
  if (valueTL > 0 || valueTR >0 || valueBL > 0 || valueBR >0) {
    digitalWrite(LEDpin, HIGH);
  }
  else{
    digitalWrite(LEDpin, LOW);
  }
  */

    Serial.print("force difference: ");
    Serial.println(total_force_analogue-total_force_old);
    
    

  

  Serial.print("Analog reading from FSRTL: ");
  Serial.println(valueTL);
  Serial.print("Analog reading from FSRTR: ");
  Serial.println(valueTR);
  Serial.print("Analog reading from FSRBL: ");
  Serial.println(valueBL);
  Serial.print("Analog reading from FSRBR: ");
  Serial.println(valueBR);
  
  
}
