import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.lang.management.ManagementFactory; 
import java.lang.management.OperatingSystemMXBean; 
import java.lang.reflect.Method; 
import java.lang.reflect.Modifier; 
import oscP5.*; 
import netP5.*; 
import themidibus.*; 
import javax.sound.sampled.*; 
import processing.sound.*; 
import ch.bildspur.postfx.builder.*; 
import ch.bildspur.postfx.pass.*; 
import ch.bildspur.postfx.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class liftoff_Reentry_pde extends PApplet {

//CPU monitoring 




Runtime runtime;
OperatingSystemMXBean operatingSystemMXBean;

//Sound Control from MAX & Controller


 //Import the library

OscP5 oscP5;
NetAddress myRemoteLocation;
MidiBus myBus; // The MidiBus
Midi midi;
boolean[][] SG;
int[][] CN;

//Sound Analyze

AudioIn input;
Amplitude loudness;
FFT fft; 
int band = 128;
float smoothFactor = 0.2f;
float[] sum = new float[band];
int scale = 5;
float barWidth;
float volume;
int currentBeat = 0;


//Shader PostFix



PostFX fx;

//Font Upload
PFont font_trench;
String CPUperform="";

//Text Background
String[] codeText;

//Camera Moving Variable
float camShakeX, camShakeY, camShakeZ;
float camShakeXX, camShakeYY, camShakeZZ;

//modeCheck
int newHeight;
int phase = 0;
int transition=0;
boolean transiting = false;
int transition0to1Dark = 0;
int transition1to2Dark = 0;
int transition2to3Dark = 0;
int transition3to0Dark = 0;
int modeFrameCount[];


//initPhase
PImage LTGlogo;
PImage glitchBG;
boolean initVideoTrigger = false;
boolean initVideoPlaying = false;

//Phase0
ArrayList<Blob> blobs;

//Phase2
int phase1Counter = 0;
PImage[] spaceImg;
PImage[] spaceImgBW;
PImage scanBG;
boolean photoSpin = false;
int showImageCounterAfterSpin = 0;
boolean targetingCenter = false;
int photoLength =25;
ArrayList photoToShow;
float phase1offX = random(100);
ArrayList<TargetSystem> targetSystem;
ArrayList<TargetShot> targetShot;
ArrayList<SpaceImages> spaceImages;
ArrayList<ObservateStar> observateStar;
PGraphics observateStarBackground;
int observateStarStartPoint;
int observateStarEndPointEasing;
int observateStarEndPoint;
int observationCount = 0;
int waterCount = 10;
int targetCount = 0;
PGraphics waterRipple;
int waterCols = 200;
int waterRows = 200;
float [][] currentWater;
float [][] previousWater;
float dampening = 0.95f;

//Phase3
ArrayList<Particle> particle;
int[] constellation;

//Phase4
int total = 60;
float geometryR = 400;
float flyI = 0;
float flyJ=  0;
boolean textureOn = false;
boolean explosion = false;
ArrayList<Geometry> geometry;
int newLonMinHalf = 0;    
int newLonMaxHalf = 0; 
int newLatMinHalf = 0;    
int newLatMaxHalf = 0;   
boolean showSide = false;
int flag = 0;


public void setup() {
  
  //fullScreen(P3D);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);

  //Sound input init
  input = new AudioIn(this, 0);
  input.start();
  loudness = new Amplitude(this);
  loudness.input(input);
  barWidth = width/PApplet.parseFloat(band);
  fft = new FFT(this, band);
  fft.input(input);

  //Shader Post Fix init
  fx = new PostFX(this);

  //OSC init
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  oscP5.plug(this, "sig", "/sig");
  oscP5.plug(this, "mode", "/mode");  
  oscP5.plug(this, "control", "/control");  
  oscP5.plug(this, "linear", "/linear");    
  oscP5.plug(this, "bpm", "/bpm");  
  SG = new boolean[10][20];
  for (int y=0; y<20; y++) {
    for (int x=0; x<10; x++) {
      SG[x][y] = false;
    }
  }
  CN = new int[10][20];
  for (int y=0; y<20; y++) {
    for (int x=0; x<10; x++) {
      CN[x][y] = 0;
    }
  }



  //basic Setup
  codeText= loadStrings("codetext.txt");  
  font_trench = createFont("font/trench100free.ttf", 32);   
  textFont(font_trench);
  textSize(16);
  noStroke();
  frameRate(30);
  textAlign(CORNER);
  rectMode(CENTER);

  //FrameCount
  modeFrameCount = new int[8];
  for (int s=0; s<8; s++) {
    modeFrameCount[s] = 0;
  }

  //initPhase
  LTGlogo = loadImage("LTG.png");
  glitchBG = loadImage("Pixels.jpg"); 

  //phase0
  blobs = new ArrayList<Blob>();
  for (int s=0; s<5; s++) {
    blobs.add(new Blob(0, 0, random(200, 230)));
  }


  //Phase2
  spaceImg = new PImage[photoLength];
  spaceImgBW = new PImage[photoLength];
  for (int s=0; s<photoLength; s++) {
    spaceImg[s] = loadImage("space_imgs/"+(s+1)+".jpeg");
    spaceImgBW[s] = loadImage("space_imgsBW/"+(s+1)+".jpeg");
  } 
  scanBG=loadImage("Telescope.jpg");

  targetSystem = new ArrayList<TargetSystem>();
  targetSystem.add(new TargetSystem(400, 150, random(360), 1));
  targetSystem.add(new TargetSystem(400, 150, random(360), -1));
  observateStar=new ArrayList<ObservateStar>();
  for (int s=-800; s<800; s+=1) {
    float x = s;
    float y = 300*cos(radians(s));
    observateStar.add(new ObservateStar(x, y, random(40, 100), random(360)));
  }
  observateStarBackground = createGraphics(1280, 800);
  observateStarStartPoint=0;
  observateStarEndPointEasing = observateStarStartPoint;
  observateStarEndPoint=observateStarStartPoint;
  spaceImages = new ArrayList<SpaceImages>();
  waterRipple = createGraphics(640, 480, P2D);
  setupWater();


  particle = new ArrayList<Particle>();
  for (int x=0; x<=width; x+=60) {
    for (int y=0; y<=height; y+=60) {
      particle.add(new Particle(x, y));
    }
  }  
  constellation = new int[6];  
  camShakeX = 0;
  camShakeY = 0;
  camShakeXX = 0;
  camShakeYY = 0;


  //phase4
  geometry = new ArrayList<Geometry>();
  geometryInit();
  explosion = false;

  runtime = java.lang.Runtime.getRuntime();  
  phase = 3;
}
public void draw() {
  soundCheck();
  //background(0);
  switch(phase) {
  case 0:
    initPhase();
    break;
  case 1:
    mode1();
    break;
  case 2:
    mode2();
    break;
  case 3:
    mode3();
    break;
  case 4:
    mode4();
    break;
  case 5:
    //mode5();
    break;
  }
  //mode1();

  //Showing FPS performance && Garbage Collecting
  if (frameCount % 3600 ==0)runtime.gc();
  surface.setTitle(str(frameRate));

  //signal Reset
  //  for (int y=0; y<20; y++) {
  //    for (int x=0; x<10; x++) {
  //      SG[x][y] = false;
  //    }
  //  }
}
public void blackHole() {
  pushMatrix();
  translate(width/2, height/2);

  pushMatrix();
  blendMode(ADD);
  for (int s=0; s<50; s++) {
    rotateX(radians(s+PApplet.parseFloat(frameCount)/21.3f));
    rotateY(radians(s+PApplet.parseFloat(frameCount)/16.8f));
    fill(255, abs(-s*4), 0, 20); 
    ellipse(0, 0, 100+s*4.5f, 100+s*4.5f);
  }
  popMatrix();


  blendMode(BLEND);
  noStroke();
  for (int s=0; s<40; s++) {
    fill(0, 40);
    ellipse(0, 0, s*4, s*4);
  }

  blendMode(ADD);
  popMatrix();
}
public void midiContollerInit() {
  MidiBus.list();
  myBus = new MidiBus(this, "Launch Control XL", "Launch Control XL");
  midi = new Midi();
}
class Midi {
  int[] layerTint = new int[8];
  int[][] control = new int[8][3];
  boolean[] layerToggle = new boolean[8];
  Midi() {
    for (int channel=12; channel<=14; channel++) {
      for (int number=11; number<=18; number++) {
        int value = 0;
        myBus.sendControllerChange(channel, number, value); // Send a controllerChange
      }
    }
    for (int s=0; s<8; s++) {
      layerTint[s] = 0;
      layerToggle[s] = false;
      for (int i=0; i<3; i++) {
        control[s][i] = 0;
      }
    }
  }
  public void update() {
  }
}
public void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange

  if (channel <= 7) {
    midi.control[channel][number-1] = value;
  }


  if (channel == 9) {
    midi.layerTint[number-1] = value*2;
    if (midi.layerTint[number-1] > 40)midi.layerToggle[number-1]=true;
    else midi.layerToggle[number-1]=false;
  }

  if (channel==13 && number ==11) {
    //soundReset = true;
  }

  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}
