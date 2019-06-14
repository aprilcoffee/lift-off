
boolean triggerTransGlitch = false;
int tempShowA = 0;
int tempShowB = 0;
void mode4() {
  if (CN[4][0]<=2)textureOn=false;


  if (frameCount%1800==0 && CN[4][0]==1)  geometryInit();
  if (frameCount%300==0 && CN[4][0]==2) geometryInit();

  blendMode(BLEND);
  if (abs(src_cor[0] - src_cor_tar[0]) > 120) {
    triggerTransGlitch = true;
  } else {
    triggerTransGlitch = false;
  }

  if (triggerTransGlitch == true) {
    if (random(5)>4) {
      background(0);
    }
  } else background(0);

  //randomSeed(_print);
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
  orbitTextureDraw(orbitTexture);

  //P.background(0);

  pushMatrix();

  //P.translate(0, screenAdjust);
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
  if (explosion==true) {
    for (int i=0; i<total; i++) {
      float lat = map(i, 0, total, -HALF_PI, HALF_PI);
      float r2 = 1;
      for (int j=0; j<total; j++) {
        // lat -Pi/2 ~ Pi/2
        // lon -PI ~ PI
        float lon = map(j, 0, total, -PI, PI);
        float r1 = 1;
        Geometry G = geometry.get(i*(total+1) + j);
        G.exploded(r1, r2, i, j);
      }
    }
  } else {
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
      float temp_newR = geometryR + random(1200, 2500);
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
      SG[4][6] = false;
    } else if (SG[4][0]) {


      flag = floor(random(3));
      newLonMinHalf = (int)random(total);  
      int tempLonMax = floor(random(15, 45));

      if (CN[4][0]==4) {
        tempLonMax = floor(random(30, 45));
        newLonMinHalf = (int)random(total/2);
      }
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
      int tempLatMax= floor(random(15, 45));
      if (CN[4][0]==4) {
        tempLonMax = floor(random(30, 45));
        newLonMinHalf = (int)random(total/2);
      }

      newLatMaxHalf = newLatMinHalf + tempLatMax;    
      if (newLatMaxHalf > total)newLatMaxHalf=total-1;
      if (newLatMaxHalf < 0)newLatMaxHalf=0;

      if (newLatMinHalf > newLatMaxHalf) {
        int temp = newLatMinHalf;
        newLatMinHalf = newLatMaxHalf;
        newLatMaxHalf = temp;
      }

      //println(_print + "\t" + newLatMinHalf + "\t" + newLatMaxHalf);
      //showHalfTrigger=false;
      // println("hi");
      SG[4][0] = false;
    }
  }


  if (CN[4][0]>=2 && SG[4][17]==true) {
    tempShowA = floor(random(5));
    tempShowB = floor(random(5));
    if (tempShowB==tempShowA)tempShowB = floor(random(5));
    SG[4][17]=false;
  }



  /////////////SHOWing;

  for (int scr_num=0; scr_num<5; scr_num++) {
    boolean tmpFlag = false;
    if (CN[4][0]==2) {
      if (scr_num == tempShowA || scr_num==tempShowB) {
        tmpFlag = true;
      }
      if (tmpFlag == false) {
        continue;
      }
    } else if (CN[4][0]==3) {
      if (scr_num == tempShowA)continue;
    } else if (CN[4][0] == 4) {
      if (scr_num == tempShowA)continue;
    }

    phase3moveA= 89*sin(radians(frameCount*2.173));
    phase3moveT=(90 * scr_num)+89*sin(radians(frameCount*0.489));
    // lights();
    float camR = 1000;
    float camX = camR * sin(radians(phase3moveA)*cos(radians(phase3moveT)));
    float camY = camR * sin(radians(phase3moveT));
    float camZ = camR * cos(radians(phase3moveA)*cos(radians(phase3moveT)));
    scr[scr_num].beginDraw();
    //scr[scr_num].background(0);
    scr[scr_num].camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
    if (phase==34 ) {
      scr[scr_num].blendMode(ADD);
      scr[scr_num].background(0);
    } else if (SG[4][10]) {
      scr[scr_num].blendMode(BLEND);
    } else {
      scr[scr_num].blendMode(BLEND);
      scr[scr_num].background(0);
    }

    if (CN[4][0]==2 || CN[4][0]==3) {
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
            flag, //shaba mode
            scr[scr_num]
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
            flag, //shaba mode
            scr[scr_num]
            );
        }
      }
    }

    //blackHole();
    float flag;



    if (SG[4][10]==true) {
      for (int s=0; s<10; s++) {
        int x1 = floor(random(scr[scr_num].width));
        ;
        int y1 = floor(random(scr[scr_num].height));

        int x2 = x1 + floor(random(-20, 20));
        int y2 = y1 + floor(random(-50, 50));

        int w = round(random(10, 20));
        int h = scr[scr_num].height;
        if (random(10)>5) {
          int tempX = x1;//floor(map(x1, 0, width, 0, width));
          int tempY = y1;//floor(map(y1, 0, height, 0, height));
          scr[scr_num].copy(x2, y2, w, h, tempX, tempY, w, h);
          //print.set(x2, y2+screenAdjust, get(tempX, tempY, w, h));
        } else {
          scr[scr_num].copy(x2, y2, w, h, x1, y1, w/2, h);
          //print.set(x2, y2+screenAdjust, get(x1, y1, w/2, h));
        }
      }
    }

    scr[scr_num].colorMode(HSB, 255);
    scr[scr_num].blendMode(ADD);
    scr[scr_num].camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    scr[scr_num].imageMode(CORNER);
    scr[scr_num].hint(DISABLE_DEPTH_TEST);
    //rotate(radians(frameCount));
    scr[scr_num].translate(0, screenAdjust);
    scr[scr_num].image(starField, 0, 0, width, height);

    scr[scr_num].endDraw();
    imageMode(CORNER);
    //fixed = frameCount%newHeight;

    image(scr[scr_num], src_cor[scr_num], 0, 960, 960);
    src_cor[scr_num] += (src_cor_tar[scr_num]- src_cor[scr_num])*0.1;


    //fixed += (fixedTarget - fixed)*0.1;
  }


  //if (src_cor_tar[scr_num] == 3840) {
  //  src_cor[scr_num]=-960;
  //  src_cor_tar[scr_num]=-960;
  //}

  //float temp = (scr_num*960 + fixed);
  //if (temp >= width)temp -= (width+960);

  if (SG[4][15]) {
    for (int s=0; s<5; s++) {
      src_cor_tar[s]+=newHeight;
      if (src_cor_tar[s] > 3840) {
        src_cor_tar[s] = 0;
        src_cor[s] = -960;
      }
    }
    SG[4][15]=false;
  }

  if (random(3)>1) {
    SG[4][10]=false;
  }
  popMatrix();


  if (triggerTransGlitch) {
    for (int s=0; s<40; s++) {
      int x1 = floor(random(width));
      int y1 = floor(random(newHeight));

      int x2 = x1 + floor(random(-50, 50));
      int y2 = y1 + floor(random(-10, 10));

      int w = width;
      int h = round(random(5, 7));

      copy(x2, y2, w, h, x1, y1, w/2, h);
    }
  }



  blendMode(ADD);
  if (textureOn) {
    float flag = random(3);
    if (SG[4][18]) {
      fx.render()
        .sobel()
        //.bloom(0.1, 20, 30)
        //.blur(10, 0.5)
        //.toon()
        .brightPass(0.1)
        //.blur(20, 1)
        .compose();
      SG[4][18] = false;
    } else if (flag >=1.8) {
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
    float flag = random(2);
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


  //image(P, _print*960, 960, 960, 960);
}
