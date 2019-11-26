#define cPin1 5
#define cPin2 7
//#define cPin3 11
String pulseWidth;
String pWidth1;
String pWidth2;
String pWidth3;
void setup() {
  pinMode(cPin1, OUTPUT);
  pinMode(cPin2, OUTPUT);
//  pinMode(cPin3, OUTPUT);
  Serial.begin(9600); // Default communication rate of the Bluetooth module
}
void loop() {
  pulseWidth = "2300";
  while (Serial.available() == 0){ // Checks whether data is comming from the serial port
    
  }
  pulseWidth = Serial.readStringUntil('\n');//"2300,700,1500,2150\n
  int i, j;
  for (i = 0; pulseWidth.charAt(i) != ','; i++) {
    
  }
//  for (j = i + 1; pulseWidth.charAt(j) != ','; j++) {
    
//  }
  pWidth1 = pulseWidth.substring(0, i);
  pWidth2 = pulseWidth.substring(i + 1, pulseWidth.length());
//  pWidth3 = pulseWidth.substring(j, pulseWidth.length());
  Serial.println(pWidth1);
  Serial.println(pWidth2);
//  Serial.println(pWidth3);
  if (pWidth1 != "1500") {
    digitalWrite(cPin1, HIGH);
    delayMicroseconds((unsigned int) pWidth1.toInt());
    digitalWrite(cPin1, LOW);
  }
  if (pWidth2 != "1500") {
    digitalWrite(cPin2, HIGH);
    delayMicroseconds((unsigned int) pWidth2.toInt());
    digitalWrite(cPin2, LOW); 
  }
//  if (pWidth3 != "1500") {
//    digitalWrite(cPin3, HIGH);
//    delayMicroseconds((unsigned int) pWidth3.toInt());
//    digitalWrite(cPin3, LOW); 
//  }
  delayMicroseconds(10);
}
