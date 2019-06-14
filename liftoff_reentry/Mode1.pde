float targetXX, targetYY;
float targetXXX, targetYYY;

void mode1() {

  blendMode(ADD);


  background(0);
  colorMode(HSB);
  pushMatrix();
  textSize(50);
  int tempWidth = 1920;

  for (int q=0; q<2; q++) {
    lscr[q].beginDraw();
    lscr[q].colorMode(RGB, 255);

    modeFrameCount[1]++;
    lscr[q].camera(tempWidth/2.0, 
      newHeight/2.0, 
      (newHeight/2.0) / tan(PI*30.0 / 180.0), 
      tempWidth/2.0, newHeight/2.0, 0, 
      0, 1, 0);
    lscr[q].blendMode(ADD);
    lscr[q].imageMode(CORNER);
    if (currentBeat>=48 && CN[1][0]>1) {
      if (frameCount%40==0)lscr[q].background(0);
    } else {
      lscr[q].background(0);
    }

    lscr[q].strokeWeight(3);
    targetXX += (targetXXX-targetXX)*0.04;
    targetYY += (targetYYY-targetYY)*0.04;
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

      if (q==1)
        SG[1][8] = false;
    }
    if ( CN[1][0]>=3 && SG[1][5] != true) {

      int col; 
      color tempC; 
      color K;

      lscr[q].copy(
        bluePrint[phase1ImageFlag], 
        floor(map((targetXX)-275, 0, tempWidth, 0, bluePrint[phase1ImageFlag].width)), 
        floor(map((targetYY)-275, 0, newHeight, 0, bluePrint[phase1ImageFlag].height)), 
        floor(map(525, 0, tempWidth, 0, bluePrint[phase1ImageFlag].width)), 
        floor(map(525, 0, newHeight, 0, bluePrint[phase1ImageFlag].height)), 
        floor(targetXX-275), 
        floor(targetYY-275), 
        525, 525
        );
      /*
      for (int x=floor(targetXX)-275; x<=floor(targetXX)+275; x+=2) {
       if (x<0) {
       x=0;
       continue;
       }
       if (x>=tempWidth-1) {
       break;
       }
       for (int y=floor(targetYY)-275; y<=floor(targetYY)+275; y+=2) {
       
       //if (targetXX <= 0 || targetYY <= 0 || targetXX >= tempWidth-1 || targetYY >= newHeight-1)continue;
       if (y<0)y=0;
       if (y>=newHeight-1 || x>=tempWidth-1)break;
       
       //if (x <= 0 || y <= 0 || x >= tempWidth-1 || y >= newHeight-1)continue;
       
       col = floor(map(abs(dist(targetXX, targetYY, x, y)), 0, 275, 255, 0));
       if (col < 0) {
       //col = 0;
       continue;
       }
       tempC = bluePrint[phase1ImageFlag].get(
       floor(map(x, 0, tempWidth, 0, bluePrint[phase1ImageFlag].width)), 
       floor(map(y, 0, newHeight, 0, bluePrint[phase1ImageFlag].height))
       );
       //lscr[q].colorMode(RGB);
       K = color(hue(tempC), saturation(tempC), col*1); //brightness(tempC));
       //lscr[q].strokeWeight(2);
       //lscr[q].stroke(K);
       //lscr[q].point(x, y, color(red(tempC), green(tempC), blue(tempC), 255));
       //lscr[q].strokeWeight(4);
       //point(x,y);
       lscr[q].set(x, y, K);
       }
       }*/
    } 

    for (int x=0; x<=tempWidth; x+=30) {
      for (int y=0; y<=newHeight; y+=30) {
        float flag = modeFrameCount[1]/30;
        if (flag >= 150)flag = 150;
        float col = map(abs(dist(targetXX, targetYY, x, y)), 0, (newHeight/3) * CN[1][0], 200, 0);
        //println(col);
        lscr[q].colorMode(RGB);
        if (x%150==0&&y%150==0) {
          for (int i=-5; i<=5; i++) {
            if (CN[1][0] >= 2) {
              lscr[q].stroke(color(col+100, 0, 0));
              lscr[q].point(x, y+i);
              lscr[q].stroke(color(col+100, 0, 0));
              lscr[q].point(x+i, y);
              //set(x, y+i, color(col+50, 0, 0));
              //set(x+i, y, color(col));
            } else {
              lscr[q].stroke(color(col+50));
              lscr[q].point(x, y+i);
              lscr[q].stroke(color(col+50));
              lscr[q].point(x+i, y);
              //set(x, y+i, color(col+50));
              //set(x+i, y, color(col));
            }
          }
        } else {
          lscr[q].stroke(color(col));
          lscr[q].point(x, y);
          //point(x, y, color(col));
        }
      }
    }

    lscr[q].textAlign(CORNER);
    lscr[q].textSize(20);
    //lscr[q].stroke(46, 210, 255);
    lscr[q].stroke(255);
    //if (frameCount%5==0)strokeWeight(2);
    //else strokeWeight(1);
    lscr[q].text(targetXX, targetXX+255*sin(radians(frameCount)), targetYY );
    lscr[q].text(targetYY, targetXX, targetYY+255*sin(radians(frameCount)));
    lscr[q].line(targetXX, 0, targetXX, height);
    lscr[q].line(0, targetYY, width, targetYY);
    //  ellipse(xx, yy, 100, 100);
    //if (frameCount%2==0 && (frameCount/100)%2==0)


    if (CN[1][0]>=2) {
      lscr[q].fill(255);
      lscr[q].textAlign(CENTER);
      for (int x=0; x<tempWidth; x+=100) {
        lscr[q].pushMatrix();
        lscr[q].translate(x, 30);
        //lscr[q].scale(1.3);
        lscr[q].text(x, 0, 0);
        lscr[q].popMatrix();
      }

      lscr[q].textAlign(CORNER);
      for (int y=0; y<newHeight; y+=50) {
        lscr[q].pushMatrix();
        lscr[q].translate(0, y);
        //lscr[q].scale(1.3);
        lscr[q].text(y, 0, 0);
        lscr[q].popMatrix();
      }
    } else {

      lscr[q].fill(255);
      lscr[q].textAlign(CENTER);
      if ( (frameCount/100)%2==0) {
        for (int x=0; x<tempWidth; x+=100) {
          lscr[q].pushMatrix();
          lscr[q].translate(x, 30);
          //lscr[q].scale(1.3);
          lscr[q].text(x, 0, 0);
          lscr[q].popMatrix();
        }
      }
      lscr[q].textAlign(CORNER);
      if ((frameCount/100)%2==1) {
        for (int y=0; y<newHeight; y+=50) {
          lscr[q].pushMatrix();
          lscr[q].translate(0, y);
          //lscr[q].scale(1.3);
          lscr[q].text(y, 0, 0);
          lscr[q].popMatrix();
        }
      }
    }

    //camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);

    //if (currentBeat%8==0) {

    //}
    if (SG[1][0] == true) {

      targetXXX = random(30, tempWidth-30);
      targetYYY = random(30, newHeight-30);


      //if (q==1)
      SG[1][0] = false;
    }
    if (SG[1][1] == true) {
      if (currentBeat>=48) {
      } else {
        lscr[q].noStroke();
        lscr[q].fill(255, 200);
        lscr[q].rectMode(CORNER);
        float whiteWid;
        switch(CN[1][0]) {
        case 0:
          whiteWid = tempWidth/10;
          break;
        case 1:
          whiteWid = tempWidth/8;
          break;
        case 2:
          whiteWid = tempWidth/12;
          break;
        case 3:
          whiteWid = tempWidth/18;
          break;
        default:
          whiteWid = tempWidth/20;
          break;
        }
        //float whiteWid = tempWidth/15;
        float ran =floor(random(whiteWid));
        lscr[q].rect(ran*15, 0, whiteWid, newHeight);

        lscr[q].rectMode(CENTER);
      }

      if (q==1)
        SG[1][1] = false;
    }
    if (SG[1][2] == true) {

      if (q==1)
        SG[1][2] = false;
    }
    if (SG[1][3] == true) {    
      lscr[q].stroke(255);
      lscr[q].line(0, newHeight/2 + newHeight/2*sin(radians(float(frameCount)/1.7)), targetXX, targetYY);
      lscr[q].line(tempWidth/2 + tempWidth/2*sin(radians(frameCount)), 0, targetXX, targetYY);


      if (q==1)
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

          lscr[q].copy(x2, y2, w, h, tempX, tempY, w, h);
          //set(x2, y2+screenAdjust, get(tempX, tempY, w, h));
        } else {
          lscr[q].copy(x2, y2, w, h, x1, y1, w/2, h);
          //set(x2, y2+screenAdjust, get(x1, y1, w/2, h));
        }
      }
      if (q==1)
        SG[1][5] = false;
    }


    lscr[q].endDraw();
    image(lscr[q], q*1920, 0, tempWidth, newHeight);
  }
  /*
  if (SG[1][7] == true) {
   
   fx.render()
   .sobel()
   //.bloom(0.1, 20, 30)
   //.blur(10, 0.5)
   //.toon()
   .brightPass(0.1)
   .blur(20, 30)
   .compose();
   } else {
   }
   */

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
