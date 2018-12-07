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
    if (observationCount>1550)observationCount = 1550;
    observationCount +=2;
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
  observateStarEndPointEasing += (observateStarEndPoint-observateStarEndPointEasing)*0.2;

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
  float angle;
  float ori_v;
  float v;
  int dir;
  int targetMode;
  float easing = 0.1;
  TargetSystem(float erX, float erY, float ea, int edir) {
    rX = erX;
    rY = erY;
    angle = ea;
    dir = edir;
    v = random(0.7, 2);
    ori_v = v;
    //targetMode = etargetMode;
  }
  void resetVel() {
    v = 0;
  }
  void update() {
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
  void showBall() {
    if (targetSystemShow == true) {
      if (dir>0) {
        for (int s=-50; s<=50; s+=4) {
          stroke(255, 0, 0, 150*sin(radians(map(s, -20, 20, 0, 180))) * map(transition1to2Dark, 0, 255, 1, 0));
          line(x-s, -height, x-s, height);
        }
      } else {
        for (int s=-50; s<=50; s+=4) {
          stroke(255, 0, 0, 150*sin(radians(map(s, -20, 20, 0, 180))) * map(transition1to2Dark, 0, 255, 1, 0));
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
    } else if (targetSystemLineA==true) {
      if (dir>0) {
        for (int s=-50; s<=50; s+=4) {
          stroke(255, 255, 255, 150*sin(radians(map(s, -100, 100, 0, 180))));
          line(x-s, -height, x-s, height);
        }
      }
    } else if (targetSystemLineB==true) {
      if (dir==-1)
        for (int s=-50; s<=50; s+=4) {
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

void glitchReset() {
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
  int imageFlag = int(random(photoLength));
  boolean dead = false;
  float textX;
  float textY;
  float photoXOri;
  float photoYOri;
  int dir;
  float spin = 0;
  float spinAdjust;
  float spinRadians;
  float textEasing = 0.3; 
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
    if (photoSpin == true) {
      spin = 90 + random(2*showImageCounterAfterSpin);
      spinAdjust = random(0.1, 0.5);
      spinAdjustOri = spinAdjust;
    } else {
      spin = 90;
      spinAdjust = 0;
      spinAdjustOri = spinAdjust;
    }
  }
  void update() {
    imageSizeY = ori_imageSizeY*sin(radians(angle));
    if (dead) { 
      imageSizeX = ori_imageSizeX + tan(radians(angle+45));
      angle +=5;
    }
    photoX = spinRadians*sin(radians(spin));
    photoZ = spinRadians*cos(radians(spin));
    if (spinMoveFaster==true) {
      spinAdjust *= 6;
    } else {
      spinAdjust += (spinAdjustOri-spinAdjust)*0.3;
      spin += spinAdjust;
    }
    photoXOri += (photoX - photoXOri)*textEasing;
    photoYOri += (photoY - photoYOri)*textEasing;
  }
  void kill() {
    dead = true;
  }
  void showImage() {
    noFill();
    pushMatrix();
    translate(photoX, photoY, photoZ);

    if (phase1CornerCall==true || photoSpin==true) {
      if (imageMode == 1) {
        image(spaceImgBW[imageFlag], 0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        image(spaceImg[imageFlag], 0, 0, imageSizeX, imageSizeY);
      }
    } else if (glitchTrigger==true) {
      if (imageMode == 1) {
        image(imageGlitch(spaceImgBW[imageFlag]), 0, 0, imageSizeX, imageSizeY);
      } else if (imageMode == 2) {
        image(imageGlitch(spaceImg[imageFlag]), 0, 0, imageSizeX, imageSizeY);
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
    if (phase1CornerCall==true) {
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
