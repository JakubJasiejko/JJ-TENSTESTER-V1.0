//main_OLD.cpp
// TensTester Control Program
// Author: Jakub Jasiejko
// GitHub: https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0
// License: MIT License

/*
#include <Arduino.h>

static const int step1Pin = 7;
static const int dir1Pin = 6;
static const int en1Pin = 8;

static const int step2Pin = 5;
static const int dir2Pin = 4;
static const int en2Pin = 12;

const int steps = 200;
float angle = 0;
float RPM = 0;
int microSteppingValue = 1;

void setup() {
  Serial.begin(115200);
  Serial.println("WORKING");

  pinMode(step1Pin, OUTPUT);
  pinMode(dir1Pin, OUTPUT);
  pinMode(en1Pin, OUTPUT);

  pinMode(step2Pin, OUTPUT);
  pinMode(dir2Pin, OUTPUT);
  pinMode(en2Pin, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    String data = Serial.readStringUntil('\n');
    int spaceIndex1 = data.indexOf(' ');
    int spaceIndex2 = data.indexOf(' ', spaceIndex1 + 1);

    if (spaceIndex1 != -1 && spaceIndex2 != -1) {
      RPM = data.substring(0, spaceIndex1).toFloat();
      angle = data.substring(spaceIndex1 + 1, spaceIndex2).toFloat();
      String direction = data.substring(spaceIndex2 + 1);

      float delayDuration = (60 * 1000000) / (steps * RPM);

      for (int i = 0; i < (angle * steps / 360); i++) {
        if (direction == "left") {
          digitalWrite(dir1Pin, HIGH);
          digitalWrite(dir2Pin, HIGH);
        } else if (direction == "right") {
          digitalWrite(dir1Pin, LOW);
          digitalWrite(dir2Pin, LOW);
        }

        digitalWrite(step1Pin, HIGH);
        digitalWrite(step2Pin, HIGH);
        delayMicroseconds(delayDuration);

        digitalWrite(step1Pin, LOW);
        digitalWrite(step2Pin, LOW);
        delayMicroseconds(delayDuration);
      }
    }
  }
}
*/