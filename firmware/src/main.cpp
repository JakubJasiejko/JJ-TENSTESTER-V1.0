#include <Arduino.h>

#include "SyncDriver.h"
#include <HX711_ADC.h>

//stepper motors and motion

#define steps 200   //amount of steps per one revolution stepper motor 
float oneStepAngle = 1.8;

#define DIR1 7
#define STEP1 6
#define EN1 8

#define DIR2 4
#define STEP2 5
#define EN2 12

#define V 300 //velocity
#define MS 1 //microsteping

BasicStepperDriver stepper(steps, DIR1, STEP1);
BasicStepperDriver stepper1(steps, DIR2, STEP2);

SyncDriver controller(stepper,stepper1);

int pitch = 2;    //pitch of trapezoidal screw
float p = 13.73;    // stepper motor gear ratio


int v1 = 25; // velocity for slow test [mm/min]
int v2 = 30; //velocity for fast test [mm/min]


#define step 1.8    //angle of one step stepper motor w/o gearbox


float oneRevolution = 360 * p;

float numOfRot = 4;   //number of rotations for fast and slow tests



float turn = oneRevolution * numOfRot;
float numOfSteps = turn / oneStepAngle;


float numOfRotY = 2;    //number of rotations for first part of Young Modulus test
float numOfRotY1 = 2;    //number of rotations for second part of Young Modulus test


#define turnY oneRevolution * numOfRotY //TU ZMIENIASZ, ile obrotow dla 1 czesci modulu Younga
#define turnY1 oneRevolution * numOfRotY1 //TU ZMIENIASZ, ile obrotow dla 2 czesci modulu Younga

float numOfStepsY = turnY / oneStepAngle;
float numOfStepsY1 = turnY1 / oneStepAngle;

#define RPMJOG ((v1*p)/(pitch)) //predkosc dla JOG
#define turnJOG oneRevolution * 2 //wartosc obrotu dla JOG, przy jednym przycisnieciu przycisku

#define RPM1 ((v1*p)/(pitch))
#define RPM2 ((v2*p)/(pitch))

bool movenent = false;
bool slow = false;
bool young = false;
bool up = false;
bool down = false;

//loadcell

const int DTpin = 2;    //DOUT pin HX711 ADX
const int SCKpin = 3;   //SCK

HX711_ADC LoadCell(DTpin, SCKpin);

unsigned long time = 0;
unsigned long currentTime = 0;

double lenghtPerOneRevolution = ((numOfRot * pitch)/numOfSteps);
double lenghtPerOneRevolutionYoungModulus = (((numOfRotY + numOfRotY1) * pitch)/numOfSteps);

int z = 0;    //CZY POMIAR ZACZYNA SIE OD ZERA?????
int l = 0;

void setup() {

float calValue = -310.10; // calibration value

Serial.begin(9600);

Serial.println("TENSTESTER V1.0");
Serial.println("POWERED BY JJ");
Serial.println("TRWA URUCHAMIANIE");

stepper.begin(V,MS);
stepper1.begin(V,MS);

LoadCell.begin();
 
  unsigned long stabTime = 2000; 
  boolean tare = true; 
  LoadCell.start(stabTime, tare);
  if (LoadCell.getTareTimeoutFlag()) 
    {
      Serial.println("CHECK LOADCELL WIRING!");
      while (1);
    }
  else 
    {
      LoadCell.setCalFactor(calValue); 
    }

Serial.println("URZĄDZENIE GOTOWE");
}

void measurment() {
  static boolean newData = 0;
  
  
  if (LoadCell.update()) newData = true;
 
  if (newData) {
    
    
    if (millis() > time) {
      
      float measurment = LoadCell.getData();
      

            double displacement =lenghtPerOneRevolution * z;
            Serial.print("MEASURMENT [N]");
            Serial.print(measurment , 6);
            Serial.print('\t');
            Serial.print("DISPLACEMENT [MM]");
            Serial.print(displacement , 6);          
            Serial.println();

      newData = 0;
      time = millis();
      
  
    }
  
  }

}

void measurmentYoungModulus() {
  static boolean newData = 0;
  
  
  if (LoadCell.update()) newData = true;
 
  if (newData) {
    
    
    if (millis() > time) {
      
      float measurment = LoadCell.getData();
      

            double displacement =lenghtPerOneRevolutionYoungModulus * l;
            Serial.print("MEASURMENT [N]");
            Serial.print(measurment , 6);
            Serial.print('\t');
            Serial.print("DISPLACEMENT [MM]");
            Serial.print(displacement , 6);
            Serial.println();

      newData = 0;
      time = millis();
      
  
    }
  
  }

}


void loop() {
  

  String command = " ";
  int j = 0;

  if (Serial.available() > 0)
    {
    command = Serial.readStringUntil('\n');
      if (command == "M10") //STOP
       {

        movenent = false;
        slow = false;
        young = false;
        

      }
      else if (command == "M11") //test slow
      {
        Serial.println("ROZPOCZYNAM TEST WOLNY");

        movenent = true;
        slow = true;
        young = false;
        up = false;
        down = false;
      }
      else if (command == "M12") //test szybki
      {
        Serial.println("ROZPOCZYNAM TEST SZYBKI");

        movenent = true;
        slow = false;
        young = false;
        up = false;
        down = false;

      }
      
      else if (command == "M13") //test modułu Younga
      
      {
        Serial.println("ROZPOCZYNAM TEST MODULU YOUNGA");
        
        movenent = true;
        slow = false;
        young = true;
        up = false;
        down = false;
      }
      
      else if (command == "M1")
      {
        Serial.println ("ROZPOCZYNAM movenent W GORE");
        Serial.println ("ZACHOWAJ OSTROZNOSC ABY NIE USZKODZIC URZADZENIA");
        
        movenent = false;
        slow = false;
        young = false;
        up = true;
        down = false;

      }
      
      else if (command == "M2")
      {
        
        Serial.println ("ROZPOCZYNAM movenent W DOL");
        Serial.println ("ZACHOWAJ OSTROZNOSC ABY NIE USZKODZIC URZADZENIA");
        
        movenent = false;
        slow = false;
        young = false;
        up = false;
        down = true;

      }
      else
      
      {
        Serial.println ("KOMENDA NIEZNANA");
      }

    }
           if(movenent == true)
       {
            if(slow == true)
              {
                controller.setRPM(RPM1);
                for(int i = 0; i <= (numOfSteps); i++)
                  { 
                  controller.rotate(step , step);
                  measurment();
                  z++;
                  }
              }
            else
              {
                controller.setRPM(RPM2);
                for(int i = 0; i <= (numOfSteps); i++)
                  { 
                  controller.rotate(step , step);
                  measurment();
                  z++;
                 }
              }

            if(young == true)
              {
                controller.setRPM(RPM1);

                  for(int i = 0; i <= (numOfStepsY); i++)
                    { 
                    controller.rotate(step , step);
                    measurmentYoungModulus();                  
                     }
                  controller.setRPM(RPM2);

                  for(int i = 0; i <= (numOfStepsY1); i++)
                    { 
                    controller.rotate(step , step);
                    measurmentYoungModulus();                  
                     }

                  l++;
              }
                
              }
            if (up == true) 
            
              {

                controller.setRPM(RPMJOG);
                controller.rotate(turnJOG ,turnJOG);

              }
              if (down == true)
              {
                  
                  controller.setRPM(RPMJOG);
                  controller.rotate(-turnJOG , -turnJOG);

              }

      z = 0;

      movenent = false;
      slow = false;
      young = false;
      up = false;
      down = false;
}