public void initPhase() {
  background(0);
  imageMode(CENTER);
  colorMode(RGB, 255);
  blendMode(BLEND);
  pushMatrix();
  float shakeGlitch = map(transition0to1Dark, 0, 255, 5, 150);
  LTGlogo = loadImage("LTG.png");
  LTGlogo.loadPixels();
  int randomColor = color(random(255), random(255), random(255), 255);
  if (random(100)<(25+shakeGlitch/2)) {
    for (int y=0; y<LTGlogo.height; y++) {
      for (int x=0; x<LTGlogo.width; x++) {
        // get the color for the pixel at coordinates x/y
        int pixelColor = LTGlogo.pixels[y + x * LTGlogo.height];
        if (pixelColor == color(255)) {
          // percentage to mix
          float mixPercentage = .5f + random(50)/50;
          // mix colors by random percentage of new random color
          LTGlogo.pixels[y + x * LTGlogo.height] =  lerpColor(pixelColor, randomColor, mixPercentage);
        }
        if (random(100)<25) {
          randomColor = color(random(255), random(255), random(255), 255);
        }
      }
    }
  }
  LTGlogo.updatePixels();
  for (int s=0; s<100; s++) {
    int x1 = 0;
    int y1 = floor(random(LTGlogo.height));

    int x2 = round(x1 + random(-shakeGlitch, shakeGlitch));
    int y2 = round(y1 + random(-shakeGlitch/3, shakeGlitch/3));

    int w = LTGlogo.width;
    int h = floor(random(10));
    LTGlogo.set(x2, y2, LTGlogo.get(x1, y1, w, h));
  }
  translate(width/2, height/2);
  for (int s=0; s<blobs.size(); s++) {
    blobs.get(s).update();
    blobs.get(s).showMode1();
    blobs.get(s).cons();
  }
  image(LTGlogo, -10, 0, width*0.4f, height*0.4f);
  popMatrix();
  blendMode(BLEND);
}
class Blob {
  PVector pos;
  PVector vel = new PVector(0, 0);
  float radius;
  float yoff = random(100);
  boolean killMode1 = false;
  int killMode1Num = 255;

  // float xoff = random(100);
  Blob(float ex, float ey, float er) {
    pos = new PVector(ex, ey);
    radius = er;
  }
  public void update() {
    PVector newVel = new PVector(0, 0);
    newVel.div(50);
    newVel.limit(3);
    vel.lerp(newVel, 0.2f);
    pos.add(vel);
  }

  public void cons() {
    pos.x = constrain(pos.x, -width/4, width/4);
    pos.y = constrain(pos.y, -height/4, height/4);
  }
  public void showMode1() {
    if (killMode1==true) {
      killMode1Num-=10;
      if (killMode1Num<0)killMode1Num=0;
    }
    //fill(255);
    noFill();
    stroke(killMode1Num);
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1f) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1f;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01f;
  }
  public void show() {

    //fill(255);
    noFill();
    stroke(255, 100);
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1f) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1f;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01f;
  }
  public void showWithFill() {
    //fill(255);
    noFill();
    stroke(255, 150);
    strokeWeight(2);
    fill(0, 100);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1f) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1f;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01f;
  }
}
float targetXX, targetYY;
float targetXXX, targetYYY;

