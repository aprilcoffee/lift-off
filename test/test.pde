import processing.sound.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
PostFX fx;

AudioIn input;
Amplitude loudness;

float camX=0, camY=0, camZ=0;

float camAA = 0, camTT = 0, camRR = 1000;
float camA = 0, camT = 0, camR = 1000;

PGraphics canvas;

void setup() {  
  fx = new PostFX(this);  

  canvas = createGraphics(1200, 1200, P3D);
  size(1200, 1200, P3D);

  input = new AudioIn(this, 0);
  input.start();

  loudness = new Amplitude(this);
  loudness.input(input);
  input.amp(1);
}
void draw() {
  background(0);

  float volume = loudness.analyze();
  volume *= 10;
  volume = norm(volume, 0, 2);

  //translate(width/2, height/2);

  int flagX = 0;
  int flagY = 0;
  if (volume > 0.8) {
    println("Hi");
    if (random(2)>1)
      flagX = floor(random(2));
    else
      flagY = floor(random(2));
    camAA = random(-179, 0);
    camTT = random(-89, 89);
    camRR = random(1000, 1500);
  }


  camA += (camAA-camA)*0.05;
  camT += (camTT-camT)*0.05;
  camR += (camRR-camR)*0.05;

  float camX = camR * cos(radians(camA))*cos(radians(camT));
  float camY = camR * sin(radians(camT));
  float camZ = camR * sin(radians(camA))*cos(radians(camT));


  //camera(mouseX, mouseY, 4000, 0, 0, 0, 0, 1, 0);



  float flag = abs(125*sin(radians(frameCount)));

  float targetA = float(frameCount)/2;
  float targetX = width/2 + width/3*cos(radians(targetA));
  float targetY = height/2 + height/3*sin(radians(targetA));

  for (int s=0; s<=width; s++) {
    set(s, floor(targetY), color(200));
  }
  for (int s=0; s<=height; s++) {
    set(floor(targetX), s, color(200));
  }
  for (int y=0; y<=height; y+=15) {
    for (int x = 0; x<=width; x+=15) {
      if (x%150==0 && y%150==0) {
        for (int i=-5; i<=5; i++) {
          set(x+i, y, 
            color(255*norm(dist(x, y, targetX, targetY), width, 0)));
          set(x, y+i, 
            color(255*norm(dist(x, y, targetX, targetY), width, 0)));
        }
      } else {
        set(x, y, 
          color(255*norm(dist(x, y, targetX, targetY), width/2, 0)));
      }
    }
  }

  canvas.beginDraw();
  canvas.background(0);

  canvas.camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);

  canvas.blendMode(ADD);
  pushMatrix();
  for (int s=0; s<100; s++) {
    canvas.rotateX(radians(s/2+float(frameCount)/16));
    canvas.rotateY(radians(s/2+float(frameCount)/4));
    canvas.noStroke();
    canvas.fill(255, abs(-s), 0, 4);
    // canvas.stroke(abs(-s), 90);
    canvas.lights();
    canvas.ellipse(0, 0, 100+s*4, 100+s*4);
  }
  popMatrix();

  canvas.hint(DISABLE_DEPTH_TEST);
  canvas.blendMode(BLEND);
  canvas.noStroke();
  for (int s=0; s<40; s++) {
    canvas.fill(0, 40);
    //ellipse(0, 0, s*4*volume, s*4*volume);
    canvas.noStroke();
    canvas.sphere(50+s*volume);
  }


  canvas.endDraw();
  blendMode(ADD);
  image(canvas, 0, 0, width, height);

  blendMode(SCREEN);
  fx.render(canvas)
    //.sobel()   
    .brightPass(0.5)
    .blur(20, 40)
    //.bloom(10,12,3)
    .compose();
}
