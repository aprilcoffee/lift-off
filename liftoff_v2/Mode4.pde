void mode4() {
  pushMatrix();
  if (phase==34 ) {
    blendMode(ADD);
  } else if (SG[4][10]) {
    blendMode(BLEND);
  } else {
    blendMode(BLEND);
    background(0);
  }
  translate(0,screenAdjust);
  modeFrameCount[4]++;
  if (SG[4][4]) {
    changeTexture = true;
    SG[4][4]=false;
  }
  if (SG[4][5]) {
    textureOn = true;
    SG[4][5]=false;
  }
  if (SG[4][3]) {
    showAllgeo = true; 
    SG[4][3] = false;
  }
  if (SG[4][9]) {
    showAllgeo = false; 
    SG[4][9] = false;
  }
  if (SG[4][11]) {
    textureOn = false;
    SG[4][11]=false;
  }

  orbitTextureDraw(orbitTexture);
  //drawTerrainInGraphics(orbitTexture);
  resetSphereLocation();

  if (SG[4][1] == true) {
    starTriggerCount++;
    if (starTriggerCount > 1550)starTriggerCount=1550;
    for (int s=0; s<(starTriggerCount/100) + 1; s++) {
      stars.add(new Star(10, starTriggerCount*0.001));
    }
    SG[4][1]=false;
  }


  starField.beginDraw();
  //if (random(5)>3) 
  starField.background(0, 0);
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


  phase3moveA=89*sin(radians(frameCount*2.173));
  phase3moveT=89*sin(radians(frameCount*0.489));
  // lights();
  float camR = 1500;
  float camX = camR * sin(radians(phase3moveA)*cos(radians(phase3moveT)));
  float camY = camR * sin(radians(phase3moveT));
  float camZ = camR * cos(radians(phase3moveA)*cos(radians(phase3moveT)));
  camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);

  if (SG[4][6]==true) {
    //resetSphereLocation();
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
    float temp_newR = geometryR + random(3500, 6000);
    for (int i=newLatMin; i<newLatMax; i++) {
      float lat = map(i, 0, total, -HALF_PI, HALF_PI);
      float r2 = 1;
      for (int j=newLonMin; j<newLonMax; j++) {
        // lat -Pi/2 ~ Pi/2
        // lon -PI ~ PI
        float lon = map(j, 0, total, -PI, PI);
        float r1 = 1;

        Geometry G = geometry.get(i*(total+1) + j);
        G.setNewLocation(r1, r2, i, j, temp_newR+random(-20, 20));
      }
    }
    println("Hello");
    SG[4][6] = false;
  } else if (SG[4][0]) {
    flag = floor(random(3));
    newLonMinHalf = (int)random(total);  
    int tempLonMax= floor(random(7, 35));
    //if (random(2)<1) {
    //  tempMax = int(phase2Counter*0.01);
    //} else tempMax = -int(phase2Counter*0.01);
    newLonMaxHalf = newLonMinHalf + tempLonMax;    
    if (newLonMaxHalf > total)newLonMaxHalf=total-1;
    if (newLonMaxHalf < 0)newLonMaxHalf=0;
    //if (phase2Counter*0.001 < 3) {
    //  shabaMode2 = int(random(phase2Counter*0.001));
    //} else {
    //  shabaMode2 = int(random(3));
    //}
    if (newLonMinHalf > newLonMaxHalf) {
      int temp = newLonMinHalf;
      newLonMinHalf = newLonMaxHalf;
      newLonMaxHalf = temp;
    }

    newLatMinHalf = (int)random(total);    
    //newLatMaxHalf = (int)random(total);
    int tempLatMax= floor(random(7, 35));
    newLatMaxHalf = newLatMinHalf + tempLatMax;    
    if (newLatMaxHalf > total)newLatMaxHalf=total-1;
    if (newLatMaxHalf < 0)newLatMaxHalf=0;

    if (newLatMinHalf > newLatMaxHalf) {
      int temp = newLatMinHalf;
      newLatMinHalf = newLatMaxHalf;
      newLatMaxHalf = temp;
    }
    //showHalfTrigger=false;

    SG[4][0] = false;
  }



  /////////////SHOWing;

  if (showAllgeo) {
    for (int i=0; i<total; i++) {
      for (int j=0; j<total; j++) {
        //for (int i=0; i<total; i++) {
        //  for (int j=0; j<total; j++) {
        Geometry G = geometry.get(i*(total+1) + j);
        Geometry Gup = geometry.get((i+1)*(total+1) + j);
        Geometry Gright = geometry.get((i)*(total+1) + j+1);
        Geometry Gnext = geometry.get((i+1)*(total+1) + j+1);
        //        println(i, j, G.ii, G.jj);
        //if (i!=G.ii || j!=G.jj)println(i, j);
        //if((i+1)!=Gnext.ii || (j+1)!=Gnext.jj)println(i,j);
        G.update();
        G.show(
          Gup.globeTexture, 
          Gright.globeTexture, 
          Gnext.globeTexture, 
          flag//shaba mode
          );
      }
    }
  } else {
    for (int i=newLatMinHalf; i<newLatMaxHalf; i++) {
      for (int j=newLonMinHalf; j<newLonMaxHalf; j++) {
        //for (int i=0; i<total; i++) {
        //  for (int j=0; j<total; j++) {
        Geometry G = geometry.get(i*(total+1) + j);
        Geometry Gup = geometry.get((i+1)*(total+1) + j);
        Geometry Gright = geometry.get((i)*(total+1) + j+1);
        Geometry Gnext = geometry.get((i+1)*(total+1) + j+1);
        //        println(i, j, G.ii, G.jj);
        //if (i!=G.ii || j!=G.jj)println(i, j);
        //if((i+1)!=Gnext.ii || (j+1)!=Gnext.jj)println(i,j);
        G.update();
        G.show(
          Gup.globeTexture, 
          Gright.globeTexture, 
          Gnext.globeTexture, 
          flag//shaba mode
          );
      }
    }
  }
  imageMode(CORNER);
  //blackHole();
  float flag;
  if (textureOn) {
    flag = random(3);
    if (flag >=1.8) {
    } else if (flag<= 1.8 && flag > 0.9) {
      fx.render()
        .sobel()
        //.bloom(0.1, 20, 30)
        //.blur(10, 0.5)
        //.toon()
        .brightPass(0.1)
        //.blur(20, 1)
        .compose();
    } else {
      fx.render()
        //.sobel()
        //.bloom(0.2, 20, 30)
        //.toon()
        //.brightPass(1)
        .blur(20, 30)
        //.blur(1, 0.001)
        .compose();
    }
  } else { 
    flag = random(2);
    if (flag> 1) {
      fx.render()
        .sobel()
        //.bloom(0.1, 20, 30)
        //.blur(10, 0.5)
        //.toon()
        .brightPass(0.1)
        //.blur(20, 1)
        .compose();
    } else {
      fx.render()
        //.sobel()
        //.bloom(0.2, 20, 30)
        //.toon()
        //.brightPass(1)
        .blur(20, 30)
        //.blur(1, 0.001)
        .compose();
    }
  }


  if (SG[4][10]==true) {
    for (int s=0; s<60; s++) {
      int x1 = floor(random(width));
      ;
      int y1 = floor(random(height));

      int x2 = x1 + floor(random(-80, 80));
      int y2 = y1 + floor(random(-80, 80));

      int w = round(random(10, 20));
      int h = height;
      if (random(10)>5) {
        int tempX = x1;//floor(map(x1, 0, width, 0, width));
        int tempY = y1;//floor(map(y1, 0, height, 0, height));
        set(x2, y2+screenAdjust, get(tempX, tempY, w, h));
      } else
        set(x2, y2+screenAdjust, get(x1, y1, w/2, h));
    }
    if (random(3)>1) {
      SG[4][10]=false;
    }
  }
  popMatrix();

  colorMode(HSB, 255);
  blendMode(ADD);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  imageMode(CORNER);
  hint(DISABLE_DEPTH_TEST);
  //rotate(radians(frameCount));
  translate(0,screenAdjust);
  image(starField, 0, 0, width, height);
}
