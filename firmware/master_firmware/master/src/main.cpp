#include <Arduino.h>

bool measurement = false;
String encoderString = " ";
String loadCellString = " ";

int RX_BUFFER_SIZE = 256;
int TX_BUFFER_SIZE = 256;

void setup() {
  Serial.begin(9600);    // PC
  Serial1.begin(9600);   // STEPPERS
  Serial2.begin(9600); // ENCODER
  Serial3.begin(9600);    //LOADCELL
}

void loop() {

String rpm, angle, direction, time;

  if (Serial.available() > 0) {
    String receivedData = Serial.readStringUntil('\n');

    int spaceIndex1 = receivedData.indexOf(' ');
    rpm = receivedData.substring(0, spaceIndex1);
    
    int spaceIndex2 = receivedData.indexOf(' ', spaceIndex1 + 1);
    angle = receivedData.substring(spaceIndex1 + 1, spaceIndex2);
    
    int spaceIndex3 = receivedData.indexOf(' ', spaceIndex2 + 1);
    direction = receivedData.substring(spaceIndex2 + 1, spaceIndex3);
    
    time = receivedData.substring(spaceIndex3 + 1);

    String sendData = rpm + " " + angle + " " + direction;
    Serial1.println(sendData);
    Serial.println(sendData);  //COMMENT
    Serial3.println(time);
   // delay(time.toInt()*100);
    measurement = true;
  }
if (measurement == true){
  Serial.println("TRUE");
  while (Serial2.available()){
    encoderString = Serial2.readString();
    Serial.println(encoderString);
  }
  //delay(300);
  //while (Serial3.available() > 0){
    //loadCellString = Serial3.readStringUntil('\n');
    //Serial.println(loadCellString);
  //}
  //delay(300);

  measurement = false;
  //encoderString = " ";
  //loadCellString = " ";
}


}
