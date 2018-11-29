
float m =5;
float n1 = 300;
float n2 = 400;
float n3 = 100;
void changSuperShape() {
  m = 3;
  n1 = 3;
  n2 = 4+3.53*cos(radians(frameCount*6));
  n3 = 1.732+5*sin(radians(frameCount/7.3));
}
float superShape(float theta, float m, float n1, float n2, float n3) {
  float a=1;
  float b=1;

  //float r = 1;
  float t1 = abs((1/a)*cos(m*theta/4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b)*sin(m*theta/4));
  t2 = pow(t2, n3);
  float t3 = t1+t2;
  float r = pow(t3, -1/n1);

  if (startMove)
    return r;
  else 
  return 1;
}
void orbitTextureDraw(PGraphics P) {
  P.beginDraw();
  //P.clear();
  if (crashSide==true) {
    P.colorMode(HSB, 255);
    P.tint(random(255), 200, 200);
    crashSide=false;
  } else {
    P.tint(255);
  }
  P.image(img, 0, 0, P.width, P.height);
  P.endDraw();
}
void geometryInit() {

  for (int i=0; i<=total; i++) {
    float r = geometryR;
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = superShape(lat, m, n1, n2, n3);
    for (int j=0; j<=total; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = superShape(lon, m, n1, n2, n3);

      PVector[] temp = new PVector[6];
      //r = 200;
      float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
      temp[0] = new PVector(x1, y1, z1);

      float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
      temp[1] = new PVector(x2, y2, z2);

      float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
      temp[2] = new PVector(x3, y3, z3);

      //r =200;
      float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
      temp[3] = new PVector(x4, y4, z4);

      float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
      float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
      temp[4] = new PVector(x5, y5, z5);

      float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
      float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
      temp[5] = new PVector(x6, y6, z6);

      geometry[i][j] = new Geometry(i, j, temp);
    }
  }
}

class Geometry {
  PVector[] globe;
  PVector[] globeTar;
  int globeTint;
  PVector globeTexture;

  int ii, jj;
  float r;

  boolean flying = false;
  float flyingR1;
  float flyingR2;

  float R2;
  float R1;

  Geometry(int ei, int ej, PVector[] eglobeTar) {

    ii = ei;
    jj = ej;
    globeTar = eglobeTar;

    globe = new PVector[6];
    globeTexture = new PVector(float(ii)/total, float(jj)/total);
    globeTint = 255;
    for (int s=0; s<6; s++) {
      globe[s] = new PVector(0, 0, 0);
    }
    flyingR1 = 800;
    flyingR2 = 800;

    R1 = geometryR;
    R2 = geometryR;
  }
  void update() {
    if (flying==true) {
      float lat = map(ii, 0, total, -HALF_PI, HALF_PI);
      float r2 = superShape(lat, m, n1, n2, n3);
      float lon = map(jj, 0, total, -PI, PI);
      float r1 = superShape(lon, m, n1, n2, n3);
      flyingR1 = 1000;
      flyingR2 = 1000;
      flyAway(r1, r2, flyI, flyJ, flyingR1, flyingR2);
    }
    for (int s=0; s<6; s++) {
      globe[s].add((PVector.sub(globeTar[s], globe[s])).mult(0.5));
    }
  }
  void show(PVector tempRight, PVector tempDown, PVector tempRightDown, int showMode) {
    if (showMode == 0) {
      noFill();
    } else if (showMode == 1) {
      noFill();
    } else if (showMode == 2) {
      fill(255, 100);
    }
    pushMatrix();
    if (showMode == 1) {
      beginShape(POINTS);
    } else {
      beginShape();
    }
    if (textureOn==true) {
      texture(orbitTexture);
    } else {
      if (showMode == 0) {
        stroke(255, 150);
        //strokeWeight(0.5);
      } else if (showMode == 1) {
        stroke(255, 200);
      } else if (showMode == 2) {
        noStroke();
      }
    }
    textureMode(NORMAL);
    vertex(globe[0].x, globe[0].y, globe[0].z, globeTexture.y, globeTexture.x);
    vertex(globe[1].x, globe[1].y, globe[1].z, tempRight.y, tempRight.x);
    vertex(globe[2].x, globe[2].y, globe[2].z, tempDown.y, tempDown.x);
    endShape(CLOSE);
    popMatrix();

    pushMatrix();



    if (showMode == 1) {
      beginShape(POINTS);
    } else {
      beginShape();
    }
    if (textureOn==true) {
      texture(orbitTexture);
    } else {
      if (showMode == 0) {
        stroke(255, 150);
        //strokeWeight(0.5);
      } else if (showMode == 1) {
        stroke(255, 200);
      } else if (showMode == 2) {
        noStroke();
      }
    }
    textureMode(NORMAL);
    vertex(globe[4].x, globe[4].y, globe[4].z, tempDown.y, tempDown.x);
    vertex(globe[3].x, globe[3].y, globe[3].z, tempRight.y, tempRight.x);
    vertex(globe[5].x, globe[5].y, globe[5].z, tempRightDown.y, tempRightDown.x);
    endShape(CLOSE);
    popMatrix();
  }

  void flyAway(float r1, float r2, float i, float j, float flyingR1, float flyingR2) {
    r = flyingR1;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));
    PVector center1 = new PVector((x1+x2+x3)/3, (y1+y2+y3)/3, (z1+z2+z3)/3);

    r = flyingR2;
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));
    PVector center2 = new PVector((x4+x5+x6)/3, (y4+y5+y6)/3, (z4+z5+z6)/3);

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  void setNewLocation(float r1, float r2, float i, float j, float er) {
    r = er;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    r = er+random(-30, 30);
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  void renewLocation(float r1, float r2, float i, float j) {
    r = R1;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    r = R2;
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  void resetLocation(float r1, float r2, float i, float j) {
    r = geometryR;
    float x1 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y1 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z1 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x2 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y2 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z2 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x3 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y3 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z3 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    r = geometryR;
    float x4 = r*r1*cos(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y4 = r*r1*sin(map(j, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z4 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    float x5 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float y5 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i, 0, total, -HALF_PI, HALF_PI));
    float z5 = r*r2*sin(map(i, 0, total, -HALF_PI, HALF_PI));

    float x6 = r*r1*cos(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float y6 = r*r1*sin(map(j+1, 0, total, -PI, PI))*r2*cos(map(i+1, 0, total, -HALF_PI, HALF_PI));
    float z6 = r*r2*sin(map(i+1, 0, total, -HALF_PI, HALF_PI));

    globeTar[0] = new PVector(x1, y1, z1);
    globeTar[1] = new PVector(x2, y2, z2);
    globeTar[2] = new PVector(x3, y3, z3);
    globeTar[3] = new PVector(x4, y4, z4);
    globeTar[4] = new PVector(x5, y5, z5);
    globeTar[5] = new PVector(x6, y6, z6);
  }
  void press() {
  }
}


void resetSphereLocation() {
  for (int i=0; i<total; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = superShape(lat, m, n1, n2, n3);
    for (int j=0; j<total; j++) {
      // lat -Pi/2 ~ Pi/2
      // lon -PI ~ PI
      float lon = map(j, 0, total, -PI, PI);
      float r1 = superShape(lon, m, n1, n2, n3);
      geometry[i][j].renewLocation(r1, r2, i, j);
    }
  }
}
