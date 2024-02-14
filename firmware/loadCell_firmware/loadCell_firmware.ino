#include <Arduino.h>
#include "HX711.h"
#include <Wire.h>


void(* resetFunc) (void) = 0;
String input = " ";

// Pins
const byte DOUT_PIN = 2;
const byte PD_SCK_PIN = 4;
static const int interruptPin = 3;

// Variables
static int measurementDelay = 10; 
unsigned long lastMeasurementTime = 0;
float timeOfMeasurement = 0;
const float calFactor = 123.45; 
long weight = 0;

HX711 scale;

void interrupt(){
  resetFunc();

}

void setup() {
  Serial.begin(9600);
  Wire.begin();

  attachInterrupt(digitalPinToInterrupt(interruptPin), interrupt, RISING);
  
  scale.begin(DOUT_PIN, PD_SCK_PIN);
  
  scale.tare();
  
  scale.set_scale(calFactor);
}


void loop() {
  if (Serial.available() > 0) {

    input = Serial.readStringUntil('\n');
    input.trim();

    Wire.beginTransmission(9); 
    Wire.write(0); 
    Wire.endTransmission();
    scale.tare();

  if(input == "start"){

      while(1) {
        int time = micros();
        if (micros() - time >= measurementDelay){
        weight = scale.get_units();
        Serial.println(weight);

        Wire.beginTransmission(9); 
        Wire.write(1); 
        
        Wire.endTransmission();


        lastMeasurementTime = micros();

        }
      }
    
        weight = 0;
        Wire.write(2); 
        Wire.endTransmission();
  }
  }
}