public void mode1() {
  pushMatrix();
  if (currentBeat>=48) {
  } else {
    background(0);
  }
  targetXX += (targetXXX-targetXX)*0.2f;
  targetYY += (targetYYY-targetYY)*0.2f;
//  for (int x=0; x<width; x++) {
//    for (int y=0; y<height; y++) {
//      float col = map(dist(targetXX, targetYY, x, y), 0, width/2, 255, 0);

//      noStroke();
//      if (col < 100) {
//        set(x, y, color(0, col));
//      }
//      // fill(0,col);
//      // ellipse(x,y,1,1);

//      //   // set(x, y, color(red(cc), green(cc), blue(cc)));
//    }
//  }

  for (int x=0; x<=width; x+=30) {
    for (int y=0; y<=height; y+=30) {
      float col = map(dist(targetXX, targetYY, x, y), 0, width/3, 200, 0);
      if (x%150==0&&y%150==0) {
        for (int i=-5; i<=5; i++) {          
          set(x, y+i, color(col+50));
          set(x+i, y, color(col));
        }
      } else {
        set(x, y, color(col));
      }
    }
  }

  textAlign(CORNER);
  textSize(20);
  stroke(46, 210, 255);
  stroke(255);
  //if (frameCount%5==0)strokeWeight(2);
  //else strokeWeight(1);
  text(targetXX, targetXX+255*sin(radians(frameCount)), targetYY );
  text(targetYY, targetXX, targetYY+255*sin(radians(frameCount)));
  line(targetXX, 0, targetXX, height);
  line(0, targetYY, width, targetYY);
  //  ellipse(xx, yy, 100, 100);
  //if (frameCount%2==0 && (frameCount/100)%2==0)


  fill(255);
  textAlign(CENTER);
  
  if ( (frameCount/100)%2==0) {
    for (int x=0; x<width; x+=50) {
      text(x, x, 20);
    }
  }


  textAlign(CORNER);
  if ((frameCount/100)%2==1) {
    for (int y=0; y<height; y+=50) {
      text(y, 20, y);
    }
  }

  //camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);

  if (currentBeat%8==0) {
    targetXXX = random(100, width-100);
    targetYYY = random(100, height-100);
  }
  if (SG[1][0] == true) {



    SG[1][0] = false;
  }
  if (SG[1][1] == true) {

    if (currentBeat>=48) {
    } else {
      noStroke();
      fill(255, 200);
      rectMode(CORNER);
      float whiteWid = width/15;
      float ran =floor(random(whiteWid));
      rect(ran*15, 0, whiteWid, height);
      SG[1][0] = false;
      rectMode(CENTER);
    }
  }
  if (SG[1][2] == true) {
    SG[1][2] = false;
  }
  if (SG[1][3] == true) {    
    line(0, height/2 + height/2*sin(radians(PApplet.parseFloat(frameCount)/1.7f)), targetXX, targetYY);
    line(width/2 + width/2*sin(radians(frameCount)), 0, targetXX, targetYY);

    SG[1][3] = false;
  }
  if (SG[1][4] == true) {
    SG[1][4] = false;
  }
  if (SG[1][5] == true) {

    for (int s=0; s<30; s++) {
      int x1 = floor(random(width));
      ;
      int y1 = floor(random(height));

      int x2 = x1 + floor(random(-80, 80));
      int y2 = y1 + floor(random(0));

      int w = width;
      int h = round(random(10, 20));
      if (random(10)>5) {
        int tempX = x1;//floor(map(x1, 0, width, 0, width));
        int tempY = y1;//floor(map(y1, 0, height, 0, height));
        set(x2, y2, get(tempX, tempY, w, h));
      } else
        set(x2, y2, get(x1, y1, w/2, h));
    }

    SG[1][5] = false;
  }
  popMatrix();
}
public void mode2() { 
  pushMatrix();
  background(0);
  //previousWater[(int)random(200)][(int)random(200)] = 255;
  translate(width/2, height/2);
  drawWaterRipple();
  blendMode(BLEND);

  //CornerCall
  if (SG[2][9] ==true) {
    targetingCenter=true;
  }

  //waterTrigger
  if (SG[2][5]==true) {
    float targetX=map(targetSystem.get(0).x, -width/2-5, width/2+5, 0, 640);
    float targetY=map(targetSystem.get(1).y, -height/2-5, height/2+5, 0, 480);
    previousWater[(int)targetX][(int)targetY] = waterCount;
    waterCount += 3;
    if (waterCount>255)waterCount=255;
    SG[2][5]=false;
    targetCount++;
  }

  imageMode(CENTER);
  image(waterRipple, 0, 0, width+10, height+10);
  //spaceImageGraphic.clear();
  for (int s=0; s<targetSystem.size(); s++) {
    targetSystem.get(s).update();
    targetSystem.get(s).showBall();
  }

  rectMode(CENTER);
  stroke(255, 100);
  strokeWeight(0.5f);
  noFill();
  for (int s=0; s<spaceImages.size(); s++) {
    spaceImages.get(s).update();
    spaceImages.get(s).showImage();

    if (spaceImages.get(s).imageSizeY<12) {
      spaceImages.remove(s);
    }
  }
  //spinMoveFaster
  if (SG[2][10]) {
    SG[2][10] = false;
  }

  if (SG[2][3]==true) {
    int dir = 0;
    if (random(2)>1) {
      dir = 1;
    } else {
      dir = 0;
    }
    /*    
     // 0 blank 1 BWImg 2 colImg 3 spin 
     boolean photoTrigger = false;
     boolean photoTriggerImageBW = false;
     boolean photoTriggerImage = false;
     boolean photoKill = false;
     boolean photoSpin = false;
     */

    //PhotoTrigger
    if (SG[2][9]==true) {
      if (CN[2][0]==0) {
        spaceImages.add(new SpaceImages(500+random(-20, 20), 
          targetSystem.get(0).y, 
          dir, targetSystem.get(0).x, 0));
      } else if (CN[2][0]==1) {
        spaceImages.add(new SpaceImages(500+random(-20, 20), 
          targetSystem.get(0).y, 
          dir, targetSystem.get(0).x, 1));
      } else if (CN[2][0]==2) {
        spaceImages.add(new SpaceImages(500+random(-20, 20), 
          targetSystem.get(0).y, 
          dir, targetSystem.get(0).x, 2));
      }
      showImageCounterAfterSpin ++;
    } else { 
      if (CN[2][0]==0) {
        spaceImages.add(new SpaceImages(500+random(-20, 20), 
          random(-height/2+100, height/2-100), 
          dir, targetSystem.get(0).x, 0));
      } else if (CN[2][0]==1) {
        spaceImages.add(new SpaceImages(500+random(-20, 20), 
          random(-height/2+100, height/2-100), 
          dir, targetSystem.get(0).x, 1));
      } else if (CN[2][0]==2) {
        spaceImages.add(new SpaceImages(500+random(-20, 20), 
          random(-height/2+100, height/2-100), 
          dir, targetSystem.get(0).x, 2));
      }
    }
    SG[2][3] = false;
  } 

  //PhotoKill
  if (SG[2][4]==true) {
    for (int s=0; s<spaceImages.size(); s++) {
      spaceImages.get(s).kill();
    }
    SG[2][4] = false;
  }
  ShowobservationStar();
  // blendMode(ADD);
  imageMode(CENTER);
  image(observateStarBackground, 0, 0, width, height);
  //  if (random(5)>4)
  //   filter(INVERT);

  popMatrix();
  noStroke();
}
public void mode3() {
  background(0);
  camera(width/2.0f + camShakeX, 
    height/2.0f + camShakeY, 
    (height/2.0f) / tan(PI*30.0f / 180.0f)+camShakeZ, 
    width/2.0f, height/2.0f, 0, 
    0, 1, 0);


 
  if (SG[3][0]==true//&& 
    //abs(camShakeXX-camShakeX)<10 &&
    //abs(camShakeYY-camShakeY)<10 &&
    //abs(camShakeZZ-camShakeZ)<10
    ) 
  {
    camShakeXX = random(-200, 200);
    camShakeYY = random(-200, 200);
    camShakeZZ = random(-500, 500);
    //camShakeZZ = random(-(height/2.0) / tan(PI*30.0 / 180.0)
    //, (height/2.0) / tan(PI*30.0 / 180.0));
    // camShakeZZ -= 500;

    SG[3][0] = false;
  }
  camShakeX += (camShakeXX-camShakeX)*0.25f;
  camShakeY += (camShakeYY-camShakeY)*0.25f;
  camShakeZ += (camShakeZZ-camShakeZ)*0.25f;


  if (SG[3][1]==true) {
    for (int s=0; s<6; s++) {
      constellation[s] = floor(random(particle.size()));
    }
    SG[3][1]=false;
  }

  for (int s=0; s<particle.size(); s++) {
    Particle P = particle.get(s);
    P.update();
    if (random(10)>8) {
      strokeWeight(random(1));
    } else {      
      strokeWeight(1);
    }
    P.show();
  }
  for (int s=0; s<5-1; s++) {
    Particle P = particle.get(constellation[s]);
    Particle PP = particle.get(constellation[s+1]);
    stroke(255);
    strokeWeight(1);
    line(P.pos.x, P.pos.y, P.pos.z, 
      PP.pos.x, PP.pos.y, PP.pos.z
      );
    //vertex(P.pos.x, P.pos.y, P.pos.z);
  }

  stroke(135, 0);
  beginShape(TRIANGLE_STRIP);
  for (int s=0; s<particle.size(); s++) {
    Particle P = particle.get(s);
    vertex(P.pos.x, P.pos.y, P.pos.z);
  }
  endShape();


  if (SG[3][2]==true) {
    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      P.returnToGrid();
      //P.randomlize();
      //P.randomSphere();
    }
    SG[3][2]=false;
  }

  if (SG[3][3]==true) {
    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      //P.returnToGrid();
      P.randomlize();
      //P.randomSphere();
    }
    SG[3][3]=false;
  }
  if (SG[3][4]==true) {
    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      //P.returnToGrid();
      //P.randomlize();
      P.randomSphere();
    }
    SG[3][4]=false;
  }



  if (volume>0.35f)
    fx.render()
      .sobel()
      //.bloom(0.1, 20, 30)
      //.blur(10, 0.5)
      //.toon()
      .brightPass(0.1f)
      .blur(20, 30)
      .compose();

  else
    fx.render()
      //.sobel()
      //.bloom(0.2, 20, 30)
      //.toon()
      //.brightPass(1)
      .blur(20, 30)
      //.blur(1, 0.001)
      .compose();
}
public void mode4() {
  background(0);
  camera(300, 400, 1000, 0, 0, 0, 0, 1, 0);
  if (SG[4][0]) {

    flag = floor(random(3));
    newLonMinHalf = (int)random(total);  
    int tempLonMax= floor(random(3, 35));
    //if (random(2)<1) {
    //  tempMax = int(phase2Counter*0.01);
    //} else tempMax = -int(phase2Counter*0.01);
    newLonMaxHalf = newLonMinHalf + tempLonMax;    
    if (newLonMaxHalf > total)newLonMaxHalf=total-1;
    if (newLonMaxHalf < 0)newLonMaxHalf=0;

    //if (phase2Counter*0.001 < 3) {
    //  shabaMode2 = int(random(phase2Counter*0.001));
    //} else {
    //  shabaMode2 = int(random(3));
    //}

    if (newLonMinHalf > newLonMaxHalf) {
      int temp = newLonMinHalf;
      newLonMinHalf = newLonMaxHalf;
      newLonMaxHalf = temp;
    }

    newLatMinHalf = (int)random(total);    
    //newLatMaxHalf = (int)random(total);
    int tempLatMax= floor(random(3, 35));
    newLatMaxHalf = newLatMinHalf + tempLatMax;    
    if (newLatMaxHalf > total)newLatMaxHalf=total-1;
    if (newLatMaxHalf < 0)newLatMaxHalf=0;

    if (newLatMinHalf > newLatMaxHalf) {
      int temp = newLatMinHalf;
      newLatMinHalf = newLatMaxHalf;
      newLatMaxHalf = temp;
    }
    //showHalfTrigger=false;
  }

  for (int i=newLatMinHalf; i<newLatMaxHalf; i++) {
    for (int j=newLonMinHalf; j<newLonMaxHalf; j++) {
      //for (int i=0; i<total; i++) {
      //  for (int j=0; j<total; j++) {
      Geometry G = geometry.get(i*(total+1) + j);
      Geometry Gup = geometry.get((i+1)*(total+1) + j);
      Geometry Gright = geometry.get((i)*(total+1) + j+1);
      Geometry Gnext = geometry.get((i+1)*(total+1) + j+1);
      //        println(i, j, G.ii, G.jj);
      //if (i!=G.ii || j!=G.jj)println(i, j);
      //if((i+1)!=Gnext.ii || (j+1)!=Gnext.jj)println(i,j);
      G.update();
      G.show(
        Gup.globeTexture, 
        Gright.globeTexture, 
        Gnext.globeTexture, 
        flag//shaba mode
        );
    }
  }
  SG[4][0] = false;

  blackHole();
  if (volume<0.5f)
    fx.render()
      .sobel()
      //.bloom(0.1, 20, 30)
      //.blur(10, 0.5)
      //.toon()
      .brightPass(0.1f)
      .blur(20, 30)
      .compose();

  else
    fx.render()
      //.sobel()
      //.bloom(0.2, 20, 30)
      //.toon()
      //.brightPass(1)
      .blur(20, 30)
      //.blur(1, 0.001)
      .compose();
}
public void mode5() {
}

