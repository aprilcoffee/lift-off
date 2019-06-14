void mode5() { 

  pushMatrix();
  imageMode(CORNER);
  camera(width/2.0 + camShakeX, 
    height/2.0 + camShakeY, 
    (height/2.0) / tan(PI*30.0 / 180.0)+camShakeZ, 
    width/2.0, height/2.0, 0, 
    0, 1, 0);
  //background(0);


  if (SG[6][2]==true) {
    image(crashImg, 0, 0, width, height);
    SG[6][2] = false;
  }
  if (SG[6][0]==true) {

    if (random(4)>1) {
      for (int s=0; s<10; s++) {
        int x1 = floor(random(width));
        int y1 = floor(random(height));

        int x2 = x1 + floor(random(-80, 80));
        int y2 = y1 + floor(random(0));

        int w = width;
        int h = round(random(3, 5));
        if (random(10)>5) {
          int tempX = x1;//floor(map(x1, 0, width, 0, width));
          int tempY = y1;//floor(map(y1, 0, height, 0, height));
          set(x2, y2, get(tempX, tempY, w, h));
        } else
          set(x2, y2, get(x1, y1, w/2, h));
      }
    } else {
      for (int s=0; s<10; s++) {
        int x1 = floor(random(width));
        int y1 = floor(random(height));

        int x2 = x1 + floor(random(0));
        int y2 = y1 + floor(random(-80, 80));

        int w = round(random(3, 5));
        int h = height;
        if (random(10)>5) {
          int tempX = x1;//floor(map(x1, 0, width, 0, width));
          int tempY = y1;//floor(map(y1, 0, height, 0, height));
          set(x2, y2, get(tempX, tempY, w, h));
        } else
          set(x2, y2, get(x1, y1, w/2, h));
      }
    }
  }
  if (SG[6][0]==true) {
    blendMode(BLEND);
    noStroke();
    colorMode(RGB, 255);
    fill(0, transitionFuck+=0.2);
    if (transitionFuck>=30) {
      rect(width/2, height/2, width, height);
    }
    blendMode(ADD);
    SG[6][0]=false;
  }
  println(transitionFuck);
  if (transitionFuck >= 40)changeFinish=true;
  imageMode(CENTER);
  popMatrix();
}
