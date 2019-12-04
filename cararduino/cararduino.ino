/*
 * Define the following pins. Pin 5 controls the servo for the
 * left set of wheels. Pin 7 controls the servo for the right
 * set of wheels. Pin 9 controls the servo for the arm.
 */
#define cPin1 5
#define cPin2 7
#define cPin3 9
/*
 * pulseWidth will hold the String being sent over from the
 * Bluetooth module. pWidth1 is a String for the left servos,
 * pWidth2 is a String for the right servos, and pWidth3 is a
 * String for the servo that controls the arms. These all
 * contain the delay, in microseconds, that is needed to turn
 * the servos in the way specified.
 */
String pulseWidth;
String pWidth1;
String pWidth2;
String pWidth3;
/*
 *  lastPWidth3 holds the last value of pWidth3 before it was
 *  updated. More on this later.
 */
String lastPWidth3;
// The code executed at the beginning of execution.
void setup() {
  // We set up three pins that output data to the servos.
  pinMode(cPin1, OUTPUT);
  pinMode(cPin2, OUTPUT);
  pinMode(cPin3, OUTPUT);
  // pWidth3 is originally 1500.
  lastPWidth3 = "1500";
  Serial.begin(9600); // Default communication rate of the Bluetooth module
}
void loop() {
  // Waits until data comes in from the Serial port.
  while (Serial.available() == 0){ // Checks whether data is coming from the serial port
    
  }
  /*
   * Holds the microsecond values that were sent from the
   * Processing program, delimited by commas. These will later
   * to describe the pulse width being sent to each servo.
   */
  // The Serial string is read until a newline character.
  pulseWidth = Serial.readStringUntil('\n');//"2300,700,1500\n"
  // Define two variables i and j.
  int i, j;
  /*
   *  Characters of the pulseWidth variable are read until the
   *  first comma is found. The loop will close and we will
   *  have a value of i that represents the index of that
   *  character.
   */
  for (i = 0; pulseWidth.charAt(i) != ','; i++) {
    
  }
  /*
   *  Characters of the pulseWidth variable are read until the
   *  second comma is found. The loop will close and we will
   *  have a value of j that represents the index of that
   *  character.
   */
  for (j = i + 1; pulseWidth.charAt(j) != ','; j++) {
    
  }
  /*
   * Put the substring values into these three variables so we
   * get each value represented in the pulseWidth variable.
   */
  pWidth1 = pulseWidth.substring(0, i);
  pWidth2 = pulseWidth.substring(i + 1, j);
  pWidth3 = pulseWidth.substring(j + 1, pulseWidth.length());
  /*
   * If the pulse width of pWidth1 is not 1500 (so we don't work
   * the motors unnecessarily when it's not turning), ...
   */
  if (pWidth1 != "1500") {
  /*
  * Send a signal over with a pulse width of the parsed value
  * of the the pWidth1 string. Write HIGH for the length of
  * this time, in microseconds, and then write LOW.
  */
  digitalWrite(cPin1, HIGH);
  delayMicroseconds((unsigned int) pWidth1.toInt());
  digitalWrite(cPin1, LOW);
  }
  /*
   * If the pulse width of pWidth2 is not 1500 (so we don't work
   * the motors unnecessarily when it's not turning), ...
   */
  if (pWidth2 != "1500") {
  /*
  * Send a signal over with a pulse width of the parsed value
  * of the the pWidth2 string. Write HIGH for the length of
  * this time, in microseconds, and then write LOW.
  */
  digitalWrite(cPin2, HIGH);
  delayMicroseconds((unsigned int) pWidth2.toInt());
  digitalWrite(cPin2, LOW);
  }
  /*
   * If the pulse width of pWidth3 is not what it was previously
   * (so we don't work the motors unnecessarily when it's not
   * turning), ...
   */
  if (pWidth3 != lastPWidth3) {
  /*
   * Send a signal over with a pulse width of the parsed value
   * of the the pWidth3 string. Write HIGH for the length of
   * this time, in microseconds, and then write LOW.
   */
  digitalWrite(cPin3, HIGH);
  delayMicroseconds((unsigned int) pWidth3.toInt());
  digitalWrite(cPin3, LOW);
  }
  /* This line of code updates lastPWidth3 to pWidth3 so that
   * the next time this loop executes we can see if the pulse
   * width changed.
   */
  lastPWidth3 = pWidth3;
  // The dead band width of the servos.
  delayMicroseconds(10);
}
