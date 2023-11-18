// motion.h
// TensTester Control Program
// Author: Jakub Jasiejko
// GitHub: https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0
// License: MIT License

#ifndef MOTION_H
#define MOTION_H

#include <Arduino.h>
#include "pins.h"
#include "values.h"

class Motion {
public:
  static void moveMotors(float RPM, float angle, String direction) {
    float delayDuration = (60 * 1000000) / (Values::steps * RPM);

    for (int i = 0; i < (angle * Values::steps / 360); i++) {
      if (direction == "left") {
        digitalWrite(Pins::dir1Pin, HIGH);
        digitalWrite(Pins::dir2Pin, HIGH);
      } else if (direction == "right") {
        digitalWrite(Pins::dir1Pin, LOW);
        digitalWrite(Pins::dir2Pin, LOW);
      }

      digitalWrite(Pins::step1Pin, HIGH);
      digitalWrite(Pins::step2Pin, HIGH);
      delayMicroseconds(delayDuration);

      digitalWrite(Pins::step1Pin, LOW);
      digitalWrite(Pins::step2Pin, LOW);
      delayMicroseconds(delayDuration);
    }
  }
};

#endif // MOTION_H
