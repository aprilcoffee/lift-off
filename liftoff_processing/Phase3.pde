
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
  void update() {
    PVector newVel = new PVector(0, 0);
    newVel.div(50);
    newVel.limit(3);
    vel.lerp(newVel, 0.2);
    pos.add(vel);
  }

  void cons() {
    pos.x = constrain(pos.x, -width/4, width/4);
    pos.y = constrain(pos.y, -height/4, height/4);
  }
  void showMode1() {
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
    for (float i =0; i<=TWO_PI; i+=0.1) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01;
  }
  void show() {

    //fill(255);
    noFill();
    stroke(255, 100);
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01;
  }
  void showWithFill() {
    //fill(255);
    noFill();
    stroke(255, 150);
    strokeWeight(2);
    fill(0, 100);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01;
  }
}

class Particle {
  PVector pos;
  PVector prevPos;
  ArrayList<PVector> trace;
  int traceLength = 10;

  PVector vel;
  PVector acc;

  float colorCode;
  Particle(float ex, float ey, float ez) {
    pos = new PVector(ex, ey, ez);
    prevPos = pos.copy();
    vel = PVector.random3D();
    vel.setMag(random(3, 5));
    acc = new PVector(0, 0, 0);

    trace = new ArrayList<PVector>();
    for (int s=0; s<traceLength; s++) {
      trace.add(new PVector(pos.x, pos.y, pos.z));
    }
    colorCode = random(10);
  }
  void update() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(15);
    acc.mult(0);
  }
  void show() {
    noFill();
    stroke(255, 10);
    strokeWeight(1);
    //point(pos.x, pos.y);
    //line(pos.x, pos.y, prevPos.x, prevPos.y);
    //colorMode(HSB, 255);
    //blendMode(ADD);
    int showLength = (int)map(constrain(fftLin.getAvg(0)*spectrumScale, 0, 400), 0, 400, 0, trace.size());
    //println(fftLin.getAvg(0));
    for (int s=traceLength-1; s>traceLength-showLength; s--) {
      if (colorCode<6) {
        colorMode(HSB);
        stroke( 
          map(s, traceLength-showLength, traceLength, 80, 120), 
          map(s, traceLength-showLength, traceLength, 0, 120), 
          map(s, traceLength-showLength, traceLength, 50, 140), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      } else {
        stroke( 
          map(s, traceLength-showLength, traceLength, 200, 255), 
          map(s, traceLength-showLength, traceLength, 0, 120), 
          map(s, traceLength-showLength, traceLength, 50, 120), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      }
      line(trace.get(s-1).x, trace.get(s-1).y, trace.get(s).x, trace.get(s).y);
    }
    trace.remove(0);
    trace.add(new PVector(pos.x, pos.y));
  }
  void attracted(PVector target, int flag) {
    PVector force = PVector.sub(target, pos);
    float dsquared = force.magSq();
    dsquared = constrain(dsquared, 50, 400);
    float G = 150;
    float strength = G/dsquared;
    force.setMag(strength);
    acc.add(force);
  }
}

void drawTerrainInGraphics(PGraphics P) {
  P.beginDraw();
  P.background(0, 0);
  for (int y = rows-1; y >= 1; y--) {
    for (int x = 0; x < cols; x++) {  
      terrainLeft[x][y] = terrainLeft[x][y-1];
      terrainRight[x][y] = terrainRight[x][y-1]; 
      audioAmp[y]=audioAmp[y-1];
    }
  }
  audioAmp[0] = 0;
  for (int x = 0; x < cols; x++) {
    terrainLeft[x][0] = in.left.get(x)*150;
    terrainRight[x][0] = in.right.get(x)*150;
    audioAmp[0]+=abs(fftLin.getBand(x*5))*15;//renew Amount of Sound
  }
  P.camera(0, -100, 1000, 0, 0, 0, 0, 1, 0);
  //P.translate(0, 300);
  //println(audioAmp[0]);
  //background(255); 
  //blendMode(ADD);
  //println(fft.specSize());
  //-------------------terrain1-------------------
  P.pushMatrix();
  //noFill();
  //fill(255,0,0);
  //translate(-300, 0);
  P.rotateX(PI/2);
  P.scale(2, 1);
  //translate(-w/2, -h/2); //*****Move a little
  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>5000) {
      P.stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
    } else {
      P.stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    P.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x+=3) {
      //noStroke();
      //fill(audioAmp[y], audioAmp[y], audioAmp[y], 100);
      P.noFill();
      P.stroke(255);
      P.vertex(x*scl, y*scl, terrainLeft[x][y]);
      P.vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
    }
    P.endShape();
  }
  P.popMatrix();

  //-------------------terrain2-------------------

  P.pushMatrix();
  //translate(300, 0);
  P.rotateX(PI/2);
  P.scale(2, 1);

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>5000) {
      P.stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
    } else {
      P.stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    P.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x+=3) {
      //noStroke();
      //fill(map(audioAmp[y],0,20000,0,255), audioAmp[y], audioAmp[y], 50);
      P.noFill();
      P.stroke(255);
      P.vertex(-x*scl, y*scl, terrainRight[x][y]);
      P.vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
    }
    P.endShape();
  }
  P.popMatrix();
  P.endDraw();
}



void drawTerrain() {
  for (int y = rows-1; y >= 1; y--) {
    for (int x = 0; x < cols; x++) {  
      terrainLeft[x][y] = terrainLeft[x][y-1];
      terrainRight[x][y] = terrainRight[x][y-1]; 
      audioAmp[y]=audioAmp[y-1];
    }
  }
  audioAmp[0] = 0;
  for (int x = 0; x < cols; x++) {
    terrainLeft[x][0] = in.left.get(x)*150;
    terrainRight[x][0] = in.right.get(x)*150;
    audioAmp[0]+=abs(fftLin.getBand(x*5))*15;//renew Amount of Sound
  }
  camera(0, -100, 1000, 0, 0, 0, 0, 1, 0);
  translate(0, 300);
  //println(audioAmp[0]);
  //background(255); 
  //blendMode(ADD);
  //println(fft.specSize());
  //-------------------terrain1-------------------
  pushMatrix();
  //noFill();
  //fill(255,0,0);
  //translate(-300, 0);
  rotateX(PI/2);
  scale(2, 1);
  //translate(-w/2, -h/2); //*****Move a little
  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>5000) {
      stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      println(audioAmp[y]);
    } else {
      println(audioAmp[y]);
      stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x+=3) {
      //noStroke();
      //fill(audioAmp[y], audioAmp[y], audioAmp[y], 100);
      noFill();
      stroke(255);
      vertex(x*scl, y*scl, terrainLeft[x][y]);
      vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
    }
    endShape();
  }
  popMatrix();

  //-------------------terrain2-------------------

  pushMatrix();
  //translate(300, 0);
  rotateX(PI/2);
  scale(2, 1);

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>5000) {
      stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      println(audioAmp[y]);
    } else {
      println(audioAmp[y]);
      stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x+=3) {
      //noStroke();
      //fill(map(audioAmp[y],0,20000,0,255), audioAmp[y], audioAmp[y], 50);
      noFill();
      stroke(255);
      vertex(-x*scl, y*scl, terrainRight[x][y]);
      vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
    }
    endShape();
  }
  popMatrix();
}
