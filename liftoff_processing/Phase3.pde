void mode3A() {
  for (int i=0; i<ballCollection.size(); i++) {
    Ball mb = (Ball) ballCollection.get(i);
    mb.run();
  }
  theta += (0.0523/2);
  if (moveStuff==true) {
    createStuff();
    moveStuff=false;
  }
}
void mode3B() {  
  drawTerrain();
}
void mode3C() {
  float movementScale = spectrumScale ;
  pushMatrix();
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
  popMatrix();
}
void julia(PGraphics P) {
  float ca = sin(radians(juliaAngle))/1.3;
  float cb = cos(radians(juliaAngle*2.13))/1.7;
  juliaAngle += 0.3;
  int maxierations = 20;
  float w = 2;
  float h = (w*P.height)/P.width;

  float xmin = -w/2;
  float ymin = -h/2;

  float xmax = xmin+w;
  float ymax = ymin+h;

  float dx = (xmax-xmin)/P.width;
  float dy = (ymax-ymin)/P.height;

  float y = ymin;

  P.beginDraw();
  P.loadPixels();
  for (int j=0; j<P.height; j++) {

    float x = xmin;
    for (int i = 0; i<P.width; i++) {

      float a = x;
      float b = y;

      int n = 0;
      while (n<maxierations) {
        float aa = a*a;
        float bb = b*b;

        if (aa+bb>4.0) {
          break;
        } 
        float twoab = 2*a*b;
        a = aa - bb + ca;
        b = twoab + cb;
        n++;
      }
      //float bright = map(n, 0, maxierations, 0, 255);
      float bright = map(n, 0, maxierations, 0, 1);
      bright = map(sqrt(bright), 0, 1, 0, 255);

      if (n == maxierations)
        P.pixels[i+j*P.width] = color(255);
      else {
        float hue = sqrt(float(n)/maxierations) * 255;
        P.pixels[i+j*P.width] = color(hue);
      }
      x+=dx;
    }
    y+=dy;
  }
  P.updatePixels();
  P.endDraw();
}
class Blob {
  PVector pos;
  PVector vel = new PVector(0, 0);
  float radius;
  float yoff = random(100);
  boolean killMode1 = false;
  int killMode1Num = 255;

  // float xoff = random(100);
  Blob(float ex, float ey, float er) {
    pos = new PVector(ex, ey);
    radius = er;
  }
  void update() {
    PVector newVel = new PVector(0, 0);
    newVel.div(50);
    newVel.limit(3);
    vel.lerp(newVel, 0.2);
    pos.add(vel);
  }

  void cons() {
    pos.x = constrain(pos.x, -width/4, width/4);
    pos.y = constrain(pos.y, -height/4, height/4);
  }
  void showMode1() {
    if (killMode1==true) {
      killMode1Num-=10;
      if (killMode1Num<0)killMode1Num=0;
    }
    //fill(255);
    noFill();
    stroke(killMode1Num);
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01;
  }
  void show() {

    //fill(255);
    noFill();
    stroke(255, 100);
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01;
  }
  void showWithFill() {
    //fill(255);
    noFill();
    stroke(255, 150);
    strokeWeight(2);
    fill(0, 100);
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    float xoff = 0;
    for (float i =0; i<=TWO_PI; i+=0.1) {

      float offset = map(noise(xoff, yoff), 0, 1, -30, 30);
      float r = radius+offset;
      float x = r*cos(i);
      float y = r*sin(i);

      vertex(x, y);
      xoff+=0.1;
    }
    //stroke(255, 0, 0);
    endShape(CLOSE);
    popMatrix();
    yoff+=0.01;
  }
}

class Particle {
  PVector pos;
  PVector prevPos;
  ArrayList<PVector> trace;
  int traceLength = 50;
  PVector vel;
  PVector acc;

