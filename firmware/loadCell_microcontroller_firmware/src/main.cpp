#include <Arduino.h>
#include "HX711.h"
#include <Wire.h>

// Pins
const byte DOUT_PIN = 2;
const byte PD_SCK_PIN = 3;
static const int encoderInterruptPin = 4;

// Variables
static int measurementDelay = 1; // Time delay between measurements in microseconds
unsigned long lastMeasurementTime = 0;
unsigned long currentTimeToSend = 0;
float timeOfMeasurement = 0;
const float calFactor = 123.45; // Calibration factor of the load cell
String allMeasurements = "";

// Load cell initialization
HX711 scale;

void setup() {
  Serial.begin(9600);

  pinMode(encoderInterruptPin, OUTPUT);

  Serial.println("ready"); // Comment before uploading to Arduino

  scale.begin(DOUT_PIN, PD_SCK_PIN);

  scale.tare();

  scale.set_scale(calFactor);

  // Initialize I2C communication
  Wire.begin();
}

void loop() {
  if (Serial.available() > 0) {
    // Receive the time duration for measurements as a string
    String input = Serial.readStringUntil('\n');
    timeOfMeasurement = input.toFloat();

    int iterations = timeOfMeasurement / measurementDelay;

    for (int i = 0; i < iterations; i++) {

      digitalWrite(encoderInterruptPin, LOW); // Move if needed to tests
      if (micros() - lastMeasurementTime >= measurementDelay) {

        // Read the weight from the load cell
        digitalWrite(encoderInterruptPin, HIGH);
        long weight = scale.get_units();

        // Append the measurement to the string variable
        allMeasurements += String(weight) + " ";

        // Update the timestamp of the last measurement
        lastMeasurementTime = micros();
      }
    }

    // Send the string variable containing all measurements
    Serial.println(allMeasurements);

    // Send "stop" over I2C
    Wire.beginTransmission(8); // 8 is the I2C address of the receiving device
    Wire.write("stop");
    Wire.endTransmission();

    // Reset the string variable for the next set of measurements
    allMeasurements = "";
  }
}
