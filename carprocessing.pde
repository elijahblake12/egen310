// We imported the Game Control Plus library. It HAS to be used for this to run.

// The namespaces that need to be included.
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.serial.*;

// The variables needed to set up the game controller.
ControlIO control;
ControlDevice gpad;

// Hold the vetical values of the only two analog sticks on the game controller.
float yValue, zValue;
/*
 xAxis is for the direction of the arm of our device. yAxis is for the movement
 of the left set of wheels. zAxis is for the movement of the right set of wheels.
*/
short xAxis, yAxis, zAxis;
// The serial port that will be used to send data to the Bluetooth module.
Serial myPort;

/*
  The setup method that will be used once at the beginning of the execution of the
  program.
*/
public void setup() {
  // Set the size of the window that will be used.
  size(400, 400);
  /*
	Initialize the myPort variable with a 9600 Baud rate (which worked for us)
	on COM14 (which is subject to change).
  */
  myPort = new Serial(this, "COM14", 9600); // Begin serial communication
  /*
	The first line of code below means that packets of data from myPort will be read
	until a newline character is found.
  */
  myPort.bufferUntil('\n');
  /*
	Give the variable control starting values from ControlIO, so we can use the
	gamepad.
  */
  control = ControlIO.getInstance(this);
  // See if we can find a device that matches the configuration file "test".
  gpad = control.getMatchedDevice("test");
  // Initialize xAxis at 1500, yAxis at 0, and zAxis at 0.
  xAxis = 1500;
  yAxis = 0;
  zAxis = 0;
  // If no gamepad was found, exit the program.
  if (gpad == null) {
	println("No suitable device configured");
	System.exit(-1); // Close the program.
  }
  // Set the methods that will be executed while a button is held down.
  gpad.getButton("BUTTON2").plug(this, "leftTrigger", ControlIO.WHILE_PRESS);
  gpad.getButton("BUTTON3").plug(this, "rightTrigger", ControlIO.WHILE_PRESS);
}

// The method that will be executed each clock cycle the GUI frame is updated.
public void draw() {
  // Place the vertical analog stick values into these two variables.
  yValue = -gpad.getSlider("Y").getValue();
  zValue = gpad.getSlider("Z").getValue();
 
  /*
	The following eight "if" statements and the code that executes when those "if"
	statements are true describe a piecewise function that makes the controller
	movements feel more natural. We used two square root functions when, on the
	horizontal axis, we are between the value of -.5 (inclusive) and .5 (exclusive).
	At any value outside of this on the horizontal axis, a quadratic function is used.
	(The values on these axes can only be from -1 to 1 (both inclusive).) We used
	this for both yAxis and zAxis, and after calculations are made, we convert the
	value into the appropriate microsecond value.
  */
  //yAxis = (short) round(map(pow(yValue, 9f), -1, 1, 700, 2300));
  //zAxis = (short) round(map(pow(zValue, 9f), -1, 1, 700, 2300));
  if ((yValue >= 0f) && (yValue < .5f)) {
	yAxis = (short) round(map(sqrt(yValue), -1, 1, 1000, 2000));
  }
  if ((yValue < 0f) && (yValue >= -.5f)) {
	yAxis = (short) round(map(-sqrt(abs(yValue)), -1, 1, 1000, 2000));
  }
  if (yValue >= .5f) {
	yAxis = (short) round(map(pow(1.08239220029f * yValue - 0.541196100146f, 2f) + 0.707106781187f, -1, 1, 1000, 2000));
  }
  if (yValue < -.5f) {
	yAxis = (short) round(map(-pow(1.08239220029f * yValue + 0.541196100146f, 2f) - 0.707106781187f, -1, 1, 1000, 2000));
  }
  if ((zValue >= 0f) && (zValue < .5f)) {
	zAxis = (short) round(map(sqrt(zValue), -1, 1, 1000, 2000));
  }
  if ((zValue < 0f) && (zValue >= -.5f)) {
	zAxis = (short) round(map(-sqrt(abs(zValue)), -1, 1, 1000, 2000));
  }
  if (zValue >= .5f) {
	zAxis = (short) round(map(pow(1.08239220029f * zValue - 0.541196100146f, 2f) + 0.707106781187f, -1, 1, 1000, 2000));
  }
  if (zValue < -.5f) {
	zAxis = (short) round(map(-pow(1.08239220029f * zValue + 0.541196100146f, 2f) - 0.707106781187f, -1, 1, 1000, 2000));
  }
  /*
	The following two "if" statements and their contents ensure that the car stays
	still when the controller's two analog sticks aren't being touched. For some
	reason, the controller stays at around 1.0*10^(-4) when they aren't touched.
  */
  if ((yValue >= -0.000515258789f) && (yValue <= 0.000515258789f)) {
	yAxis = 1500;
  }
  if ((zValue >= -0.000515258789f) && (zValue <= 0.000515258789f)) {
	zAxis = 1500;
  }

  /*
	Writes the values of the three axes to the Bluetooth serial port delimited by
	commas.
  */
  myPort.write(str(yAxis) + "," + str(zAxis) + "," + str(xAxis) + "\n");
  /*
	The following three lines of code print values to the screen so we can
	validate the game controller values being sent over.
  */
  textSize(32);
  clear();
  text(str(yAxis) + ", " + str(yValue) + "\n" + str(zAxis) + ", " + str(zValue) + "\n" + str(xAxis), 10, 30);
}

// If the left trigger of the game controller is being held down, ...
public void leftTrigger() {
  /*
 	... increment xAxis by 10 if the value of the variable is less than or equal
 	to 4000. 4010 acts as an upper limit for the values that can be sent over.
  */
  if (xAxis <= 4000) {
	xAxis += 10;
  }
}

// If the right trigger of the game controller is being held down, ...
public void rightTrigger() {
  /*
 	... decrement xAxis by 10 if the value of the variable is greater than
 	150. 150 acts as a lower limit for the values that can be sent over.
  */
  if (xAxis > 150) {
	xAxis -= 10;
  }
}

// When we close the program, ...
void stop() {
  // ... close the gamepad controller connection, ...
  gpad.close();
  // ... clear any values being sent over the one serial port, and ...
  myPort.clear();
  // ... stop the serial port.
  myPort.stop();
}