  float colorCode;
  Particle(float ex, float ey, float ez) {
    pos = new PVector(ex, ey, ez);
    prevPos = pos.copy();
    vel = PVector.random3D();
    vel.setMag(random(3, 5));
    acc = new PVector(0, 0, 0);

    trace = new ArrayList<PVector>();
    for (int s=0; s<traceLength; s++) {
      trace.add(new PVector(pos.x, pos.y, pos.z));
    }
    colorCode = random(10);
  }
  void update() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(15);
    acc.mult(0);
  }
  void show() {
    noFill();
    stroke(255, 10);
    strokeWeight(1);
    //point(pos.x, pos.y);
    //line(pos.x, pos.y, prevPos.x, prevPos.y);
    //colorMode(HSB, 255);
    //blendMode(ADD);
    int showLength = (int)map(constrain(totalAmp, 0, 10000), 0, 10000, 0, trace.size());
    //println(fftLin.getAvg(0));
    for (int s=traceLength-1; s>traceLength-showLength; s--) {
      if (colorCode<6) {
        colorMode(HSB);
        stroke( 
          map(s, traceLength-showLength, traceLength, 80, map(fftLin.getAvg(10)*spectrumScale, 0, 400, 0, 255)), 
          map(s, traceLength-showLength, traceLength, 0, 120), 
          map(s, traceLength-showLength, traceLength, 50, 140), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      } else {
        stroke( 
          map(s, traceLength-showLength, traceLength, 200, 255), 
          map(s, traceLength-showLength, traceLength, 0, map(fftLin.getAvg(12)*spectrumScale, 0, 400, 0, 255)), 
          map(s, traceLength-showLength, traceLength, 50, 120), 
          map(s, traceLength-showLength, traceLength, 50, 200));
      }
      line(trace.get(s-1).x, trace.get(s-1).y, trace.get(s).x, trace.get(s).y);
    }
    trace.remove(0);
    trace.add(new PVector(pos.x, pos.y));
  }
  void attracted(PVector target, int flag) {
    PVector force = PVector.sub(target, pos);
    float dsquared = force.magSq();
    dsquared = constrain(dsquared, 50, 400);
    float G = 150;
    float strength = G/dsquared;
    force.setMag(strength);
    acc.add(force);
  }
}

void drawTerrainInGraphics(PGraphics P) {
  P.beginDraw();
  P.background(0, 0);
  for (int y = rows-1; y >= 1; y--) {
    for (int x = 0; x < cols; x++) {  
      terrainLeft[x][y] = terrainLeft[x][y-1];
      terrainRight[x][y] = terrainRight[x][y-1]; 
      audioAmp[y]=audioAmp[y-1];
    }
  }
  audioAmp[0] = 0;
  for (int x = 0; x < cols; x++) {
    terrainLeft[x][0] = in.left.get(x)*150;
    terrainRight[x][0] = in.right.get(x)*150;
    audioAmp[0]+=abs(fftLin.getBand(x*5))*15;//renew Amount of Sound
  }
  P.camera(0, -100, 1000, 0, 0, 0, 0, 1, 0);
  //P.translate(0, 300);
  //println(audioAmp[0]);
  //background(255); 
  //blendMode(ADD);
  //println(fft.specSize());
  //-------------------terrain1-------------------
  P.pushMatrix();
  //noFill();
  //fill(255,0,0);
  //translate(-300, 0);
  P.rotateX(PI/2);
  P.scale(2, 1);
  //translate(-w/2, -h/2); //*****Move a little
  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>5000) {
      P.stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
    } else {
      P.stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    P.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x+=3) {
      //noStroke();
      //fill(audioAmp[y], audioAmp[y], audioAmp[y], 100);
      P.noFill();
      P.stroke(255);
      P.vertex(x*scl, y*scl, terrainLeft[x][y]);
      P.vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
    }
    P.endShape();
  }
  P.popMatrix();

  //-------------------terrain2-------------------

  P.pushMatrix();
  //translate(300, 0);
  P.rotateX(PI/2);
  P.scale(2, 1);

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>5000) {
      P.stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
    } else {
      P.stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    P.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x+=3) {
      //noStroke();
      //fill(map(audioAmp[y],0,20000,0,255), audioAmp[y], audioAmp[y], 50);
      P.noFill();
      P.stroke(255);
      P.vertex(-x*scl, y*scl, terrainRight[x][y]);
      P.vertex(-x*scl, (y+1)*scl, terrainRight[x][y+1]);
    }
    P.endShape();
  }
  P.popMatrix();
  P.endDraw();
}



