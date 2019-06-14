void mode3() { 


  pushMatrix();
  colorMode(HSB);
  
  fullScr.beginDraw();

  //fullScr.colorMode(RGB, 255);
  modeFrameCount[2]++;
  if (phase == 12) {
  } else {
    fullScr.background(0);
  }
  fullScr.camera(width/2.0 + camShakeX, 
    newHeight/2.0 + camShakeY, 
    (newHeight/2.0) / tan(PI*30.0 / 180.0)+camShakeZ, 
    width/2.0, newHeight/2.0, 0, 
    0, 1, 0);
  //previousWater[(int)random(200)][(int)random(200)] = 255;
  fullScr.translate(width/2, newHeight/2);
  drawWaterRipple();
  fullScr.blendMode(ADD);
  //fullScr.translate(0, screenAdjust);

  //CornerCall
  if (SG[2][9] ==true) {
    targetingCenter=true;
  }

  //waterTrigger
  if (SG[2][5]==true) {
    //float targetX=map(targetSystem.get(0).x, -width/2, width/2, 0, 640);
    //float targetY=map(targetSystem.get(1).y, -newHeight/2-5, newHeight/2+5, 0, 480);
    //previousWater[(int)targetX][(int)targetY] = waterCount;
    //waterCount += 3;
    //if (waterCount>255)waterCount=255;
    //SG[2][5]=false;
    //targetCount++;
  }

  fullScr.imageMode(CENTER);
  fullScr.image(waterRipple, 0, 0, width+10, newHeight+10);
  //spaceImageGraphic.clear();
  for (int s=0; s<targetSystem.size(); s++) {
    targetSystem.get(s).update();
    targetSystem.get(s).showBall(fullScr);
  }

  fullScr.rectMode(CENTER);
  fullScr.stroke(255, 100);
  fullScr.strokeWeight(0.5);
  fullScr.noFill();
  for (int s=0; s<spaceImages.size(); s++) {
    spaceImages.get(s).update();
    spaceImages.get(s).showImage(fullScr);

    if (spaceImages.get(s).imageSizeY<12) {
      spaceImages.remove(s);
    }
  }

  fullScr.endDraw();
  image(fullScr, 0, 0, width, newHeight);

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
        spaceImages.add(new SpaceImages(1800+random(-20, 20), 
          targetSystem.get(0).y, 
          dir, targetSystem.get(0).x, 0));
      } else if (CN[2][0]==1) {
        spaceImages.add(new SpaceImages(1800+random(-20, 20), 
          targetSystem.get(0).y, 
          dir, targetSystem.get(0).x, 1));
      } else if (CN[2][0]==2) {
        spaceImages.add(new SpaceImages(1800+random(-20, 20), 
          targetSystem.get(0).y, 
          dir, targetSystem.get(0).x, 2));
      }
      showImageCounterAfterSpin ++;
    } else { 
      if (CN[2][0]==0) {
        spaceImages.add(new SpaceImages(1800+random(-20, 20), 
          random(-newHeight/2+100, newHeight/2-100), 
          dir, targetSystem.get(0).x, 0));
      } else if (CN[2][0]==1) {
        spaceImages.add(new SpaceImages(1800+random(-20, 20), 
          random(-newHeight/2+100, newHeight/2-100), 
          dir, targetSystem.get(0).x, 1));
      } else if (CN[2][0]==2) {
        spaceImages.add(new SpaceImages(1800+random(-20, 20), 
          random(-newHeight/2+100, newHeight/2-100), 
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
  //ShowobservationStar();

  popMatrix();
  noStroke();
}
