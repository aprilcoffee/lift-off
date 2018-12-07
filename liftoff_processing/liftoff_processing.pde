import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

Runtime runtime;
OperatingSystemMXBean operatingSystemMXBean;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;
import ddf.minim.effects.*;
import oscP5.*;
import netP5.*;
import javax.sound.sampled.*;

import themidibus.*; //Import the library

OscP5 oscP5;
NetAddress myRemoteLocation;
MidiBus myBus; // The MidiBus
boolean[] midiBusing;


import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

//modeCheck
int phase = 0;
int transition=0;
boolean transiting = false;
int transition0to1Dark = 0;
int transition1to2Dark = 0;
int transition2to3Dark = 0;
int transition3to0Dark = 0;

//audioSetup
Minim minim;  
AudioInput in;
FFT fftLin;
float height23;
float spectrumScale = 4;
float totalAmp = 0;

//initPhase
PImage LTGlogo;
PImage glitchBG;
boolean initVideoTrigger = false;
boolean initVideoPlaying = false;

//Phase1
int phase1Counter = 0;
PImage[] spaceImg;
PImage[] spaceImgBW;
boolean photoTrigger = false;
boolean photoTriggerImageRect = false;
boolean photoTriggerImageBW = false;
boolean photoTriggerImage = false;
boolean photoKill = false;
boolean photoSpin = false;
boolean glitchTrigger = false;
boolean glitchEnd = false;
int showImageCounterAfterSpin = 0;
boolean waterTrigger = false;
boolean targetSystemLineA = false;
boolean targetSystemLineB = false;
boolean targetSystemShow = false;
boolean targetingCenter = false;
boolean phase1CornerCall = false;
int photoLength =25;
ArrayList photoToShow;
float phase1offX = random(100);
ArrayList<TargetSystem> targetSystem;
ArrayList<TargetShot> targetShot;
ArrayList<SpaceImages> spaceImages;
ArrayList<ObservateStar> observateStar;
PGraphics observateStarBackground;
boolean ChangeObservationStar = false;
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
float dampening = 0.95;


//phase2
int phase2Counter = 0;
PGraphics starField;
PGraphics orbitTexture;
ArrayList<Star> stars = new ArrayList<Star>();
float speed;
int starWidth = 800;
int starHeight = 450;
Geometry[][] geometry;
float geometryR = 450;
int total =70;
boolean flyAway = false;
boolean changeGeometryMove=false;
int flyI=0;
int flyJ=0;
boolean addStarTrigger = false;
int starTriggerCount = 0;
int flyingAwayCount = 0;
boolean showAllgeo = false;
boolean textureOn = false;
boolean crashSide = false;
boolean showHalf = false;
boolean showHalfTrigger = false;
boolean startMove = false;
boolean changeTexture = false;
boolean spinMoveFaster = false;
boolean starGoCenter = false;
boolean geoMoving = false;
boolean resetGeoLocation = false;
boolean explosion = false;
PImage[] planetImage;
int planetImageLength = 6;
int currentPlanetImage = 0;
int newLonMinHalf = 0;    
int newLonMaxHalf = 0; 
int newLatMinHalf = 0;    
int newLatMaxHalf = 0;   
float phase3moveA; 
float phase3moveT;


//phase3
int phase3Counter = 0;
PVector[] attractors;
int attractorsSize = 2;
ArrayList<Particle> particles;
ArrayList<Blob> blobs;
int cols, rows;
int scl = 10;
int w = 500;
int h = 800;
float[][] terrainLeft;
float[][] terrainRight;
float[] audioAmp;
int fc;
int totalBallNum = 80;
ArrayList ballCollection;
boolean save = false;
float scal, theta;
boolean moveYes=false;
PGraphics juliaTexture;
float juliaAngle;
boolean juliaShowTrigger = false;
boolean changeBalls = false;
boolean changeTerrainMode = false;
int TerrainMode = 0;
boolean moveStuff=false;
boolean phase3ShowBalls = false;
boolean phase3ShowTerrain = false;
boolean phase3ShowAttrator = false;

PFont font_trench;
String CPUperform="";


