void initPhase() {
  background(0);
  imageMode(CENTER);
  colorMode(RGB, 255);
  blendMode(BLEND);
  pushMatrix();
  float shakeGlitch = map(transition0to1Dark, 0, 255, 5, 150);

  if (initVideoTrigger==true) {
    initMovie.play();
    initMovie.noLoop();
    initVideoTrigger = false;
  }
  if (initVideoPlaying==true) {
    image(initMovie, width/2, height/2, width, height);
  }
  LTGlogo = loadImage("LTG.png");
  LTGlogo.loadPixels();
  color randomColor = color(random(255), random(255), random(255), 255);

  if (random(100)<(25+shakeGlitch/2)) {
    for (int y=0; y<LTGlogo.height; y++) {
      for (int x=0; x<LTGlogo.width; x++) {
        // get the color for the pixel at coordinates x/y
        color pixelColor = LTGlogo.pixels[y + x * LTGlogo.height];
        if (pixelColor == color(255)) {
          // percentage to mix
          float mixPercentage = .5 + random(50)/50;
          // mix colors by random percentage of new random color
          LTGlogo.pixels[y + x * LTGlogo.height] =  lerpColor(pixelColor, randomColor, mixPercentage);
        }
        if (random(100)<25) {
          randomColor = color(random(255), random(255), random(255), 255);
        }
      }
    }
  }
  LTGlogo.updatePixels();
  for (int s=0; s<100; s++) {
    int x1 = 0;
    int y1 = floor(random(LTGlogo.height));

    int x2 = round(x1 + random(-shakeGlitch, shakeGlitch));
    int y2 = round(y1 + random(-shakeGlitch/3, shakeGlitch/3));

    int w = LTGlogo.width;
    int h = floor(random(10));
    LTGlogo.set(x2, y2, LTGlogo.get(x1, y1, w, h));
  }
  translate(width/2, height/2);
  for (int s=0; s<blobs.size(); s++) {
    blobs.get(s).update();
    blobs.get(s).showMode1();
    blobs.get(s).cons();
  }
  image(LTGlogo, -25, 0, width*0.75, height*0.75);
  popMatrix();
  blendMode(BLEND);
}

