
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
  int traceLength = 50;

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
    vel.limit(10);
    acc.mult(0);
  }
  void show() {
    noFill();

    stroke(255, 10);
    strokeWeight(1);
    //point(pos.x, pos.y);
    //line(pos.x, pos.y, prevPos.x, prevPos.y);
    //colorMode(HSB, 255);
    blendMode(ADD);
    for (int s=1; s<trace.size(); s++) {
      if (colorCode<8) {
        stroke( 
          map(s, 0, traceLength, 80, 120), 
          map(s, 0, traceLength, 40, 120), 
          map(s, 0, traceLength, 150, 255), 
          map(s, 0, traceLength, 100, 200));
      } else {
        stroke( 
          map(s, 0, traceLength, 200, 255), 
          map(s, 0, traceLength, 0, 120), 
          map(s, 0, traceLength, 150, 255), 
          map(s, 0, traceLength, 100, 200));
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
    float G = 50;
    float strength = G/dsquared;
    force.setMag(strength);

    acc.add(force);
  }
}