public void bpm(int theA) {
  currentBeat = theA;
}
public void mode(int theA) {
  int f = floor(random(2));
  if(f==0)phase=1;
  if(f==1)phase=2;
  
}
public void sig(int theA, int theB) {
  SG[theA][theB] = true;

  if (theA==2) {
    switch(theB) {
    case 0:
      SG[2][1] = false;
      break;
    case 1:
      SG[2][0] = false;
      break;
    }
  }
  /*
  Phase2
   [2][0] targetSystemLineA 
   [2][1] targetSystemLineB
   [2][2] targetSystemShow
   [2][3] photoTrigger //ShowImageGrid
   [2][4] photoKill
   [2][5] waterTrigger
   [2][6] ChangeObservationStar
   [2][7] photoTriggerImage
   [2][8] photoSpin
   [2][9] phase1CornerCall
   [2][10] spinMoveFaster
   
   Phase4
   [4][0] addStarTrigger
   [4][1] showHalf //together
   [4][2] showHalfTrigger //together
   [4][3] showAllgeo
   [4][4] changeTexture
   [4][5] textureOn
   [4][6] crashSide
   [4][7] startMove
   */
}
public void con(int theA, int theB, int theC) {
  CN[theA][theB] = theC;
  if (theA==2 && theB==1) {
    glitchReset();
  }
  /*
  Phase2
   [2][0] 0 photoTriggerImageRect
   [2][0] 1 photoTriggerImageBW
   [2][0] 2 photoTriggerImage
   
   [2][1] 0 glitchTrigger
   [2][1] 1 glitchReset
   
   */
}
public boolean returnOSC(int input) {
  if (input==0)return false;
  else return true;
}

public void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  //println();
  //println("Note Off:");
  //println("--------");
  //println("Channel:"+channel);
  //println("Pitch:"+pitch);
  //println("Velocity:"+velocity);

  /*
   OscMessage myMessage = new OscMessage("/test");
   myMessage.add(phase);
   if (channel==0) {
   if (pitch>=96 && pitch<=103) {
   if (midiBusing[pitch-96]==true)midiBusing[pitch-96]=false;
   else midiBusing[pitch-96]=true;
   myMessage.add(pitch-96);
   if (midiBusing[pitch-96]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   oscP5.send(myMessage, myRemoteLocation);
   } else if (pitch>=112 && pitch<=119) {
   if (midiBusing[pitch-104]==true)midiBusing[pitch-104]=false;
   else midiBusing[pitch-104]=true;
   myMessage.add(pitch-104);
   if (midiBusing[pitch-104]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   oscP5.send(myMessage, myRemoteLocation);
   } else if (pitch==104) {
   if (midiBusing[16]==true)midiBusing[16]=false;
   else midiBusing[16]=true;
   myMessage.add(16);
   if (midiBusing[16]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   oscP5.send(myMessage, myRemoteLocation);
   } else if (pitch==120) {
   if (midiBusing[17]==true)midiBusing[17]=false;
   else midiBusing[17]=true;
   myMessage.add(17);
   if (midiBusing[17]==false) {
   myMessage.add(0);
   } else {
   myMessage.add(1);
   }
   }
   oscP5.send(myMessage, myRemoteLocation);
   }*/
}
public void soundCheck() {
  fft.analyze();
  input.amp(1);
  volume = loudness.analyze();
  volume*=1000;
  //println(volume);
  volume = norm(volume, 0, 100);
}

