#include <Arduino.h>

String encoderData;
String loadCellData;

bool encoderDataAvailable = false;
bool loadCellDataAvailable = false;

String loadCellTimeValue;
String steppersMotionValue;

void setup() {
  // encoder
  Serial1.begin(9600);

  // load cell
  Serial2.begin(9600);

  // PC
  Serial.begin(9600);

  // steppers
  Serial3.begin(9600);
}

void dataReceiving() {
  // Odbieranie danych z Serial1 (enkoder)
  if (Serial1.available()) {
    encoderData = Serial1.readStringUntil('\n');

    Serial.print("Data from Serial1 (enkoder): ");
    Serial.println(encoderData);
    encoderDataAvailable = true;
  }

  if (Serial2.available()) {
    loadCellData = Serial2.readStringUntil('\n');

    Serial.print("Data from Serial2 (tensometryczna): ");
    Serial.println(loadCellData);

    loadCellDataAvailable = true;
  }
}

void dataToPcSending() {
  if (loadCellDataAvailable && encoderDataAvailable) {
    String dataToSend = loadCellData + ":" + encoderData;
    Serial.println(dataToSend);
  }
}

void eventStarting() {
  if (Serial.available() > 0) {
    String dataForEventStarting = Serial.readStringUntil('\n');
    
    // Podział stringa po spacji
    int spaceIndex = dataForEventStarting.indexOf(':');
    if (spaceIndex != -1) {
      // Pierwsza część do steppersMotionValue
      steppersMotionValue = dataForEventStarting.substring(0, spaceIndex);
      // Druga część do loadCellTimeValue
      loadCellTimeValue = dataForEventStarting.substring(spaceIndex + 1);

      // Wysłanie steppersMotionValue do Serial3
      Serial3.println(steppersMotionValue);
      // Wysłanie loadCellTimeValue do Serial2
      Serial2.println(loadCellTimeValue);
    }
  }
}

void loop() {
   eventStarting();
  dataReceiving();
  dataToPcSending();
  

encoderDataAvailable = false;
loadCellDataAvailable = false;

}
