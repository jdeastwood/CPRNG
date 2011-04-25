#include "sha256.h"

#define BLOCKSIZE 64

//Global scope variable to track the amount of data recorded so far.
int blockloc;
//Global scope variable to store timing data before hashing it
uint8_t block[BLOCKSIZE];

//Set our pin numbers
int photo = 2;
int led = 13;

//Global to store the state of the photo-intterupter
int state = LOW;

//Global variable to tell us if timing has started
int timestart = false;
//Global timer variables
unsigned long timer;
unsigned long timerval;
                      
void setup() {
  
  //initialise globals
  blockloc = 0;
  for(int i = 0; i < BLOCKSIZE; i++) {
    block[i] = 0;
  }
  
  //Set pin modes
  pinMode(photo, INPUT);
  pinMode(led, OUTPUT);
 
  
  //Start up serial connection, include a delay to avoid wierd startup issues
  Serial.begin(9600);
  delay(5000);
  
}

void loop() {
//Check if the state of the sensor has changed
  if( digitalRead(photo) != state ) {
    //if the timer has started, subtract the timer starting itme from the current time
    if (timestart) {
      timerval = 0;
      timerval = micros() - timer;
      //add the timerval to the block of data to be hashed, one byte at a time
      for(int i = 0; i <4; i++) {
        addTimeData(lowByte(timerval));
        timerval = timerval >> 8;
      }
      //reset the timer
      timestart = false;
    }
    state = !state;
  }
  //start the timer if it isn't started already
  if (!timestart) {
    timer = micros();
    timestart = true;
  }
}

void addTimeData(uint8_t data) {
  if (blockloc < BLOCKSIZE){
    block[blockloc] = data;
    blockloc++;
  }
  if(blockloc == BLOCKSIZE) {
    hashAndPrint();
  }
}

void hashAndPrint() {
 Sha256.init();
 for(int i = 0; i <= BLOCKSIZE; i++) {
   Sha256.print(block[i]);
 } 
 printHash(Sha256.result());
 blockloc = 0;
 for(int i = 0; i <= BLOCKSIZE; i++){
   block[i] = 0;
 }
}

void printHash(uint8_t* hash) {
  int i;
  for (i=0; i<32; i++) {
    Serial.print("0123456789abcdef"[hash[i]>>4]);
    Serial.print("0123456789abcdef"[hash[i]&0xf]);
  }
  Serial.println();
  delay(2000);
}

