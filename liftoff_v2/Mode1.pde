float targetXX, targetYY;
float targetXXX, targetYYY;

void mode1() {
  colorMode(HSB, 255);
  pushMatrix();
  textSize(50);
  modeFrameCount[1]++;
  camera(width/2.0, 
    height/2.0, 
    (height/2.0) / tan(PI*30.0 / 180.0), 
    width/2.0, height/2.0, 0, 
    0, 1, 0);
  blendMode(ADD);
  imageMode(CORNER);
  if (currentBeat>=48 && CN[1][0]>1) {
    if (frameCount%10==0)background(0);
  } else {
    background(0);
  }

  translate(0, screenAdjust);
  strokeWeight(4);
  targetXX += (targetXXX-targetXX)*0.2;
  targetYY += (targetYYY-targetYY)*0.2;
  //  for (int x=0; x<width; x++) {
  //    for (int y=0; y<height; y++) {
  //      float col = map(dist(targetXX, targetYY, x, y), 0, width/2, 255, 0);

  //      noStroke();
  //      if (col < 100) {
  //        set(x, y, color(0, col));
  //      }
  //      // fill(0,col);
  //      // ellipse(x,y,1,1);

  //      //   // set(x, y, color(red(cc), green(cc), blue(cc)));
  //    }
  //  }

  if (SG[1][8]==true) {
    phase1ImageFlag = floor(random(7));
    SG[1][8] = false;
  }
  if ( CN[1][0]>=3) {
    for (int x=floor(targetXX)-400; x<=floor(targetXX)+400; x+=2) {
      for (int y=floor(targetYY)-400; y<=floor(targetYY)+400; y+=2) {

        if (targetXX <= 0 || targetYY <= 0 || targetXX >= width-1 || targetYY >= height-1)continue;

        int col = floor(map(abs(dist(targetXX, targetYY, x, y)), 0, 400, 255, 0));
        if (col < 0) col = 0;
        color tempC = bluePrint[phase1ImageFlag].get(
          floor(map(x, 0, width, 0, bluePrint[phase1ImageFlag].width)), 
          floor(map(y, 0, height, 0, bluePrint[phase1ImageFlag].height))
          );

        color K = color(hue(tempC), saturation(tempC), col); //brightness(tempC));
        //stroke(K);
        set(x, y, color(red(tempC), green(tempC), blue(tempC), col));
        //point(x,y);
        //set(x, y+screenAdjust, K);
      }
    }
  } 
  for (int x=0; x<=width; x+=30) {
    for (int y=0; y<=height; y+=30) {
      float flag = modeFrameCount[1]/30;
      if (flag >= 150)flag = 150;
      float col = map(abs(dist(targetXX, targetYY, x, y)), 0, width/3, 200, 0);
      //println(col);
      if (x%150==0&&y%150==0) {
        for (int i=-5; i<=5; i++) {
          if (CN[1][0] == 2) {
            //stroke(color(col+50, 0, 0));
            //point(x, y+i);
            //stroke(color(col));
            //point(x+i, y);
            set(x, y+i, color(col+50, 0, 0));
            set(x+i, y, color(col));
          } else {
            //stroke(color(col+50));
            //point(x, y+i);
            //stroke(color(col));
            //point(x+i, y);
            set(x, y+i, color(col+50));
            set(x+i, y, color(col));
          }
        }
      } else {
        //stroke(color(col));
        //point(x, y);
        set(x, y, color(col));
      }
    }
  }

  textAlign(CORNER);
  textSize(20);
  stroke(46, 210, 255);
  stroke(255);
  //if (frameCount%5==0)strokeWeight(2);
  //else strokeWeight(1);
  text(targetXX, targetXX+255*sin(radians(frameCount)), targetYY );
  text(targetYY, targetXX, targetYY+255*sin(radians(frameCount)));
  line(targetXX, 0, targetXX, height);
  line(0, targetYY, width, targetYY);
  //  ellipse(xx, yy, 100, 100);
  //if (frameCount%2==0 && (frameCount/100)%2==0)


  fill(255);
  textAlign(CENTER);
  if ( (frameCount/100)%2==0) {
    for (int x=0; x<width; x+=50) {
      text(x, x, 20);
    }
  }
  textAlign(CORNER);
  if ((frameCount/100)%2==1) {
    for (int y=0; y<height; y+=50) {
      text(y, 20, y);
    }
  }

  //camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);

  //if (currentBeat%8==0) {

  //}
  if (SG[1][0] == true) {

    targetXXX = random(100, width-100);
    targetYYY = random(100, height-100);

    SG[1][0] = false;
  }
  if (SG[1][1] == true) {

    if (currentBeat>=48) {
    } else {
      noStroke();
      fill(255, 200);
      rectMode(CORNER);
      float whiteWid = width/15;
      float ran =floor(random(whiteWid));
      rect(ran*15, 0, whiteWid, height);
      SG[1][0] = false;
      rectMode(CENTER);
    }
  }
  if (SG[1][2] == true) {
    SG[1][2] = false;
  }
  if (SG[1][3] == true) {    
    line(0, height/2 + height/2*sin(radians(float(frameCount)/1.7)), targetXX, targetYY);
    line(width/2 + width/2*sin(radians(frameCount)), 0, targetXX, targetYY);

    SG[1][3] = false;
  }
  if (SG[1][4] == true) {
    SG[1][4] = false;
  }
  if (SG[1][5] == true) {

    for (int s=0; s<30; s++) {
      int x1 = floor(random(width));

      int y1 = floor(random(height));

      int x2 = x1 + floor(random(-80, 80));
      int y2 = y1 + floor(random(0));

      int w = width;
      int h = round(random(10, 20));
      if (random(10)>5) {
        int tempX = x1;//floor(map(x1, 0, width, 0, width));
        int tempY = y1;//floor(map(y1, 0, height, 0, height));
        set(x2, y2+screenAdjust, get(tempX, tempY, w, h));
      } else
        set(x2, y2+screenAdjust, get(x1, y1, w/2, h));
    }

    SG[1][5] = false;
  }

  if (SG[1][7] == true) {

    fx.render()
      .sobel()
      //.bloom(0.1, 20, 30)
      //.blur(10, 0.5)
      //.toon()
      .brightPass(0.1)
      .blur(20, 30)
      .compose();

    SG[1][7] =false;
  } else {
  }

  popMatrix();
}
