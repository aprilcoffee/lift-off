float targetXX, targetYY;
float targetXXX, targetYYY;

void mode1() {
  pushMatrix();
  modeFrameCount[1]++;
  camera(width/2.0, 
    height/2.0, 
    (height/2.0) / tan(PI*30.0 / 180.0), 
    width/2.0, height/2.0, 0, 
    0, 1, 0);
  blendMode(ADD);
  if (currentBeat>=48 && CN[2][0]>=1) {
  } else {
    background(0);
  }
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

  for (int x=0; x<=width; x+=30) {
    for (int y=0; y<=height; y+=30) {
      float col = map(dist(targetXX, targetYY, x, y), 0, width/3, 200, 0);
      if (x%150==0&&y%150==0) {
        for (int i=-5; i<=5; i++) {          
          set(x, y+i, color(col+50));
          set(x+i, y, color(col));
        }
      } else {
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

  if (currentBeat%8==0) {
    targetXXX = random(100, width-100);
    targetYYY = random(100, height-100);
  }
  if (SG[1][0] == true) {



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
      ;
      int y1 = floor(random(height));

      int x2 = x1 + floor(random(-80, 80));
      int y2 = y1 + floor(random(0));

      int w = width;
      int h = round(random(10, 20));
      if (random(10)>5) {
        int tempX = x1;//floor(map(x1, 0, width, 0, width));
        int tempY = y1;//floor(map(y1, 0, height, 0, height));
        set(x2, y2, get(tempX, tempY, w, h));
      } else
        set(x2, y2, get(x1, y1, w/2, h));
    }

    SG[1][5] = false;
  }
  popMatrix();
}
