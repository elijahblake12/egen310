/**
 Basic demonstration of using a gamepad.
 
 When this sketch runs it will try and find
 a game device that matches the configuration
 file 'gamepad' if it can't match this device
 then it will present you with a list of devices
 you might try and use.
 
 The chosen device requires 3 sliders and 2 button.
 */

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.serial.*;

ControlIO control;
Configuration config;
ControlDevice gpad;

boolean pressed;
float yValue, zValue;
short xAxis, yAxis, zAxis;
Serial myPort;
String ledStatus;

public void setup() {
  size(400, 400);
  ledStatus = "";
  myPort = new Serial(this, "COM14", 9600); // Starts the serial communication
  myPort.bufferUntil('\n'); // Defines up to which character the data from the serial port will be read. The character '\n' or 'New Line'
  // Initialise the ControlIO
  control = ControlIO.getInstance(this);
  // Find a device that matches the configuration file
  gpad = control.getMatchedDevice("test");
  pressed = false;
  xAxis = 0;
  yAxis = 0;
  zAxis = 0;
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  gpad.getButton("BUTTON").plug(this, "update", ControlIO.ON_PRESS);
  gpad.getButton("BUTTON2").plug(this, "leftTrigger", ControlIO.ON_PRESS);
  gpad.getButton("BUTTON3").plug(this, "rightTrigger", ControlIO.ON_PRESS);
}

void serialEvent (Serial myPort){ // Checks for available data in the Serial Port
  ledStatus = myPort.readStringUntil('\n'); //Reads the data sent from the Arduino (the String "LED: OFF/ON) and it puts into the "ledStatus" variable//Reads the data sent from the Arduino (the String "LED: OFF/ON) and it puts into the "ledStatus" variable
  println(ledStatus);
}

public void draw() {
  // Either button will dilate pupils
  yValue = -gpad.getSlider("Y").getValue();
  zValue = gpad.getSlider("Z").getValue();
  
  if ((yValue >= 0f) && (yValue < .5f)) {
    yAxis = (short) round(map(sqrt(yValue), -1, 1, 700, 2300));
  }
  if ((yValue < 0f) && (yValue >= -.5f)) {
    yAxis = (short) round(map(-sqrt(abs(yValue)), -1, 1, 700, 2300));
  }
  if (yValue >= .5f) {
    yAxis = (short) round(map(pow(1.08239220029f * yValue - 0.541196100146f, 2f) + 0.707106781187f, -1, 1, 700, 2300));
  }
  if (yValue < -.5f) {
    yAxis = (short) round(map(-pow(1.08239220029f * yValue + 0.541196100146f, 2f) - 0.707106781187f, -1, 1, 700, 2300));
  }
  if ((zValue >= 0f) && (zValue < .5f)) {
    zAxis = (short) round(map(sqrt(zValue), -1, 1, 700, 2300));
  }
  if ((zValue < 0f) && (zValue >= -.5f)) {
    zAxis = (short) round(map(-sqrt(abs(zValue)), -1, 1, 700, 2300));
  }
  if (zValue >= .5f) {
    zAxis = (short) round(map(pow(1.08239220029f * zValue - 0.541196100146f, 2f) + 0.707106781187f, -1, 1, 700, 2300));
  }
  if (zValue < -.5f) {
    zAxis = (short) round(map(-pow(1.08239220029f * zValue + 0.541196100146f, 2f) - 0.707106781187f, -1, 1, 700, 2300));
  }
  if ((yValue >= -0.000515258789f) && (yValue <= 0.000515258789f)) {
    yAxis = 1500;
  }
  if ((zValue >= -0.000515258789f) && (zValue <= 0.000515258789f)) {
    zAxis = 1500;
  }
  //xAxis = (short) round(map(-.5f * cos(gpad.getSlider("X").getValue() * PI) + .5f, -1, 1, 700, 2300)); // 700, 2300

  myPort.write(str(yAxis) + "," + str(zAxis) + "\n");
  
  if (pressed) {
    rect(yAxis - 2.5, zAxis - 2.5, 5, 5);
  }
  
  textSize(32);
  clear();
  text(str(yAxis) + ", " + str(yValue), 10, 30);
}

public void update() {
  pressed = true;
}

public void leftTrigger() {
  pressed = true;
}

public void rightTrigger() {
  pressed = true;
}
