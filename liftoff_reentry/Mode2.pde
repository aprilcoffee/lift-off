
void mode2() {
  int tempWidth = 1920;


  if (phase==12) {
  } else {
    background(0);
  }
  blendMode(ADD);

  imageMode(CORNER);
  modeFrameCount[3]++;
  pushMatrix();

  /*  camera(width/2.0 + camShakeX, 
   height/2.0 + camShakeY, 
   (height/2.0) / tan(PI*30.0 / 180.0)+camShakeZ, 
   width/2.0, height/2.0, 0, 
   0, 1, 0);*/

  //translate(0, screenAdjust);
  if (SG[3][0]==true //&& 
    //abs(camShakeXX-camShakeX)<10 &&
    //abs(camShakeYY-camShakeY)<10 &&
    //abs(camShakeZZ-camShakeZ)<10
    ) 
  {
    camShakeXX = random(-200, 200);
    camShakeYY = random(-200, 200);
    camShakeZZ = random(-500, 500);
    //camShakeZZ = random(-(height/2.0) / tan(PI*30.0 / 180.0)
    //, (height/2.0) / tan(PI*30.0 / 180.0));
    // camShakeZZ -= 500;

    SG[3][0] = false;
  }
  camShakeX += (camShakeXX-camShakeX)*0.25;
  camShakeY += (camShakeYY-camShakeY)*0.25;
  camShakeZ += (camShakeZZ-camShakeZ)*0.25;


  if (SG[3][1]==true) {
    for (int s=0; s<12; s++) {
      constellation[s] = floor(random(particle.size()));
    }
    SG[3][1]=false;
  }


  for (int scr_num = 0; scr_num<2; scr_num++) {
    lscr[scr_num].beginDraw();
    lscr[scr_num].background(0);
    lscr[scr_num].strokeWeight(3);
    lscr[scr_num].blendMode(ADD);
    lscr[scr_num].textSize(20);
    lscr[scr_num].colorMode(RGB);
    lscr[scr_num].camera(tempWidth/2.0 + camShakeX, 
      newHeight/2.0 + camShakeY, 
      (newHeight/2.0) / tan(PI*30.0 / 180.0)+camShakeZ, 
      tempWidth/2.0, newHeight/2.0, 0, 
      0, 1, 0);


    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      P.update();
      if (random(10)>8) {
        lscr[scr_num].strokeWeight(random(3));
      } else {      
        lscr[scr_num].strokeWeight(2);
      }
      P.show(lscr[scr_num]);
    }
    for (int s=0; s<CN[8][0]; s++) {
      Particle P = particle.get(constellation[s]);
      Particle PP = particle.get(constellation[s+1]);
      lscr[scr_num].stroke(255);
      lscr[scr_num].strokeWeight(3);
      lscr[scr_num].line(P.pos.x, P.pos.y, P.pos.z, 
        PP.pos.x, PP.pos.y, PP.pos.z
        );
      //vertex(P.pos.x, P.pos.y, P.pos.z);
    }
    //lscr[scr_num].stroke(135, 0);
    //lscr[scr_num].beginShape(TRIANGLE_STRIP);
    //for (int s=0; s<particle.size(); s++) {
    //  Particle P = particle.get(s);
    //  lscr[scr_num].vertex(P.pos.x, P.pos.y, P.pos.z);
    //}
    //lscr[scr_num].endShape();

    lscr[scr_num].endDraw();
    image(lscr[scr_num], scr_num*1920, 0, 1920, newHeight);
  }
  if (SG[3][2]==true) {
    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      P.returnToGrid();
      //P.randomlize();
      //P.randomSphere();
    }
    SG[3][2]=false;
  }

  if (SG[3][3]==true) {
    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      //P.returnToGrid();
      P.randomlize();
      //P.randomSphere();
    }
    SG[3][3]=false;
  }
  if (SG[3][4]==true) {
    for (int s=0; s<particle.size(); s++) {
      Particle P = particle.get(s);
      //P.returnToGrid();
      //P.randomlize();
      P.randomSphere();
    }
    SG[3][4]=false;
  }


  if (CN[3][0] >= 2 && SG[3][10]) {

    int tilesX = 14;
    int tilesY = 14;

    int tileW = int(width/tilesX);
    int tileH = int(height/tilesY);

    for (int y = 0; y < tilesY; y++) {
      for (int x = 0; x < tilesX; x++) {

        // WARP
        int wave = int(sin(frameCount * 0.05 + ( x * y ) * 0.07) * 100);

        // SOURCE
        int sx = x*tileW + wave;
        int sy = y*tileH;
        int sw = tileW;
        int sh = tileH;
        // DESTINATION
        int dx = x*tileW;
        int dy = y*tileH;
        int dw = tileW;
        int dh = tileH;
        copy(sx, sy, sw, sh, dx, dy, dw, dh);
      }
    }
  }
  if (random(10)>3) {
    fx.render()
      .sobel()
      //.bloom(0.1, 20, 30)
      //.blur(10, 0.5)
      //.toon()
      .brightPass(0.1)
      .blur(20, 30)
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
  popMatrix();
}