// shaba mode 2
int shabaMode2 = 0;
void setup() {
  //size(1920, 1080, P3D);
  //size(1280, 800, P3D);
  fullScreen(P3D, 1);
  frameRate(30);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);
  //colorMode(HSB, 255);
  smooth(5);

  //fontinit
  font_trench = createFont("font/trench100free.ttf", 32);   
  textFont(font_trench);

  //OSCinit
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 13000);
  oscP5.plug(this, "test", "/test");
  oscP5.plug(this, "mode", "/mode");  
  oscP5.plug(this, "con", "/con");  
  midiBusing = new boolean[18];
  for (int s=0; s<16; s++) {
    midiBusing[s]=false;
  }
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, "LK Mini InControl", "LK Mini InControl"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  //initPhase
  LTGlogo = loadImage("LTG.png");
  glitchBG = loadImage("Pixels.jpg");

  //soundDetect
  minim = new Minim(this);
  in = minim.getLineIn();
  fftLin = new FFT( in.bufferSize(), in.sampleRate() );
  fftLin.logAverages( 22, 3 );

  //phase1
  spaceImg = new PImage[photoLength];
  spaceImgBW = new PImage[photoLength];
  for (int s=0; s<photoLength; s++) {
    spaceImg[s] = loadImage("space_imgs/"+(s+1)+".jpeg");
    spaceImgBW[s] = loadImage("space_imgsBW/"+(s+1)+".jpeg");
  } 
  ballCollection = new ArrayList();
  createStuff();

  targetSystem = new ArrayList<TargetSystem>();
  targetSystem.add(new TargetSystem(200, random(360), 1));
  targetSystem.add(new TargetSystem(200, random(360), -1));
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

  //mode2
  starField = createGraphics(800, 450, P3D);
  orbitTexture = createGraphics(600, 600, P3D);
  planetImage = new PImage[planetImageLength];
  for (int s=0; s<planetImageLength; s++) {
    planetImage[s] = loadImage("planet"+s+".jpeg");
  }
  geometry = new Geometry[total+1][total+1];
  geometryInit();
  //starField.beginDraw();

  //mode3
  particles = new ArrayList<Particle>();
  attractors = new PVector[10];
  for (int s=0; s<attractorsSize; s++) {
    attractors[s] = new PVector(width/2, height/2);
  }
  for (int s=0; s<300; s++) {
    particles.add(new Particle(width/2, height/2+random(-200, 200), random(-50, 50)));
  }
  blobs = new ArrayList<Blob>();
  for (int s=0; s<5; s++) {
    blobs.add(new Blob(0, 0, random(330, 350)));
  }
  juliaTexture = createGraphics(640, 480);

  cols = w/scl;
  rows = h/scl;
  terrainLeft = new float[cols][rows];
  terrainRight = new float[cols][rows];
  audioAmp = new float[rows];
  for (int y = 0; y < rows; y++) { 
    for (int x = 0; x < cols; x++) {
      terrainLeft[x][y] = 0;
      terrainRight[x][y] = 0;
    }
    audioAmp[y] = 0;
  }
  //operatingSystemMXBean = ManagementFactory.getOperatingSystemMXBean();
  runtime = java.lang.Runtime.getRuntime();
  phase = 3;
}
void draw() {
  //if (frameCount % 10 ==0) {
  //  println(str(frameRate));
  // }
  if (transiting) {
    switch(transition) {
    case 0:
      break;
    case 1:
      println("trans0to1");
      soundCheck();
      initPhase();
      transitionShow0to1();
      break;
    case 2:
      println("trans0to1");
      mode1();
      transitionShow1to2();
      mode2();
      break;
    case 3:
      mode2();
      transitionShow2to3();
      mode3();
      break;
    case 4:
      transitionShow3to0();
      break;
    }
  } else {
    switch(phase) {
    case 0:
      soundCheck();
      initPhase();
      break;
    case 1:
      mode1();
      phase1Counter++;
      break;
    case 2:
      mode2();
      phase2Counter++;
      break;
    case 3:
      mode3();
      phase3Counter++;
      break;
    case 4:
      initPhase();      
      break;
    }
  }

  //if (frameCount==0)filter(INVERT);
  //fx.render();  
  if (frameCount % 3600 ==0)runtime.gc();
  surface.setTitle(str(frameRate));
}
/*
void keyPressed() {
 if (key == '1') {
 shabaMode2 = 0;
 }
 if (key == '2') {
 shabaMode2 = 1;
 }
 if (key == '3') {
 shabaMode2 = 2;
 }
 }*/
