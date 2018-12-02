
void setupWater() {
  waterCols = waterRipple.width;
  waterRows = waterRipple.height;
  currentWater = new float[waterCols][waterRows];
  previousWater = new float[waterCols][waterRows];
}
void drawWaterRipple() {
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
void ShowobservationStar() {
  if (ChangeObservationStar==true) {
    if (observationCount>1300)observationCount = 1300;
    observationCount ++;
    observateStarStartPoint = (int)random(observateStar.size()-observationCount);
    observateStarEndPointEasing =observateStarStartPoint;
    observateStarEndPoint = observateStarStartPoint+observationCount;
    ChangeObservationStar=false;
  }
  observateStarBackground.beginDraw();
  //observateStarBackground.clear();
  observateStarBackground.background(0, 0);
  observateStarBackground.translate(observateStarBackground.width/2, observateStarBackground.height/2);
  observateStarBackground.rotate(radians(15));
  observateStarEndPointEasing += (observateStarEndPoint-observateStarEndPointEasing)*0.3;

  for (int s=observateStarStartPoint; s<observateStarEndPointEasing; s++) {
    ObservateStar Rt = observateStar.get(s);
    Rt.updateRoot(observateStarBackground);
    Rt.drawRoot(observateStarBackground);
  }
  observateStarBackground.endDraw();
}
class TargetSystem {
  textGenerator text_locX;
  textGenerator text_locY;
  textGenerator text_angle;
  float x, y;
  float px, py;
  float r;
  float angle;
  float ori_v;
  float v;
  int dir;
  int targetMode;
  float easing = 0.1;
  TargetSystem(float er, float ea, int edir) {
    r = er;
    angle = ea;
    dir = edir;
    v = random(0.7, 2);
    ori_v = v;
    //targetMode = etargetMode;
    text_locX = new textGenerator("");
    text_locY = new textGenerator("");
    text_angle = new textGenerator("");
  }
  void resetVel() {
    v = 0;
  }
  void update() {
    x = r * cos(radians(angle));
    y = r * sin(radians(angle));
    angle += abs(v*dir);
    v+=(ori_v-v)*easing;
    text_locX.update(nfc(x, 3));
    text_locY.update(nfc(y, 3));
    text_angle.update(nfc(angle, 3));
  }
  void showBall() {
    if (targetSystemShow == true) {
      if (dir>0) {
        for (int s=0; s<=20; s+=4) {
          stroke(255, 0, 0, 150*sin(radians(map(s, -20, 20, 0, 180))));
          line(x-s, -height, x-s, height);
        }
      } else {
        for (int s=0; s<=20; s+=4) {
          stroke(255, 0, 0, 150*sin(radians(map(s, -20, 20, 0, 180))));
          line(-width, y-s, width, y-s);
        }
      }
      pushMatrix();
      translate(x, y);
      text_locX.show(10, -15, 12);
      text_locY.show(10, 0, 12);
      text_angle.show(10, 15, 12);
      noStroke();
      fill(255);
      ellipse(0, 0, 5, 5);
      popMatrix();
    } else if (targetSystemLineA==true) {
      if (dir>0) {
        for (int s=0; s<=100; s+=4) {
          stroke(255, 255, 255, 150*sin(radians(map(s, -100, 100, 0, 180))));
          line(x-s, -height, x-s, height);
        }
      }
    } else if (targetSystemLineB==true) {
      if (dir==-1)
        for (int s=0; s<=100; s+=4) {
          stroke(255, 255, 255, 150*sin(radians(map(s, -100, 100, 0, 180))));
          line(-width, y-s, width, y-s);
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
    a = 0.1;
  }
  void update() {
    r+=v;
    v+=a;
    life *=0.95;
  }
  void show() {
    fill(255);
    noFill();
    stroke(life);
    ellipse(x, y, r, r);
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
  int imageFlag = int(random(photoLength));
  boolean dead = false;
  textGenerator text_locX;
  textGenerator text_locY;
  float textX;
  float textY;
  int dir;
  float spin = 0;
  float spinAdjust;
  float spinRadians;
  SpaceImages(float ex, float ey, int edir, float targetX) {
    photoX = ex;
    photoY = ey;
    photoZ = 0;
    dir = edir;
    if (dir==0)photoX = -photoX;
    spinRadians = photoX;

    text_locX = new textGenerator("");
    text_locY = new textGenerator("");
    textX = targetX+random(-15, 15);
    textY = photoY;
    spin = random(360);
    spinAdjust = random(3);
    spin = 90;
    spinAdjust = 0;
  }
  void update() {
    imageSizeY = ori_imageSizeY*sin(radians(angle));
    text_locX.update(nfc(photoX, 3));
    text_locY.update(nfc(photoY, 3));
    if (dead) { 
      imageSizeX = ori_imageSizeX + tan(radians(angle+45));
      angle += 10;
    }
    photoX = spinRadians*sin(radians(spin));
    photoZ = spinRadians*cos(radians(spin));
    spin += spinAdjust;
  }
  void kill() {
    dead = true;
  }
  void showImage() {
    noFill();
    pushMatrix();
    translate(photoX, photoY, photoZ);
    image(spaceImg[imageFlag], 0, 0, imageSizeX, imageSizeY);
    rect(0, 0, imageSizeX, imageSizeY);
    popMatrix();
    text_locX.show(textX, textY-10, 10);
    text_locY.show(textX, textY+10, 10);
    if (dir==1)
      line(photoX-imageSizeX/2, photoY, photoZ, textX, textY, 0);
    else
      line(photoX+imageSizeX/2, photoY, photoZ, textX, textY, 0);
  }
  void showWithoutImage() {
    noFill();
    pushMatrix();
    rect(photoX, photoY, imageSizeX, imageSizeY);
    text_locX.show(textX, textY-10, 10);
    text_locY.show(textX, textY+10, 10);
    if (dir==1)
      line(photoX-imageSizeX/2, photoY, textX, textY);
    else
      line(photoX+imageSizeX/2, photoY, textX, textY);
    popMatrix();
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
  void updateRoot(PGraphics P) {
    px = ori_px + R*cos(radians(angle));
    py = ori_py + R*sin(radians(angle));
    angle+=random(0.75);
    //R = R * 0.995;
  }
  void drawRoot(PGraphics P) {
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

void createStuff() {
  ballCollection.clear();
  for (int i=0; i<totalBallNum; i++) {
    float tempX, tempY;
    float R=random(200);
    tempX = R*cos(radians(random(360)));
    tempY = R*sin(radians(random(360)));
    PVector org = new PVector(tempX, tempY);
    float radius = random(20, 80);
    PVector loc = new PVector(org.x+radius, org.y);
    float offSet = random(TWO_PI);
    int dir = 1;
    float r = random(1);
    if (r>0.5) dir =-1;

    Ball myBall = new Ball(org, loc, radius, dir, offSet);
    ballCollection.add(myBall);
  }
}
class Ball {
  PVector org, loc;
  float sz = 2;
  float radius, offSet, a, c;
  float[] col = new float[totalBallNum];
  int s, dir, countC, d = 40;
  boolean[] connection = new boolean[totalBallNum];

  Ball(PVector _org, PVector _loc, float _radius, int _dir, float _offSet) {
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
  }

  void run() {
    display();
    move();
    lineBetween();
  }

  void move() {
    if (moveYes==true) {
      loc.x = org.x + sin(theta*dir+offSet)*radius+tan(theta*dir);
      loc.y = org.y + cos(theta*dir+offSet)*radius+tan(theta*dir);
    } else {
      loc.x = org.x + sin(theta*dir+offSet)*radius;//+tan(theta*dir);
      loc.y = org.y + cos(theta*dir+offSet)*radius;//+tan(theta*dir);
    }
  }
  void lineBetween() {
    countC = 1;
    for (int i=0; i<ballCollection.size(); i++) {
      Ball other = (Ball) ballCollection.get(i);
      float distance = loc.dist(other.loc);
      if (distance >0 && distance < d) {
        connection[i] = true;
      } else {
        connection[i] = false;
      }
      if (connection[i]) countC++;
      //println(countC);
      if (distance >0 && distance < d) {
        a = map(countC, 1, 20, 10, 150);
        stroke(#ffffff, a);
        //strokeWeight(c);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
        stroke(#ffffff, a/10);
        rectMode(CENTER);
        rect(loc.x, loc.y, 2, 2);
        colorMode(RGB);
      }
    }
    //println(countC);
  }
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(255, a);
    ellipse(loc.x, loc.y, sz*a, sz);
  }
}
