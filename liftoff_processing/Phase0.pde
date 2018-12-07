
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
