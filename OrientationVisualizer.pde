/*
 *  Author: Seung Jae Son
 *  Date: 12/27/2016
 *  Description: Displays the x and y orientations on the graph and
 *    prints their values on the screen.
 */

import processing.serial.*;

private String portName;
private Serial myPort;
private PFont f;
private float xScreen = 0;
private float yScreen = 0;
private static final float X_RATIO = 1280/180;
private static final float Y_RATIO = 720/180;
  
void setup()
{
  size(1280, 720);
  f = createFont("Arial",14,true);
  try
  {
    frameRate(60);
  
  /*
   *  Change the number in portName to check different ports
   */
    portName = Serial.list()[0];
    myPort = new Serial(this, portName, 115200);
  }
  catch (ArrayIndexOutOfBoundsException e) {}
}

void draw()
{
  background(255);
  
  drawAxes();
  if(!hasError())
    drawOrientation();
  writeLocation();
}

private boolean hasError()
{
  if (portName == null)
  {
    textFont(f,18);
    fill(255,0,0);
    text("The orientation sensor is not connected. Please check your port.",20,700);
    return true;
  }
  return false;
}
private float truncate(float x) {
  return round(x * 1000.0f)/1000.0f;
}

private void drawAxes()
{  
  for (int i = -9; i < 9; i++)
  {
    stroke(230);
    line(0,360+10*Y_RATIO*i,1280,360+10*Y_RATIO*i);
    line(640+10*X_RATIO*i,0,640+10*X_RATIO*i,720);
  }
  
  stroke(120);
  line(0,360,1280,360);
  line(640,0,640,720);
}

private void drawOrientation()
{
  String orientationXString;
  String orientationYString;
  float orientationX;
  float orientationY;

  String line = myPort.readStringUntil('\n');
  
  if (line == null)
  {
    stroke(0,0,255);
    line(640+xScreen, 0, 640+xScreen, 720);
    line(0, 360+yScreen, 1280, 360+yScreen);
  }
  else
  {
    int indexSeparate = line.indexOf(' ');
    
    if (indexSeparate > -1) 
    {
      orientationXString = line.substring(0, indexSeparate);
      orientationYString = line.substring(indexSeparate + 1);
      orientationX = float(orientationXString);
      orientationY = float(orientationYString);
      
      xScreen = orientationX * X_RATIO;
      yScreen = orientationY * Y_RATIO;
      
      stroke(0,0,255);
      line(640+xScreen, 0, 640+xScreen, 720);
      line(0, 360+yScreen, 1280, 360+yScreen);
    }
  }
}
private void writeLocation()
{
  textFont(f,14);
  fill(0); 
  float xPrint = xScreen/X_RATIO;
  float yPrint;
  if (yScreen == 0)
    yPrint = 0.0;
  else
    yPrint = -yScreen/Y_RATIO;
  text("X: " + truncate(xPrint),1150,680);
  text("Y: " + truncate(yPrint),1150,700);
}