void drawTerrain() {
  pushMatrix();
  for (int y = rows-1; y >= 1; y--) {
    for (int x = 0; x < cols; x++) {  
      terrainLeft[x][y] = terrainLeft[x][y-1];
      terrainRight[x][y] = terrainRight[x][y-1]; 
      audioAmp[y]=audioAmp[y-1];
    }
  }
  audioAmp[0] = 0;
  for (int x = 0; x < cols; x++) {
    terrainLeft[x][0] = in.left.get(x)*150;
    terrainRight[x][0] = in.right.get(x)*150;
    audioAmp[0]+=abs(fftLin.getBand(x*5))*15;//renew Amount of Sound
  }
  translate(0, 0);
  //println(audioAmp[0]);
  //background(255); 
  //blendMode(ADD);
  //println(fft.specSize());

  if (TerrainRandom==true) {
    if (terrainRandomTrigger==true) {
      TerrainMode = (int)random(4);
      terrainRandomTrigger=false;
    }
  } 

  //-------------------terrain1-------------------
  pushMatrix();
  //noFill();
  //fill(255,0,0);
  translate(-300, 0);
  rotateX(PI/2);
  scale(2, 1);
  //translate(-w/2, -h/2); //*****Move a little

  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>1500) {
      stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      //println(audioAmp[y]);
    } else {
      //println(audioAmp[y]);
      stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }

    if (TerrainMode==0) {
      beginShape(POINT);
      for (int x = 0; x < cols; x++) {
        //noStroke();
        //fill(255,0,0);
        stroke(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        point(x*scl, y*scl, terrainLeft[x][y]);
        point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        //vertex(x*scl, y*scl, terrainLeft[x][y]);
        //vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
      }
      endShape();
    } else if (TerrainMode==1) {
      beginShape();
      for (int x = 0; x < cols; x++) {
        //noStroke();
        //fill(255,0,0);
        stroke(map(audioAmp[y], 0, 5000, 0, 255), map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        //point(x*scl, y*scl, terrainLeft[x][y]);
        //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        vertex(x*scl, y*scl, terrainLeft[x][y]);
        vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
      }
      endShape();
    } else if (TerrainMode==2) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        //noStroke();
        //fill(255,0,0);
        fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        //point(x*scl, y*scl, terrainLeft[x][y]);
        //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        vertex(x*scl, y*scl, terrainLeft[x][y]);
        vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
      }
      endShape();
    } else if (TerrainMode==3) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        stroke(10, map(y, rows, 0, 10, 80));
        //fill(255,0,0);
        fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        //point(x*scl, y*scl, terrainLeft[x][y]);
        //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        vertex(x*scl, y*scl, terrainLeft[x][y]);
        vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
      }
      endShape();
    }
  }
  popMatrix();

  //-------------------terrain2-------------------

  pushMatrix();
  translate(300, 0);
  rotateX(PI/2);
  scale(2, 1);



  for (int y = 0; y < rows-1; y++) {//rows-1 > and the below it (y+1)
    if (audioAmp[y]>1500) {
      stroke(map(audioAmp[y], 1500, 2200, 0, 255), 200, 200, map(y, 0, 80, 255, 0));
      //println(audioAmp[y]);
    } else {
      //println(audioAmp[y]);
      stroke(255, map(y, 0, 80, 1, 0)*map(audioAmp[y], 0, 1500, 50, 150)); // change tranparency by amount of sound
    }
    if (TerrainMode==0) {
      beginShape(POINT);
      for (int x = 0; x < cols; x++) {
        //noStroke();
        //fill(255,0,0);
        stroke(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        point(x*scl, y*scl, terrainRight[x][y]);
        point(x*scl, (y+1)*scl, terrainRight[x][y+1]);
        //vertex(x*scl, y*scl, terrainLeft[x][y]);
        //vertex(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
      }
      endShape();
    } else if (TerrainMode==1) {
      beginShape();
      for (int x = 0; x < cols; x++) {
        //noStroke();
        //fill(255,0,0);
        stroke(map(audioAmp[y], 0, 5000, 0, 255), map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        //point(x*scl, y*scl, terrainLeft[x][y]);
        //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        vertex(x*scl, y*scl, terrainRight[x][y]);
        vertex(x*scl, (y+1)*scl, terrainRight[x][y+1]);
      }
      endShape();
    } else if (TerrainMode==2) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        //noStroke();
        //fill(255,0,0);
        fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        //point(x*scl, y*scl, terrainLeft[x][y]);
        //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        vertex(x*scl, y*scl, terrainRight[x][y]);
        vertex(x*scl, (y+1)*scl, terrainRight[x][y+1]);
      }
      endShape();
    } else if (TerrainMode==3) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        stroke(10, map(y, rows, 0, 10, 80));
        //fill(255,0,0);
        fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(map(audioAmp[y], 0, 5000, 0, 255), audioAmp[y], audioAmp[y], map(y, rows, 0, 10, 80));
        //fill(255);
        //point(x*scl, y*scl, terrainLeft[x][y]);
        //point(x*scl, (y+1)*scl, terrainLeft[x][y+1]);
        vertex(x*scl, y*scl, terrainRight[x][y]);
        vertex(x*scl, (y+1)*scl, terrainRight[x][y+1]);
      }
      endShape();
    }
  }
  popMatrix();
  popMatrix();
}

