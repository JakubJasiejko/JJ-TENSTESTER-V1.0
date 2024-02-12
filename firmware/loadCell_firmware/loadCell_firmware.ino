#include <Arduino.h>
#include "HX711.h"
#include <Wire.h>

String loadCellString = " ";

// Pins
const byte DOUT_PIN = 2;
const byte PD_SCK_PIN = 3;
static const int encoderInterruptPin = 4;

// Variables
static int measurementDelay = 5; 
unsigned long lastMeasurementTime = 0;
float timeOfMeasurement = 0;
const float calFactor = 123.45; 

HX711 scale;

void setup() {
  Serial.begin(9600);
  Wire.begin();

  scale.begin(DOUT_PIN, PD_SCK_PIN);
  scale.tare();
  scale.set_scale(calFactor);
}

void loop() {
  if (Serial.available() > 0) {

    String input = Serial.readStringUntil('\n');
    timeOfMeasurement = input.toFloat();

    int iterations = timeOfMeasurement / measurementDelay;

    Wire.beginTransmission(9); 
    Wire.write(0); 
    Wire.endTransmission();
    scale.tare();

    for (int i = 0; i < iterations; i++) {
      if (micros() - lastMeasurementTime >= measurementDelay) {
        long weight = scale.get_units();
        Serial.println(weight);

        Wire.beginTransmission(9); 
        Wire.write(1); 
        Wire.endTransmission();


        lastMeasurementTime = micros();

        loadCellString += String(weight) + " ";
      }
    }
        Serial.println(loadCellString);
        loadCellString = " ";
        Wire.beginTransmission(9); 
        Wire.write(2); 
        Wire.endTransmission();
  }
}
