#include <arduino.h>

#include "HX711.h"


//encoder pins
static const int encoderPinA = 3;
static const int encoderPinB = 4;

//loadcell pins
const byte DOUT_PIN = 7;
const byte CLK_PIN = 8;


//encoder variables
bool encoderPinBState = false;
volatile int encoderPulses = 0;

//loadcell variables
const int calFactor = 123.45;
long force = 0;
HX711 scale;

//data
String dataString = " ";

void interruptService() {
  encoderPinBState = digitalRead(encoderPinB);
  if (encoderPinBState == LOW) {
      encoderPulses++;
      force = scale.get_units();
     // Serial.print("position: ");  //COMMENT
     // Serial.println(encoderPulses);
     dataString = String(encoderPulses) + " " + String(force);

  } else if (encoderPinBState == HIGH) {
    encoderPulses--;
    force = scale.get_units();
   // Serial.print("position: ");  //COMMENT
   // Serial.println(encoderPulses); //COMMENT
   dataString = String(encoderPulses) + " " + String(force);
  
  }
  Serial.println(dataString);  //COMMENT
  dataString = " ";
}


void setup() {
  Serial.begin(9600);

  pinMode(encoderPinA, INPUT);
  pinMode(encoderPinB, INPUT);

  digitalWrite(encoderPinA, HIGH);
  digitalWrite(encoderPinB, HIGH);

  scale.begin(DOUT_PIN, CLK_PIN);
  scale.tare();
  scale.set_scale(calFactor);



  attachInterrupt(digitalPinToInterrupt(encoderPinA), interruptService, RISING);

}


void loop() {
 
  }