void createStuff() {
  ballCollection.clear();
  for (int i=0; i<totalBallNum; i++) {
    float tempX, tempY;
    float R=random(200);
    tempX = R*cos(radians(random(360)));
    tempY = R*sin(radians(random(360)));
    PVector org = new PVector(tempX, tempY);
    float radius = random(20, 80);
    PVector loc = new PVector(org.x+radius, org.y);
    float offSet = random(TWO_PI);
    int dir = 1;
    float r = random(1);
    if (r>0.5) dir =-1;

    Ball myBall = new Ball(org, loc, radius, dir, offSet);
    ballCollection.add(myBall);
  }
}
class Ball {
  PVector org, loc;
  float sz = 2;
  float radius, offSet, a, c;
  float[] col = new float[totalBallNum];
  int s, dir, countC, d = 40;
  boolean[] connection = new boolean[totalBallNum];

  Ball(PVector _org, PVector _loc, float _radius, int _dir, float _offSet) {
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
  }

  void run() {
    display();
    move();
    lineBetween();
  }

  void move() {
    if (moveYes==true) {
      loc.x = org.x + sin(theta*dir+offSet)*radius+tan(theta*dir);
      loc.y = org.y + cos(theta*dir+offSet)*radius+tan(theta*dir);
    } else {
      loc.x = org.x + sin(theta*dir+offSet)*radius;//+tan(theta*dir);
      loc.y = org.y + cos(theta*dir+offSet)*radius;//+tan(theta*dir);
    }
  }
  void lineBetween() {
    countC = 1;
    for (int i=0; i<ballCollection.size(); i++) {
      Ball other = (Ball) ballCollection.get(i);
      float distance = loc.dist(other.loc);
      if (distance >0 && distance < d) {
        connection[i] = true;
      } else {
        connection[i] = false;
      }
      if (connection[i]) countC++;
      //println(countC);
      if (distance >0 && distance < d) {
        a = map(countC, 1, 20, 10, 150);
        stroke(#ffffff, a);
        //strokeWeight(c);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
        stroke(#ffffff, a/10);
        rectMode(CENTER);
        rect(loc.x, loc.y, 2, 2);
        colorMode(RGB);
      }
    }
    //println(countC);
  }
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(255, a);
    ellipse(loc.x, loc.y, sz*a, sz);
  }
}
