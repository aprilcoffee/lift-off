
void mode2(int sphereMode) {
  //if (random(5)>3)
  if (transiting==false && transition==2) {
    background(0);
  }
  pushMatrix();
  colorMode(HSB, 255);
  blendMode(BLEND);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  if (addStarTrigger == true) {
    starTriggerCount++;
    if (starTriggerCount > 1000)starTriggerCount=1000;
    for (int s=0; s<(starTriggerCount/100) + 1; s++) {
      stars.add(new Star(10, phase2Counter*0.0001));
    }
    addStarTrigger=false;
  }
  starField.beginDraw();
  //if (random(5)>3) 
  if (transition2to3Dark>50) {
  } else {
    starField.background(0, 0);
  }
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
  endShape(CLOSE);

  changSuperShape();
  popMatrix();
  //image(orbitTexture,width/2,height/2,width,height);
}