public void setupWater() {
  waterCols = waterRipple.width;
  waterRows = waterRipple.height;
  currentWater = new float[waterCols][waterRows];
  previousWater = new float[waterCols][waterRows];
}
public void drawWaterRipple() {
  colorMode(RGB, 255);
  waterRipple.beginDraw();
  waterRipple.loadPixels();
  for (int i = 1; i < waterCols-1; i++) {
    for (int j = 1; j < waterRows-1; j++) {
      currentWater[i][j] = (
        previousWater[i-1][j]+
        previousWater[i+1][j]+
        previousWater[i][j-1]+
        previousWater[i][j+1])/2 - 
        currentWater[i][j];
      currentWater[i][j] = currentWater[i][j] *dampening;
      int index = i+j*waterCols;
      waterRipple.pixels[index] = color(currentWater[i][j]*255);
    }
  }
  waterRipple.updatePixels();
  float [][] temp = previousWater;
  previousWater = currentWater;
  currentWater = temp;
  waterRipple.endDraw();
}
public void ShowobservationStar() {
  if (SG[2][6]==true) {
    if (observationCount>1550)observationCount = 1550;
    //observationCount +=2;
    observationCount = 1550;
    observateStarStartPoint = (int)random(observateStar.size()-observationCount);
    observateStarEndPointEasing =observateStarStartPoint;
    observateStarEndPoint = observateStarStartPoint+observationCount;
    SG[2][6]=false;
  }
  observateStarBackground.beginDraw();
  //observateStarBackground.clear();
  observateStarBackground.background(0, 0);
  observateStarBackground.translate(observateStarBackground.width/2, observateStarBackground.height/2);
  observateStarBackground.rotate(radians(15));
  observateStarEndPointEasing += (observateStarEndPoint-observateStarEndPointEasing)*0.2f;

  for (int s=observateStarStartPoint; s<observateStarEndPointEasing; s++) {
    ObservateStar Rt = observateStar.get(s);
    Rt.updateRoot(observateStarBackground);
    Rt.drawRoot(observateStarBackground);
  }
  observateStarBackground.endDraw();
}

class TargetSystem {
  float x, y;
  float xx, yy;
  float px, py;
  float rX, rY;
  float fx, fy;
  float angle;
  float ori_v;
  float v;
  int dir;
  int targetMode;
  float easing = 0.1f;
  int colorFade = 255;
  TargetSystem(float erX, float erY, float ea, int edir) {
    rX = erX;
    rY = erY;
    angle = ea;
    dir = edir;
    v = random(0.7f, 2);
    ori_v = v;
    //targetMode = etargetMode;
  }
  public void resetVel() {
    v = 0;
  }
  public void update() {
    x = rX * cos(radians(angle));
    y = rY * sin(radians(angle));
    angle += abs(v*dir);
    v+=(ori_v-v)*easing;
    if (targetingCenter == true) {
      rX--;
      rY--;
      if (rX<=0)rX=0;
      if (rY<=0)rY=0;
    }
  }
  public void showBall() {
    if (SG[2][2] == true) {
      colorFade -=2;
      if (colorFade<2) colorFade = 0; 
      if (dir>0) {
        for (int s=-50; s<=50; s+=4) {
          stroke(255, colorFade, colorFade, 150*sin(radians(map(s, -20, 20, 0, 180))) * map(transition1to2Dark, 0, 255, 1, 0));
          line(x-s, -height, x-s, height);
        }
      } else {
        for (int s=-50; s<=50; s+=4) {
          stroke(255, colorFade, colorFade, 150*sin(radians(map(s, -20, 20, 0, 180))) * map(transition1to2Dark, 0, 255, 1, 0));
          line(-width, y-s, width, y-s);
        }
      }
      pushMatrix();
      fill(255);
      translate(x, y);
      textSize(12);
      text(nfc(x, 3), 10, -15);
      text(nfc(y, 3), 10, 0);
      text(nfc(angle, 3), 10, 15);

      noStroke();
      fill(255);
      ellipse(0, 0, 5, 5);
      popMatrix();
    } else  if (SG[2][0]==true) {
      if (dir==1) {
        colorMode(HSB);
        int xx = PApplet.parseInt(x);
        if (x - px> 0 ) {
          int pxlength = (int)abs(map(x-px, 0, 4, 0, 100));
          if (x - px>=4)pxlength=100;
          for (int i=-pxlength; i<0; i+=3) {
            float tempTrans;
            if (i<0) {
              tempTrans = map(i, -pxlength, 0, 0, 1);
            } else {
              tempTrans = map(i, 0, pxlength, 1, 0);
            }
            for (int j=0; j<height; j++) {
              int ctemp = (int)scanBG.get((int)map(i+x+width/2, 0, width, 0, scanBG.width), (int)map(j, 0, height, 0, scanBG.height));
              int c = color(hue(ctemp), (int)saturation(ctemp)*tempTrans, (int)brightness(ctemp)*tempTrans);
              set(i+xx+width/2, j, c);
            }
          }
        } else {
          int pxlength = (int)abs(map(x-px, -0, -4, 0, 100));
          if (x-px<=-4)pxlength = 100;
          for (int i=0; i<pxlength; i+=3) {
            float tempTrans;
            if (i<0) {
              tempTrans = map(i, -pxlength, 0, 0, 1);
            } else {
              tempTrans = map(i, 0, pxlength, 1, 0);
            }
            for (int j=0; j<height; j++) {
              int ctemp = (int)scanBG.get((int)map(i+x+width/2, 0, width, 0, scanBG.width), (int)map(j, 0, height, 0, scanBG.height));
              int c = color(hue(ctemp), (int)saturation(ctemp)*tempTrans, (int)brightness(ctemp)*tempTrans);
              set(i+xx+width/2, j, c);
            }
          }
        }
        colorMode(RGB);
        stroke(255*abs(cos(radians(angle))), 0, 0);
        line(x, -height/2, x, height/2);
        px = xx;
      }
    } else if (SG[2][1]==true) {
      if (dir==-1) {
        colorMode(HSB);
        int yy = PApplet.parseInt(y);
        if (y - py> 0 ) {
          int pylength = (int)abs(map(y-py, 0, 4, 0, 100));
          if (y - py>=4)pylength=100;
          for (int i=-pylength; i<0; i+=3) {
            float tempTrans;
            if (i<0) {
              tempTrans = map(i, -pylength, 0, 0, 1);
            } else {
              tempTrans = map(i, 0, pylength, 1, 0);
            }
            for (int j=0; j<width; j++) {
              int ctemp = (int)scanBG.get((int)map(j, 0, width, 0, scanBG.width), (int)map(i+y+height/2, 0, height, 0, scanBG.height));
              int c = color(hue(ctemp), (int)saturation(ctemp)*tempTrans, (int)brightness(ctemp)*tempTrans);
              set(j, i+yy+height/2, c);
            }
          }
        } else {
          int pylength = (int)abs(map(y-py, -0, -4, 0, 100));
          if (y-py<=-4)pylength = 100;
          for (int i=0; i<pylength; i+=3) {
            float tempTrans;
            if (i<0) {
              tempTrans = map(i, -pylength, 0, 0, 1);
            } else {
              tempTrans = map(i, 0, pylength, 1, 0);
            }
            for (int j=0; j<width; j++) {
              int ctemp = (int)scanBG.get((int)map(j, 0, width, 0, scanBG.width), (int)map(i+y+height/2, 0, height, 0, scanBG.height));
              int c = color(hue(ctemp), (int)saturation(ctemp)*tempTrans, (int)brightness(ctemp)*tempTrans);
              set(j, i+yy+height/2, c);
            }
          }
        }
        colorMode(RGB);
        stroke(255*abs(cos(radians(angle))), 0, 0);
        line(-width/2, y, width/2, y);
        py = yy;
      }
    }
  }
}

