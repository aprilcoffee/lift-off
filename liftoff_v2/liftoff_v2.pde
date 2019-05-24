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
boolean[][] signalChange;

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

ArrayList<Particle> particle;
int[] constellation;


void setup() {
  size(1920, 1080, P3D);
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
  oscP5.plug(this, "linear", "/linear");  
  signalChange = new boolean[10][20];
  for (int y=0; y<20; y++) {
    for (int x=0; x<10; x++) {
      signalChange[x][y] = false;
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
  for(int s=0;s<8;s++){
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


  particle = new ArrayList<Particle>();
  for (int x=0; x<=width; x+=20) {
    for (int y=0; y<=height; y+=20) {
      particle.add(new Particle(x, y));
    }
  }  
  constellation = new int[6];  
  camShakeX = 0;
  camShakeY = 0;
  camShakeXX = 0;
  camShakeYY = 0;

  runtime = java.lang.Runtime.getRuntime();
}
void draw() {
  soundCheck();
  background(0);


  mode1();


  //Showing FPS performance && Garbage Collecting
  if (frameCount % 3600 ==0)runtime.gc();
  surface.setTitle(str(frameRate));


  //Signal Reset
  for (int y=0; y<20; y++) {
    for (int x=0; x<10; x++) {
      signalChange[x][y] = false;
    }
  }
}
void blackHole() {
  translate(width/2, height/2);

  blendMode(ADD);
  pushMatrix();
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
}
