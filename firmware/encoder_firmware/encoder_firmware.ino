#include <arduino.h>
#include <Wire.h>

int lastMeasurementTime = 0;
String encoderString = " ";
bool isSending = false;
//encoder pins
static const int encoderPinA = 3;
static const int encoderPinB = 4;

//encoder variables
bool encoderPinBState = false;
volatile int encoderPulses = 0;

void interruptService() {
  encoderPinBState = digitalRead(encoderPinB);
  if (encoderPinBState == LOW) {  
    encoderPulses++;
  } 
  else if (encoderPinBState == HIGH) {
     encoderPulses--;
      }

}
void setup() {
  
  Serial.begin(9600);
  Wire.begin(9); 
  Wire.onReceive(receiveEvent); 

  pinMode(encoderPinA, INPUT);
  pinMode(encoderPinB, INPUT);

  digitalWrite(encoderPinA, HIGH);
  digitalWrite(encoderPinB, HIGH);

 attachInterrupt(digitalPinToInterrupt(encoderPinA), interruptService, RISING);

}

void receiveEvent() {
  while (Wire.available()) { 
    char receivedChar = Wire.read(); 
    
    if (receivedChar == 0){
      encoderPulses = 0;
    }
    
    if(receivedChar == 1){

    Serial.println(encoderPulses);
    //encoderString += String(encoderPulses) + " ";


    }
  if(receivedChar == 2){
    //Serial.println("skonczylem");
    Serial.println("E");
    encoderString = " ";
  }

}
}
void loop() {
 
}