class TargetShot {
  float x, y;
  float r;
  float a;
  float v;
  float life = 255;
  TargetShot(float ex, float ey) {
    x = ex;
    y = ey;
    v = 1;
    a = 0.1f;
  }
  public void update() {
    r+=v;
    v+=a;
    life *=0.95f;
  }
  public void show() {
    fill(255);
    noFill();
    stroke(life);
    ellipse(x, y, r, r);
  }
}

public void glitchReset() {
  for (int s=0; s<photoLength; s++) {
    spaceImg[s] = loadImage("space_imgs/"+(s+1)+".jpeg");
    spaceImgBW[s] = loadImage("space_imgsBW/"+(s+1)+".jpeg");
  }
}
class SpaceImages {
  float photoX, photoY, photoZ;
  float r = 300;
  float angle = 90;
  float imageSizeX = random(50, 150);
  float imageSizeY = imageSizeX/4*3;
  float ori_imageSizeY = imageSizeY;
  float ori_imageSizeX = imageSizeX;
  int imageFlag = PApplet.parseInt(random(photoLength));
  boolean dead = false;
  float textX;
  float textY;
  float photoXOri;
  float photoYOri;
  int dir;
  float spin = 0;
  float spinAdjust;
  float spinRadians;
  float textEasing = 0.3f; 
  int imageMode = 0;
  float spinAdjustOri;
  SpaceImages(float ex, float ey, int edir, float targetX, int eimageMode) {
    photoX = ex;
    photoY = ey;
    photoZ = 0;
    dir = edir;
    imageMode = eimageMode;
    if (dir==0)photoX = -photoX;
    spinRadians = photoX;

    textX = targetX+random(-15, 15);
    textY = photoY;

    photoXOri = 0;
    photoYOri = 0;

    // 0 blank 1 BWImg 2 colImg 3 spin
    if (SG[2][8] == true) {
      spin = 90 + random(2*showImageCounterAfterSpin);
      spinAdjust = random(0.1f, 0.5f);
      spinAdjustOri = spinAdjust;
    } else {
      spin = 90;
      spinAdjust = 0;
      spinAdjustOri = spinAdjust;
    }
  }
  public void update() {
    imageSizeY = ori_imageSizeY*sin(radians(angle));
    if (dead) { 
      imageSizeX = ori_imageSizeX + tan(radians(angle+45));
      angle +=5;
    }
    photoX = spinRadians*sin(radians(spin));
    photoZ = spinRadians*cos(radians(spin));
    if (SG[2][10]==true) {
      spinAdjust *= 6;
    } else {
      spinAdjust += (spinAdjustOri-spinAdjust)*0.3f;
      spin += spinAdjust;
    }
    photoXOri += (photoX - photoXOri)*textEasing;
    photoYOri += (photoY - photoYOri)*textEasing;
  }
  public void kill() {
    dead = true;
  }
  public void showImage() {
    noFill();
    pushMatrix();
    translate(photoX, photoY, photoZ);
    if (CN[2][1]==1) {
      if (imageMode == 1) {
        image(imageGlitch(spaceImgBW[imageFlag]), 0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        image(imageGlitch(spaceImg[imageFlag]), 0, 0, imageSizeX, imageSizeY);
      }
    } else if (SG[2][9]==true || SG[2][8]==true) {
      if (imageMode == 1) {
        image(spaceImgBW[imageFlag], 0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        image(spaceImg[imageFlag], 0, 0, imageSizeX, imageSizeY);
      }
    } else {
      if (imageMode == 0) {
        //rect(0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 1) {
        image(spaceImgBW[imageFlag], 0, 0, imageSizeX, imageSizeY);
        rect(0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        image(spaceImg[imageFlag], 0, 0, imageSizeX, imageSizeY);
        rect(0, 0, imageSizeX, imageSizeY);
      }
    }
    popMatrix();
    textSize(12);
    fill(255);
    if (SG[2][9]==true) {
      text(nfc(photoXOri, 3), -10, -imageSizeY/2);
      text(nfc(photoYOri, 3), 10, -imageSizeY/2);
    } else {
      text(nfc(photoXOri, 3), textX, textY-10);
      text(nfc(photoYOri, 3), textX, textY+10);
    }
    if (dir==1)
      line(photoX-imageSizeX/2, photoY, photoZ, textX, textY, 0);
    else
      line(photoX+imageSizeX/2, photoY, photoZ, textX, textY, 0);
  }
}

class ObservateStar {
  float px, py, R, angle;
  float ppx, ppy;
  float ori_px, ori_py;
  ObservateStar(float epx, float epy, float eR, float eangle) {
    px = epx;
    py = epy;
    ori_px = px;
    ori_py = py;
    ppx = epx;
    ppy = epy;
    R= eR;
    angle = eangle;

    px = ori_px + R*cos(radians(angle));
    py = ori_py + R*sin(radians(angle));
    ppx = px;
    ppy = py;
  }
  public void updateRoot(PGraphics P) {
    px = ori_px + R*cos(radians(angle));
    py = ori_py + R*sin(radians(angle));
    angle+=random(0.75f);
    //R = R * 0.995;
  }
  public void drawRoot(PGraphics P) {
    if (random(50)>30) {
      P.fill(255, 40);
      P.stroke(0);
      P.strokeWeight(1);
      int elpsize = (int)map(R, 40, 100, 0, 5);
      P.ellipse(px, py, elpsize, elpsize);
    }
    //P.strokeWeight(1.3);  
    if (random(100)>95)
      P.stroke(map(px, 0, P.width, 100, 180), 255, map(py, -500, +500, 50, 255), 200);
    P.stroke(map(px, 0, P.width, 100, 180), 81, map(py, -500, +500, 50, 255), 200);
    P.line(px, py, ppx, ppy);
    ppx = px;
    ppy = py;
  }
}

class Particle {
  PVector pos;
  PVector ppos;
  PVector va, vt;
  PVector a, t;
  float cor_x, cor_y;
  Particle(int _cor_x, int _cor_y) {
    cor_x = _cor_x;
    cor_y = _cor_y;
    pos = PVector.mult(PVector.random3D(), width);
    ppos = PVector.mult(PVector.random3D(), width);
    //ppos.x = floor(random(width));
    //ppos.y = floor(random(height));
    randomlize();
  }
  public void update() {
    pos.add(PVector.mult(PVector.sub(ppos, pos), 0.3f));
  }
  public void show() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);
    //stroke(map(pos.x, 0, width, 0, 255), 100, 200);
    stroke(255);

    if (cor_x%50==0 && cor_y%500==0) {
      fill(255, 0, 0);
      //text(nfc(cor_x/10- 50, 0), 10, 10);
      //text(nfc(cor_y/10- 50, 0), 10, 20);

      text(nfc(pos.x, 1), 10, 10);
      text(nfc(pos.y, 1), 10, 20);

      noFill();
    } else if (cor_y%50==0 && cor_x%500==0) {

      fill(255);
      //text(nfc(cor_x/10- 50, 0), 10, 10);
      //text(nfc(cor_y/10- 50, 0), 10, 20);
      text(nfc(pos.x, 1), 10, 10);
      text(nfc(pos.y, 1), 10, 20);
      noFill();
    }



    if (SG[3][6] == true) {
    }
    stroke(map(cor_x, 0, width, 0, 255), 
      map(cor_y, 0, height, 0, 255), 
      
      map(pos.z, -500, 500, 0, 255));
    stroke(180, 180, 250);

    if (cor_x%100==0 && cor_y%100==0) {
      for (int s=-5; s<5; s++) {
        if(SG[3][7] == true){
        stroke(255, 30, 30);
        }else if(SG[3][8]){
        stroke(255,250);
        }
        point(0+s, 0);        
        point(0, 0+s);
      }
    } else { 
      if (SG[3][5] == true) {
        stroke(180, 180, 250);
      } else if (SG[3][6]==true) {
        stroke(255, 250);
      }
      point(0, 0);
    }

    popMatrix();
  }
  public void returnToGrid() {
    ppos.x = cor_x;
    ppos.y = cor_y;
    ppos.z = random(-10, 10);
  }
  public void randomlize() { 
    ppos.x = random(width);
    //
    ppos.y = random(height);
    //ppos.y = random(960);
    //
    ppos.z = random(-3000, 3000);
  }
  public void randomSphere() {
    ppos = PVector.mult(PVector.random3D(), width/2);
  }
}

public void geometryInit() {

  for (int i=0; i<=total; i++) {
    float r = geometryR;
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    //float r2 = superShape(lat, m, n1, n2, n3);
    float r2 = 1;
    for (int j=0; j<=total; j++) {
      float lon = map(j, 0, total, -PI, PI);
      //float r1 = superShape(lon, m, n1, n2, n3);
      float r1 = 1;

      PVector[] temp = new PVector[6];
      //r = 200;
      float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
      temp[0] = new PVector(x1, y1, z1);

      float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
      temp[1] = new PVector(x2, y2, z2);

      float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
      temp[2] = new PVector(x3, y3, z3);

      //r =200;
      float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
      temp[3] = new PVector(x4, y4, z4);

      float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
      temp[4] = new PVector(x5, y5, z5);

      float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
      temp[5] = new PVector(x6, y6, z6);

      //geometry[i][j] = new Geometry(i, j, temp);

      geometry.add(new Geometry(i, j, temp));
    }
  }
}
public float superShape(float theta, float m, float n1, float n2, float n3) {
  float a=1;
  float b=1;
  //float r = 1;
  float t1 = abs((1/a)*cos(m*theta/4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b)*sin(m*theta/4));
  t2 = pow(t2, n3);
  float t3 = t1+t2;
  float r = pow(t3, -1/n1);

  //if (startMove)
  //  return r;
  //else 
  return 1;
}
class Geometry {
  PVector[] globe;
  PVector[] globeTar;
  int globeTint;
  PVector globeTexture;

