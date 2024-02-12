//#include <arduino.h>

//#include "HX711.h"

//int dela = 0;
//encoder pins
static const int encoderPinA = 3;
static const int encoderPinB = 4;

//loadcell pins
//const byte DOUT_PIN = 7;
//const byte CLK_PIN = 8;


//encoder variables
bool encoderPinBState = false;
volatile int encoderPulses = 0;



void interruptService() {
  encoderPinBState = digitalRead(encoderPinB);
  if (encoderPinBState == LOW) {
      //delay(dela);
      encoderPulses++;
     // Serial.print("position: ");  //COMMENT
     // Serial.println(encoderPulses);
    // dataString = String(encoderPulses) + " " + String(force);

  } else if (encoderPinBState == HIGH) {
    //delay(dela);
    encoderPulses--;

   Serial.print("position: ");  //COMMENT
  Serial.println(encoderPulses); //COMMENT

  
  }
  //force = scale.get_units();
//  dataString = String(encoderPulses) + " " + String(force);
 // Serial.println(dataString);  
 // dataString = " ";
}


void setup() {
  Serial.begin(9600);

  pinMode(encoderPinA, INPUT);
  pinMode(encoderPinB, INPUT);

  digitalWrite(encoderPinA, HIGH);
  digitalWrite(encoderPinB, HIGH);






}


void loop() {
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n'); // Read the command from serial
    command.trim();
    
    Serial.println(command); //COMMENT
    //int lenght = command.length(); //COMMENT
    //Serial.println(lenght); //COMMENT

    if (command == "start") {
      Serial.println("started");   //COMMENT
      attachInterrupt(digitalPinToInterrupt(encoderPinA), interruptService, RISING);
    } 
    else if (command == "stop") {
      //Serial.println("STOPPED"); //COMMENT
      detachInterrupt(digitalPinToInterrupt(encoderPinA));
    }
  }
}
