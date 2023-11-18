// Author: Jakub Jasiejko
// Repository: [JJ-TENSTESTER-V1.0](https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0)
// Date: 18.11.2023
// License: MIT License
// Library: [HX711](https://github.com/bogde/HX711) by Bogdan Necula
//code for loadCell slave microcontroller 

#include <Arduino.h>
#include "HX711.h"
#include <Wire.h>

//pins
const byte DOUT_PIN = 2;
const byte PD_SCK_PIN = 3;

//variables
static int measurementDelay = 1; //time of delay between measurements in microseconds 
unsigned long lastMeasurementTime = 0;
unsigned long currentTimeToSend = 0;
float timeOfMeasurement = 0;
const float calFactor = 123.45; //calibrarion factor of loadCell
String allMeasurements = ""; 

//loadCell initiallization
HX711 scale;

void setup() {
  Serial.begin(9600);
  Wire.begin(8);

  Serial.println("ready"); //comment before send to Arduino

  scale.begin(DOUT_PIN, PD_SCK_PIN);

  scale.tare();

  scale.set_scale(calFactor);
}

void loop() {
  if (Serial.available() > 0) {
    String input = Serial.readStringUntil('\n');
    timeOfMeasurement = input.toFloat();

    int iterations = timeOfMeasurement / measurementDelay;

    for (int i = 0; i < iterations; i++) {

      if (micros() - lastMeasurementTime >= measurementDelay) {
        
        currentTimeToSend = micros();
        Wire.write((byte*)&currentTimeToSend, sizeof(unsigned long));

        long weight = scale.get_units();
        allMeasurements += String(weight) + " "; //timer synchronizing
        lastMeasurementTime = micros();
      }
    }
    
    Serial.println(allMeasurements);    //data sending 
    allMeasurements = "";
  }
}