  int ii, jj;
  float r;

  boolean flying = false;
  float flyingR1;
  float flyingR2;

  float explosionR1;
  float explosionR2;

  float R2;
  float R1;
  PVector center1;
  PVector center2;
  Geometry(int ei, int ej, PVector[] eglobeTar) {

    center1 = new PVector();
    center2 = new PVector();
    ii = ei;
    jj = ej;
    globeTar = eglobeTar;

    globe = new PVector[6];
    globeTexture = new PVector(PApplet.parseFloat(ii)/total, PApplet.parseFloat(jj)/total);
    globeTint = 255;
    for (int s=0; s<6; s++) {
      globe[s] = new PVector(0, 0, 0);
    }
    flyingR1 = 800;
    flyingR2 = 800;

    explosionR1 = geometryR + random(-300, 3000);
    explosionR2 = geometryR + random(-300, 3000);

    R1 = geometryR;
    R2 = geometryR;
  }
  public void update() {
    if (flying==true) {
      float lat = map(ii, 0, total, -HALF_PI, HALF_PI);
      //float r2 = superShape(lat, m, n1, n2, n3);
      float r2 = 1;
      float lon = map(jj, 0, total, -PI, PI);
      float r1 = 1;
      //float r1 = superShape(lon, m, n1, n2, n3);
      flyingR1 = geometryR+random(1200);
      flyingR2 = geometryR+random(1200);
      flyAway(r1, r2, flyI, flyJ, flyingR1, flyingR2);
      flying=false;
    }
    for (int s=0; s<6; s++) {
      globe[s].add((PVector.sub(globeTar[s], globe[s])).mult(0.1f));
    }
  }

