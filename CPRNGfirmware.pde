#include "sha256.h"

//Global scope variable to track the amount of data recorded so far.
int blockloc;
//Global scope variable to store timing data before hashing it
uint8_t block[64];

//our test block
uint8_t testone[] = {0xba,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,
                      0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,
                      0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,
                      0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,
                      0xaa,0xaa,0xaa,0xaa,0xaa,0xab,0xaa,0xaa,0xaa,0xaa,
                      0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,
                      0xaa,0xaa,0xaa,0xfa};
                      


void setup() {
  blockloc = 0;
  for(int i = 0; i < 64; i++) {
    block[i] = 0;
  }
  Serial.begin(9600);
  delay(5000);
  
  //Test
  for(int i = 0; i < 64; i++){
    delay(200);
    Serial.println(testone[i], DEC);
    addTimeData(testone[i]);
  }
}

void loop() {

}

void addTimeData(uint8_t data) {
  if (blockloc < 64){
    block[blockloc] = data;
    blockloc++;
  }
  if(blockloc == 64) {
    hashAndPrint();
  }
}

void hashAndPrint() {
 Sha256.init();
 for(int i = 0; i <= 64; i++) {
   Sha256.print(block[i]);
 } 
 printHash(Sha256.result());
 blockloc = 0;
 for(int i = 0; i <= 64; i++){
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
