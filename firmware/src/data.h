// data.h
// TensTester Control Program
// Author: Jakub Jasiejko
// GitHub: https://github.com/JakubJasiejko/JJ-TENSTESTER-V1.0
// License: MIT License

#ifndef DATA_H
#define DATA_H

#include <Arduino.h>

class Data {
public:
  static void processData(String data, float &RPM, float &angle, String &direction) {
    int spaceIndex1 = data.indexOf(' ');
    int spaceIndex2 = data.indexOf(' ', spaceIndex1 + 1);

    if (spaceIndex1 != -1 && spaceIndex2 != -1) {
      RPM = data.substring(0, spaceIndex1).toFloat();
      angle = data.substring(spaceIndex1 + 1, spaceIndex2).toFloat();
      direction = data.substring(spaceIndex2 + 1);
    }
  }
};

#endif // DATA_H
