// init.h
// TensTester Control Program
// Author: Jakub Jasiejko
// GitHub: https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0
// License: MIT License

#ifndef INIT_H
#define INIT_H

#include <Arduino.h>
#include "pins.h"

class Init {
public:
  static void initialize() {
    Serial.begin(115200);
    Serial.println("WORKING");

    pinMode(Pins::step1Pin, OUTPUT);
    pinMode(Pins::dir1Pin, OUTPUT);
    pinMode(Pins::en1Pin, OUTPUT);

    pinMode(Pins::step2Pin, OUTPUT);
    pinMode(Pins::dir2Pin, OUTPUT);
    pinMode(Pins::en2Pin, OUTPUT);
  }
};

#endif // INIT_H
