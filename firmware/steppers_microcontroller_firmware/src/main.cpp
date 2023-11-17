//main.cpp

#include "init.h"
#include "data.h"
#include "motion.h"

Values values;

void setup() {
  Init::initialize();
}

void loop() {
  if (Serial.available() > 0) {
    String input = Serial.readStringUntil('\n');
    String direction;
    Data::processData(input, values.RPM, values.angle, direction);
    Motion::moveMotors(values.RPM, values.angle, direction);
  }
}
