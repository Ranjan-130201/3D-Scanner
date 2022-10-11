// 3D Environment Laser Scanner (Arduino)
// By Callan Mackay
// Published on 22/02/2016


#include <Wire.h>


#define A 2
#define B 3
#define C 4
#define D 5

int dir = 9;  // direction, clockwise or counter clockwise
int stp = 10;  // step command 
int pot1 = 0; // speed
int pot2 = 1; // angleEnd
 
#define NUMBER_OF_STEPS_PER_REV 200


void setup(){
  Serial.begin(9600);
pinMode(A,OUTPUT);
pinMode(B,OUTPUT);
pinMode(C,OUTPUT);
pinMode(D,OUTPUT);
}



void write(int a,int b,int c,int d){
digitalWrite(A,a);
digitalWrite(B,b);
digitalWrite(C,c);
digitalWrite(D,d);
}
void stop(){ delay(20);}
void onestep(){
write(1,0,0,0);
delay(5);
stop();
write(1,1,0,0);
delay(5);
stop();
write(0,1,0,0);
delay(5);
stop();
write(0,1,1,0);
delay(5);
stop();
write(0,0,1,0);
delay(5);
stop();
write(0,0,1,1);
delay(5);
write(0,0,0,1);
delay(5);
stop();
write(1,0,0,1);
delay(5);
stop();
}



int del;  
float angle = 0;  
int angleEnd; 
int spd;  

int pass = 0; 
int repeat = 1; 
void loop(){
  int i;
i=0;
while(i<NUMBER_OF_STEPS_PER_REV){
onestep();
i++;
  del = map(analogRead(pot1), 0, 1023, 500, 50); 
  spd = map(analogRead(pot1), 0, 1023, 1, 100);
  angleEnd = map(analogRead(pot2), 0, 1023, 0, 360); 
  if (pass < repeat){ 
    if(pass%2 == 0){  
      digitalWrite(dir, LOW);
      angle = angle + (11.25/4); 
    }
    else if(pass%2 == 1){
      digitalWrite(dir, HIGH); 
      angle = angle - (11.25/4); 
      Serial.println(500.0);  

    digitalWrite(stp, HIGH);  
    delayMicroseconds(300);   
    digitalWrite(stp, LOW);  
  }

  if ((angle >= angleEnd || angle <=0) && pass < repeat){ 
    pass++; 
  }

  Serial.println(angle);  


}}
