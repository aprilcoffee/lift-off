//CPU monitoring 
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
Runtime runtime;
OperatingSystemMXBean operatingSystemMXBean;

//Sound Control from MAX & Controller
import oscP5.*;
import netP5.*;
import themidibus.*; //Import the library
import javax.sound.sampled.*;
OscP5 oscP5;
NetAddress myRemoteLocation;
MidiBus myBus; // The MidiBus
Midi midi;
boolean[][] SG;
int[][] CN;

//Sound Analyze
import processing.sound.*;
AudioIn input;
Amplitude loudness;
FFT fft; 
int band = 128;
float smoothFactor = 0.2;
float[] sum = new float[band];
int scale = 5;
float barWidth;
float volume;
int currentBeat = 0;


//Shader PostFix
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
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
int transition3to4Dark = 0;
int transition4to5Dark = 0;
float transitionFuck = 0;
int modeFrameCount[];

int screenAdjust = 0;

//initPhase
PImage LTGlogo;
PImage glitchBG;
boolean initVideoTrigger = false;
boolean initVideoPlaying = false;

//Phase0
ArrayList<Blob> blobs;

//Phase1
boolean phase1mode = false;
PImage[] bluePrint;
int bluePrintLength = 7;
int phase1ImageFlag = 0;


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
float dampening = 0.965;

//Phase3
ArrayList<Particle> particle;
int[] constellation;

//Phase4
int total = 60;
float geometryR = 550;
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

int phase2Counter = 0;
PGraphics starField;
PGraphics orbitTexture;
ArrayList<Star> stars = new ArrayList<Star>();
float speed;
int starWidth = 800;
int starHeight = 450;
boolean flyAway = false;
boolean changeGeometryMove=false;
boolean addStarTrigger = false;
int starTriggerCount = 0;
int flyingAwayCount = 0;
boolean showAllgeo = false;
boolean crashSide = false;
boolean showHalf = false;
boolean showHalfTrigger = false;
boolean startMove = false;
boolean changeTexture = false;
boolean spinMoveFaster = false;
boolean starGoCenter = false;
boolean geoMoving = false;
boolean resetGeoLocation = false;
boolean phase2BWtrigger = false;
PImage[] planetImage;
int planetImageLength = 6;
int currentPlanetImage = 0;
float phase3moveA; 
float phase3moveT;



//Phase ChangeFuckingMode
PImage crashImg;
boolean changeFinish =false;


void setup() {
  // size(3840, 2160, P3D);
  //size(1920, 1080, P3D);
  fullScreen(P3D);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);

  //Sound input init
  input = new AudioIn(this, 0);
  input.start();
  loudness = new Amplitude(this);
  loudness.input(input);
  barWidth = width/float(band);
  fft = new FFT(this, band);
  fft.input(input);

  //Shader Post Fix init
  fx = new PostFX(this);

  //OSC init
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  oscP5.plug(this, "sig", "/sig");
  oscP5.plug(this, "mode", "/mode");  
  oscP5.plug(this, "con", "/con");  
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

  //phase1
  bluePrint = new PImage[bluePrintLength];
  for (int s=0; s<bluePrintLength; s++) {
    bluePrint[s] = loadImage("bluePrint/0"+(s+1)+".jpeg");
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



  //Phase3
  particle = new ArrayList<Particle>();
  for (int x=0; x<=width; x+=30) {
    for (int y=0; y<=height; y+=30) {
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
  starField = createGraphics(800, 450, P3D);
  orbitTexture = createGraphics(600, 600, P3D);
  planetImage = new PImage[planetImageLength];
  for (int s=0; s<planetImageLength; s++) {
    planetImage[s] = loadImage("planet"+s+".jpeg");
  }

  //phase ChangeFuckingMode
  crashImg = loadImage("crash.jpg");

  runtime = java.lang.Runtime.getRuntime();  
  phase = 2;
}
void draw() {
  soundCheck();
  //background(0);
  //println("now Phase " + phase);
  if (SG[6][1]==true && changeFinish==false) {
    mode5();
  } else if (transiting) {
    switch(transition) {
    case 0:
      break;
    case 1:
      initPhase();
      transitionShow0to1();
      break;
    }
  } else {
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
      initPhase();
      break;


    case 12:
      mode1();
      mode2();
      break;
    case 34:
      mode3();
      mode4();
      break;
    case 15:
      mode1();
      mode2();
      mode3();
      mode4();
      break;
    }
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
void blackHole() {
  pushMatrix();
  translate(width/2, height/2);

  pushMatrix();
  blendMode(ADD);
  for (int s=0; s<50; s++) {
    rotateX(radians(s+float(frameCount)/21.3));
    rotateY(radians(s+float(frameCount)/16.8));
    fill(255, abs(-s*4), 0, 20); 
    ellipse(0, 0, 100+s*4.5, 100+s*4.5);
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