//void keyReleased() {
//  targetShot.add(new TargetShot(targetSystem.get(0).x, (targetSystem.get(1).y)));
//  for (int s=0; s<targetSystem.size(); s++) {
//    targetSystem.get(s).resetVel();
//  }
//}
void mode1() { 
  pushMatrix();
  if (true) {
    background(0);
    //previousWater[(int)random(200)][(int)random(200)] = 255;
    drawWaterRipple();

    translate(width/2, height/2);
    // rotateY(radians(10*noise(phase1offX)-5));
    //phase1offX += 0.1;

    blendMode(BLEND);
    if (waterTrigger==true) {
      float targetX=map(targetSystem.get(0).x, -width/2, width/2, 0, 960);
      float targetY=map(targetSystem.get(1).y, -height/2, height/2, 0, 540);
      previousWater[(int)targetX][(int)targetY] = waterCount;
      waterCount +=4;
      if (waterCount>255)waterCount=255;
      waterTrigger=false;
      targetCount++;
    }
    image(waterRipple, 0, 0, width, height);

    //spaceImageGraphic.clear();
    for (int s=0; s<targetSystem.size(); s++) {
      targetSystem.get(s).update();
      targetSystem.get(s).showBall();
    }

    //for (int s=0; s<targetShot.size(); s++) {
    //  targetShot.get(s).update();
    //  targetShot.get(s).show();
    //  if (targetShot.get(s).life < 5)targetShot.remove(s);
    //}
    //println(spaceImages.size());
    for (int s=0; s<spaceImages.size(); s++) {
      spaceImages.get(s).update(); 
      if (photoTriggerImage==false)
        spaceImages.get(s).showWithoutImage(); 
      else
        spaceImages.get(s).showImage(); 
      if (spaceImages.get(s).imageSizeY<10) {
        spaceImages.remove(s);
      }
    }
    if (photoTrigger==true) {
      int dir = 0;
      if (random(2)>1) {
        dir = 1;
      } else {
        dir = 0;
      }
      spaceImages.add(new SpaceImages(500+random(-20, 20), random(-height/2+100, height/2-100), dir, targetSystem.get(0).x));
      photoTrigger = false;
    } 
    if (photoKill==true) {
      for (int s=0; s<spaceImages.size(); s++) {
        spaceImages.get(s).kill();
      }
      photoKill = false;
    }

    // blendMode(ADD);
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
    imageMode(CENTER);
    image(observateStarBackground, 0, 0, width, height);
  } else {
    background(0);
  }
  //  if (random(5)>4)
  //   filter(INVERT);
  /*
  for (int i=0; i<ballCollection.size(); i++) {
   Ball mb = (Ball) ballCollection.get(i);
   mb.run();
   }
   theta += (0.0523/2);
   if (moveStuff==true) {
   createStuff();
   moveStuff=false;
   }
   */
  popMatrix();
}
void mode2(int sphereMode) {
  //if (random(5)>3)
  background(0);

  pushMatrix();
  colorMode(HSB, 255);
  blendMode(BLEND);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  if (addStarTrigger == true) {
    starTriggerCount++;
    if (starTriggerCount > 1000)starTriggerCount=1000;
    for (int s=0; s<(starTriggerCount/100) + 1; s++) {
      stars.add(new Star(10, frameCount*0.0001));
    }
    addStarTrigger=false;
  }

  starField.beginDraw();
  //if (random(5)>3) 
  if (transition2to3Dark>50) {
  } else
    starField.clear();
  starField.translate(starWidth/2, starHeight/2);
  for (int s=0; s<stars.size(); s++) {
    stars.get(s).update();
    if (stars.get(s).pos.z < 1) {
      stars.remove(s);
      continue;
    }
    stars.get(s).show(starField);
  }
  starField.endDraw();
  imageMode(CENTER);
  translate(width/2, height/2);
  //rotate(radians(frameCount));
  image(starField, 0, 0, width, height);
  phase3moveA=89*sin(radians(frameCount*2.173));
  phase3moveT=89*sin(radians(frameCount*0.489));
  // lights();
  float camR = 1500;
  float camX = camR * sin(radians(phase3moveA)*cos(radians(phase3moveT)));
  float camY = camR * sin(radians(phase3moveT));
  float camZ = camR * cos(radians(phase3moveA)*cos(radians(phase3moveT)));
  camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  orbitTextureDraw(orbitTexture);
  //drawTerrainInGraphics(orbitTexture);
  resetSphereLocation();
  if (flyAway==true) {
    for (int s=0; s<20; s++) {
      flyI = (int)random(total);
      flyJ = (int)random(total);
      geometry[flyI][flyJ].flying=true;
      flyAway=false;
    }
  }
  /*
  if (crashSide==true) {
   int newLonMin = (int)random(total);    
   int newLonMax = (int)random(total);    
   
   if (newLonMin > newLonMax) {
   int temp = newLonMin;
   newLonMin = newLonMax;
   newLonMax = temp;
   }
   int newLatMin = (int)random(total);    
   int newLatMax = (int)random(total);
   if (newLatMin > newLatMax) {
   int temp = newLatMin;
   newLatMin = newLatMax;
   newLatMax = temp;
   }
   float temp_newR = random(300, 700);
   for (int i=newLatMin; i<newLatMax; i++) {
   float lat = map(i, 0, total, -HALF_PI, HALF_PI);
   float r2 = superShape(lat, m, n1, n2, n3);
   for (int j=newLonMin; j<newLonMax; j++) {
   // lat -Pi/2 ~ Pi/2
   // lon -PI ~ PI
   float lon = map(j, 0, total, -PI, PI);
   float r1 = superShape(lon, m, n1, n2, n3);
   geometry[i][j].setNewLocation(r1, r2, i, j, temp_newR+random(-20, 20));
   }
   }
   println("Hello");
   crashSide = false;
   }*/
  noStroke();
  if (showHalfTrigger==true) {
    newLonMinHalf = (int)random(total);    
    newLonMaxHalf = (int)random(total);    
    if (frameCount*0.001 < 3) {
      shabaMode2 = int(random(frameCount*0.001));
    } else {
      shabaMode2 = int(random(3));
    }
    if (newLonMinHalf > newLonMaxHalf) {
      int temp = newLonMinHalf;
      newLonMinHalf = newLonMaxHalf;
      newLonMaxHalf = temp;
    }
    newLatMinHalf = (int)random(total);    
    newLatMaxHalf = (int)random(total);
    if (newLatMinHalf > newLatMaxHalf) {
      int temp = newLatMinHalf;
      newLatMinHalf = newLatMaxHalf;
      newLatMaxHalf = temp;
    }
    showHalfTrigger=false;
  }
  if (showAllgeo==true) {
    for (int i=0; i<total; i++) {
      for (int j=0; j<total; j++) {
        //for (int i=0; i<total; i++) {
        //  for (int j=0; j<total; j++) {
        geometry[i][j].update();
        geometry[i][j].show(
          geometry[i+1][j].globeTexture, 
          geometry[i][j+1].globeTexture, 
          geometry[i+1][j+1].globeTexture, 
          shabaMode2
          );
      }
    }
  } else if (showHalf==true) {
    for (int i=newLatMinHalf; i<newLatMaxHalf; i++) {
      for (int j=newLonMinHalf; j<newLonMaxHalf; j++) {
        //for (int i=0; i<total; i++) {
        //  for (int j=0; j<total; j++) {
        geometry[i][j].update();
        geometry[i][j].show(
          geometry[i+1][j].globeTexture, 
          geometry[i][j+1].globeTexture, 
          geometry[i+1][j+1].globeTexture, 
          shabaMode2
          );
      }
    }
  } else {
    for (int i=0; i<total*sin(radians(frameCount)); i++) {
      for (int j=0; j<total; j++) {
        //for (int i=0; i<total; i++) {
        //  for (int j=0; j<total; j++) {
        geometry[i][j].update();
        geometry[i][j].show(
          geometry[i+1][j].globeTexture, 
          geometry[i][j+1].globeTexture, 
          geometry[i+1][j+1].globeTexture, 
          shabaMode2
          );
      }
    }
  }
  changSuperShape();
  popMatrix();
  //image(orbitTexture,width/2,height/2,width,height);
}
void keyReleased() {
}
void mode3() { 
  julia(juliaTexture);
  pushMatrix();
  colorMode(RGB, 255);
  blendMode(SUBTRACT);  
  float movementScale = spectrumScale ;
  float shakeGlitch = map(totalAmp, 0, 100000, 0, 15);
  //if (random(shakeGlitch)<5) {
  background(255);
  //}
  soundCheck();
  stroke(255);
  strokeWeight(1);

  for (int i=0; i<attractorsSize; i++) {
    point(attractors[i].x, attractors[i].y);
  }
  attractors[0].x = width/2+fftLin.getAvg(0)*movementScale*5;
  attractors[0].y = height/2+fftLin.getAvg(3)*movementScale*2;
  attractors[1].x = width/2-fftLin.getAvg(0)*movementScale*5;
  attractors[1].y = height/2-fftLin.getAvg(3)*movementScale*2;

  if (attractors[0].x>width)attractors[0].x = width+random(-30, 30);
  if (attractors[0].y>height)attractors[0].y = height+random(-30, 30);
  if (attractors[1].x<0)attractors[1].x = random(-30, 30);
  if (attractors[1].y<0)attractors[1].y = random(-30, 30);
  //  attractors[1].z = 50*sin(radians(frameCount*2));

  for (int s=0; s< particles.size(); s++) {
    for (int i=0; i<attractorsSize; i++) {
      particles.get(s).attracted(attractors[i], i);
    }
    particles.get(s).update();
    particles.get(s).show();
  }
  //drawTerrain();
  popMatrix();  
  /*
   translate(width/2, height/2);
   for (int s=0; s<blobs.size(); s++) {
   blobs.get(s).update();
   blobs.get(s).show();
   blobs.get(s).cons();
   }
   imageMode(CENTER);ㄜㄠ
   */
  if (juliaShowTrigger) {
    tint(100);
    image(juliaTexture, 0, 0, width, height);
    juliaShowTrigger=false;
    tint(255);
  }
  /*
  if (bobbyTrigger) {
   filter(INVERT);
   }*/
}
void mode4() {
}