  public void show(PVector tempRight, PVector tempDown, PVector tempRightDown, int showMode) {


    if (showMode == 0) {
      noFill();
      noStroke();
    } else if (showMode == 1) {
      noFill();
      stroke(255, 100);
    } else if (showMode == 2) {
      fill(255, 100);
    }
    pushMatrix();

    if (showMode == 1 && textureOn!=true) {
      beginShape(POINTS);
    } else {
      beginShape(TRIANGLE_STRIP);
    }
    if (textureOn==true) {
      //   texture(orbitTexture);
    } else {
      if (showMode == 0) {
        stroke(255, 150);
        //strokeWeight(0.5);
      } else if (showMode == 1) {
        stroke(255, 200);
      } else if (showMode == 2) {
        noStroke();
      }
    }
    textureMode(NORMAL);

    if (explosion) {
      translate(center1.x, center1.y, center1.z);
      rotate(radians(frameCount+ii+jj));
      float tempX, tempY, tempZ;

      scale(0.3f);
      vertex(globe[0].x-center1.x, globe[0].y-center1.y, globe[0].z-center1.z, globeTexture.y, globeTexture.x);
      vertex(globe[1].x-center1.x, globe[1].y-center1.y, globe[1].z-center1.z, tempRight.y, tempRight.x);
      vertex(globe[2].x-center1.x, globe[2].y-center1.y, globe[2].z-center1.z, tempDown.y, tempDown.x);
    } else {
      //println("Hi");
      vertex(globe[0].x, globe[0].y, globe[0].z, globeTexture.y, globeTexture.x);
      vertex(globe[1].x, globe[1].y, globe[1].z, tempRight.y, tempRight.x);
      vertex(globe[2].x, globe[2].y, globe[2].z, tempDown.y, tempDown.x);
    }
    endShape(CLOSE);

    if (showMode == 1&&textureOn!=true) {
      beginShape(POINTS);
    } else {
      beginShape(TRIANGLE_STRIP);
    }
    if (textureOn==true) {
      //  texture(orbitTexture);
    } else {
      if (showMode == 0) {
        stroke(255, 150);
        //strokeWeight(0.5);
      } else if (showMode == 1) {
        stroke(255, 200);
      } else if (showMode == 2) {
        noStroke();
      }
    }
    if (explosion) {
      translate(center2.x, center2.y, center2.z);
      rotate(radians(frameCount+ii+jj));
      float tempX, tempY, tempZ;

      //tempX= 
      scale(0.3f);
      vertex(globe[3].x-center2.x, globe[3].y-center2.y, globe[3].z-center2.z, globeTexture.y, globeTexture.x);
      vertex(globe[4].x-center2.x, globe[4].y-center2.y, globe[4].z-center2.z, tempRight.y, tempRight.x);
      vertex(globe[5].x-center2.x, globe[5].y-center2.y, globe[5].z-center2.z, tempDown.y, tempDown.x);
    } else {
      vertex(globe[3].x, globe[3].y, globe[3].z, globeTexture.y, globeTexture.x);
      vertex(globe[4].x, globe[4].y, globe[4].z, tempRight.y, tempRight.x);
      vertex(globe[5].x, globe[5].y, globe[5].z, tempDown.y, tempDown.x);
    }
    endShape(CLOSE);

    popMatrix();
  }
  public void exploded(float r1, float r2, float i, float j) {
    r = explosionR1;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
    PVector center1 = new PVector((x1+x2+x3)/3, (y1+y2+y3)/3, (z1+z2+z3)/3);


    r = explosionR2;
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
    PVector center2 = new PVector((x4+x5+x6)/3, (y4+y5+y6)/3, (z4+z5+z6)/3);

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  public void flyAway(float r1, float r2, float i, float j, float flyingR1, float flyingR2) {
    r = flyingR1;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
    PVector center1 = new PVector((x1+x2+x3)/3, (y1+y2+y3)/3, (z1+z2+z3)/3);

    r = flyingR2;
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
    PVector center2 = new PVector((x4+x5+x6)/3, (y4+y5+y6)/3, (z4+z5+z6)/3);

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  public void setNewLocation(float r1, float r2, float i, float j, float er) {
    r = er;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    r = er+random(-800, 800);
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  public void renewLocation(float r1, float r2, float i, float j) {
    r = R1;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    r = R2;
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  public void resetLocation(float r1, float r2, float i, float j) {
    r = geometryR;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    r = geometryR;
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  public void press() {
  }
}
public void transitionShow0to1() {
  blendMode(BLEND);
  transition0to1Dark+=3;
  println(transition0to1Dark);
  for (int s=0; s<blobs.size(); s++) {
    blobs.get(s).killMode1 = true;
  }
  if (transition0to1Dark>=255) {
    transition0to1Dark = 255;
    phase = 1; 
    transiting = false;
  }
  noStroke();
  colorMode(RGB, 255);
  fill(0, transition0to1Dark);
  rect(0, 0, width, height);
}
class textGenerator {
  char[] title;
  float[] titleFloat;
  float[] titleTargetFloat;

  int textLength;
  textGenerator(String S) {

    title = new char[15];
    titleFloat = new float[15];
    titleTargetFloat = new float[15];

    char[] temp = S.toCharArray();
    textLength = temp.length;
    for (int s=0; s<temp.length; s++) {
      titleTargetFloat[s] = PApplet.parseInt(temp[s]);
    }
  }
  public void show(float x, float y, int textSize) {
    for (int s=0; s<textLength; s++) {
      titleFloat[s] += (titleTargetFloat[s] - titleFloat[s])*0.3f;
      if ((titleTargetFloat[s] - titleFloat[s]) < 0.1f && (titleTargetFloat[s] - titleFloat[s])>0) {
        titleFloat[s]+=1;
      }
    }
    for (int s=0; s<textLength; s++) {
      title[s] = PApplet.parseChar(floor(titleFloat[s]));
    }
    int catchLength=0;
    for (catchLength=0; catchLength<textLength; catchLength++) {
      if (PApplet.parseChar(floor(titleFloat[catchLength])) == ' ')break;
    }
    char[] tempShow = new char[catchLength];
    for (int s=0; s<catchLength; s++) {
      tempShow[s]=PApplet.parseChar(floor(titleFloat[s]));
    }  
    textMode(SHAPE);
    textAlign(LEFT);
    pushMatrix();
    translate(x, y);
    textSize(textSize);
    fill(255);
    text(new String(tempShow), 0, 0);
    popMatrix();
  }
  public void showOnGraphics(float x, float y, int textSize, PGraphics P) {
    for (int s=0; s<textLength; s++) {
      titleFloat[s] += (titleTargetFloat[s] - titleFloat[s])*0.3f;
      if ((titleTargetFloat[s] - titleFloat[s]) < 0.1f && (titleTargetFloat[s] - titleFloat[s])>0) {
        titleFloat[s]+=1;
      }
    }
    for (int s=0; s<textLength; s++) {
      title[s] = PApplet.parseChar(floor(titleFloat[s]));
    }
    int catchLength=0;
    for (catchLength=0; catchLength<textLength; catchLength++) {
      if (PApplet.parseChar(floor(titleFloat[catchLength])) == ' ')break;
    }
    char[] tempShow = new char[catchLength];
    for (int s=0; s<catchLength; s++) {
      tempShow[s]=PApplet.parseChar(floor(titleFloat[s]));
    }
    P.pushMatrix();
    P.translate(x, y);
    P.textSize(textSize);
    P.fill(255);
    P.text(new String(tempShow), 0, 0);
    P.popMatrix();
  }
  public void update(String S) { 
    char[] temp = S.toCharArray();
    int newTextLength = temp.length;
    if (newTextLength < textLength) {
      for (int i=newTextLength; i<textLength; i++) {
        titleTargetFloat[i] = PApplet.parseInt(' ');
      }
    } else {
      textLength = newTextLength;
    }
    for (int s=0; s<temp.length; s++) {
      titleTargetFloat[s] = PApplet.parseInt(temp[s]);
    }
  }
}
public void CPUperformanceUpdate() {
  for (Method method : operatingSystemMXBean.getClass().getDeclaredMethods()) {
    method.setAccessible(true);
    if (method.getName().startsWith("get") && Modifier.isPublic(method.getModifiers())) {
      Object value;
      try {
        value = method.invoke(operatingSystemMXBean);
      } 
      catch (Exception e) {
        value = e;
      } 
      //System.out.println(method.getName() + " = " + value);
      if (method.getName() == "getProcessCpuLoad") {
        fill(255);
        CPUperform = nfc(PApplet.parseFloat(value.toString())*100, 3);
      }
    }
  }
}
public PImage imageGlitch(PImage P) {
  PImage temp = P;

  temp.loadPixels();
  colorMode(RGB);
  int randomColor = color(random(255), random(255), random(255), 255);

  if (random(100)<15) {
    if (random(100)<15) {
      for (int y=0; y<temp.height; y++) {
        if (random(100)<15) {
          for (int x=0; x<temp.width; x++) {
            // get the color for the pixel at coordinates x/y
            int pixelColor = temp.pixels[y + x * temp.height];
            // percentage to mix
            float mixPercentage = .5f + random(50)/25;
            // mix colors by random percentage of new random color
            //temp.pixels[y + x * temp.height] =  lerpColor(pixelColor, randomColor, mixPercentage);
            temp.pixels[y + x * temp.height] = randomColor;
            if (random(100)<15) {
              randomColor = color(random(255), random(255), random(255), 255);
            }
          }
        }
      }
    }
  }


  temp.updatePixels();

  if (random(100)<70) {
    for (int s=0; s<10; s++) {
      int x1 = 0;
      int y1 = floor(random(temp.height));

      int x2 = round(x1 + random(-30, 30));
      int y2 = round(y1 + random(-4, 4));

      int w = temp.width;
      int h = floor(random(10));
      temp.set(x2, y2, temp.get(x1, y1, w, h));
    }
  }
  return temp;
}
  public void settings() {  size(3840, 960, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#080000", "--hide-stop", "liftoff_Reentry_pde" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
