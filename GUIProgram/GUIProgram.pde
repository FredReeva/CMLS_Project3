import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int end = 1000;

float xPos=300;
float yPos=200;
float xPrev=300;
float yPrev=200;

int selCol = 1;
float readX;
float readY;
float intensity;

int starting = 0;
int cycles = 10;

float rCol=255,gCol=0,bCol=0;
int ANIMATION_LENGTH = 150;
float alpha = 0;
float delta = 255/ANIMATION_LENGTH;
float saber = 0;
int speed = 1;

int index = 0;

PVector laserTip = new PVector();
PVector previousTip = new PVector();
PVector holder = new PVector();

Star[] stars = new Star[1000];

public void settings() {
  size(1000,700);
}
 
void setup() {
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",57120);
  
  for (int i=0; i<stars.length; i++) {
    stars[i] = new Star();
  }
}

void draw() {
  
  background(0);
  rectMode(CORNERS);
  fill(255);
  noStroke();
  
  starfield(speed);
  
  laserTip.set(xPos - width/2, yPos - height*0.75);
  previousTip.set(xPrev - width/2, yPrev - height*0.75);
  holder.set(-(xPos - width/2)*0.10, -(yPos - height*0.75)*0.10);
  
  //starting animation
    if(saber == 1){     
      sword(laserTip.mult(index*0.02),previousTip.mult(index*0.02),holder,alpha);
      alpha = alpha + 5*delta;
          if(alpha >= 255){
         alpha = 255;
      }
      if(index<=50){
      index = index + 1;
      }
  }
  if(saber == 0){
    sword(laserTip.mult(index*0.02),previousTip.mult(index*0.02), holder, alpha);
    alpha -= delta;
    if(alpha <= 0){
      alpha = 0;
    }
    if(index>0){
      index = index - 1;
      }
  }
 
}

void oscEvent(OscMessage theOscMessage) {
  
  //OscHook
  if(theOscMessage.checkAddrPattern("/accelerometer/raw/x")==true) {
    xPrev = xPos;
    readX = theOscMessage.get(0).floatValue();
    xPos = map(readX,-10,+10,width,0);
    println("OscHook value: "+readX+" converted: "+xPos);
    }
    
    if(theOscMessage.checkAddrPattern("/accelerometer/raw/y")==true) {
    yPrev = yPos;
    readY = theOscMessage.get(0).floatValue();
    yPos = map(readY,0,+10,height,0);
    println("OscHook Y value: "+readY+" converted: "+yPos);
    }
    
    // touchOSC
    if(theOscMessage.checkAddrPattern("/accxyz")==true) {
    
      xPrev = xPos;
      yPrev = yPos;
      readX = theOscMessage.get(0).floatValue();
      readY = theOscMessage.get(1).floatValue();
      xPos = map(readX, -1, +1, 0, width);
      yPos = map(readY, 0, -1, height, 0);
      println("touchOSC X value: "+readX+" converted: "+xPos);
      println("touchOSC Y value: "+readY+" converted: "+yPos);
      intensity = map(dist(xPos, yPos, xPrev, yPrev), 0, sqrt(sq(height)+sq(width)), -1.0, +1.0);
    }
    
    if(theOscMessage.checkAddrPattern("/red")==true) {
    rCol = 255; 
    gCol = 0;
    bCol = 0;
    selCol = 1;
    }
    if(theOscMessage.checkAddrPattern("/green")==true) {
    rCol = 0; 
    gCol = 255;
    bCol = 0;
    selCol = 2;
    }
    if(theOscMessage.checkAddrPattern("/blue")==true) {
    rCol = 0; 
    gCol = 0;
    bCol = 255;
    selCol = 3;
    }
    if(theOscMessage.checkAddrPattern("/purple")==true) {
    rCol = 255; 
    gCol = 0;
    bCol = 255;
    selCol = 4;
    }
    
    if(theOscMessage.checkAddrPattern("/onoff")==true) {
    saber = theOscMessage.get(0).floatValue();
    }
    
    if(theOscMessage.checkAddrPattern("/speed")==true) {
    speed = (int)theOscMessage.get(0).floatValue();
    }
    
    // send messages to SuperCollider
    OscMessage myMessage = new OscMessage("/value");
    myMessage.add(saber);
    myMessage.add(selCol);
    myMessage.add(readX);
    myMessage.add(intensity);
    myMessage.add(speed);
    oscP5.send(myMessage, myRemoteLocation);
}
