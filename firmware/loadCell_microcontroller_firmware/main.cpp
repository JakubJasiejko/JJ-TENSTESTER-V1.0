// main.cpp
#include <Arduino.h>
#include "Pins.h"
#include "Values.h"
#include "Init.h"
#include "Measurement.h"
#include "Communication.h"

Communication communication;

void setup() {
  setupSerial();
  setupWire();
  setupScale();
}

void loop() {
  communication.readInputAndPerformMeasurements();
}
