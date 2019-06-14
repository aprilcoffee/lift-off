
class Star {
  PVector pos = new PVector();

  float pz;
  float speed;

  float R, theta, v, proportion, proportionV;

  float ssx, ssy;
  Star(int eSpeed, float _proportionV) {
    pos.x = random(-starWidth/4, starWidth/4);
    pos.y = random(-starHeight/4, starHeight/4);
    pos.z = random(starWidth);
    pz = pos.z;
    speed = eSpeed;
    R = 100;
    theta = random(360);
    v =  random(1, 2);
    proportion = 0;
    proportionV = _proportionV;
  }
  void update() {
    pos.z -= speed;
    //if (pos.z < 0.5) {
    //  pos.z = starWidth;
    //  pos.x = random(-starWidth, starWidth);
    //  pos.y = random(-starHeight, starHeight);
    //  pz = pos.z;
    //}
    theta = theta + v;

    if (starGoCenter==true) {
      if (proportion < 1) {
        proportion = proportion+proportionV;
      } else {
        proportion = 1;
      }
    }
  }
  void show(PGraphics P) {
    float sx = map(pos.x/pos.z, 0, 1, 0, starWidth);
    float sy = map(pos.y/pos.z, 0, 1, 0, starHeight);
    float r = map(pos.z, 0, starWidth, 2, 0.3);
    float px = map(pos.x/pz, 0, 1, 0, starWidth);
    float py = map(pos.y/pz, 0, 1, 0, starHeight);

    float x = (1-proportion)*px+proportion*R*cos(radians(theta));
    float y = (1-proportion)*py+proportion*R*sin(radians(theta));
    float z = R*sin(radians(frameCount));

    float ssx = (1-proportion)*sx+proportion*R*cos(radians(theta-v));
    float ssy = (1-proportion)*sy+proportion*R*sin(radians(theta-v));
    float ssz = R*sin(radians(frameCount-1));

    P.stroke(255, 200);
    P.strokeWeight(r);
    P.line(x, y, z, ssx, ssy, ssz);
    pz = pos.z;
  }
}
void geometryInit() {
  geometry.clear();
  for (int i=0; i<=total; i++) {
    float r = geometryR;
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    //float r2 = superShape(lat, m, n1, n2, n3);
    float r2 = 1;
    for (int j=0; j<=total; j++) {
      float lon = map(j, 0, total, -PI, PI);
      //float r1 = superShape(lon, m, n1, n2, n3);
      float r1 = 1;

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

      //geometry[i][j] = new Geometry(i, j, temp);

      geometry.add(new Geometry(i, j, temp));
    }
  }
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

  //if (startMove)
  //  return r;
  //else 
  return 1;
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

  float explosionR1;
  float explosionR2;

  float R2;
  float R1;
  PVector center1;
  PVector center2;
  Geometry(int ei, int ej, PVector[] eglobeTar) {

    center1 = new PVector();
    center2 = new PVector();
    ii = ei;
    jj = ej;
    globeTar = eglobeTar;

    globe = new PVector[6];
    globeTexture = new PVector(float(ii)/total, float(jj)/total);
    globeTint = 255;
    for (int s=0; s<6; s++) {
      globe[s] = new PVector(0, 0, 0);
    }
    flyingR1 = 500;
    flyingR2 = 500;

    explosionR1 = geometryR + random(500, 5000);
    explosionR2 = geometryR + random(500, 5000);

    R1 = geometryR;
    R2 = geometryR;
  }
  void update() {
    if (flying==true) {
      float lat = map(ii, 0, total, -HALF_PI, HALF_PI);
      //float r2 = superShape(lat, m, n1, n2, n3);
      float r2 = 1;
      float lon = map(jj, 0, total, -PI, PI);
      float r1 = 1;
      //float r1 = superShape(lon, m, n1, n2, n3);
      flyingR1 = geometryR+random(400);
      flyingR2 = geometryR+random(400);
      flyAway(r1, r2, flyI, flyJ, flyingR1, flyingR2);
      flying=false;
    }
    for (int s=0; s<6; s++) {
      globe[s].add((PVector.sub(globeTar[s], globe[s])).mult(0.05));
    }
  }

  void show(PVector tempRight, PVector tempDown, PVector tempRightDown, int showMode, PGraphics P) {

    if (showMode == 0) {
      P.noFill();
      P.noStroke();
    } else if (showMode == 1) {
      P.noFill();
      P.stroke(255, 100);
    } else if (showMode == 2) {
      P.fill(255, 100);
    }
    pushMatrix();

    if (showMode == 1 && textureOn!=true) {
      P.beginShape(POINTS);
    } else {
      P.beginShape(TRIANGLE_STRIP);
    }
    if (textureOn==true && !explosion) {
      P.texture(orbitTexture);
    } else {
      if (showMode == 0) {
        P.stroke(255, 100);
        //strokeWeight(0.5);
      } else if (showMode == 1) {
        P.stroke(255, 150);
      } else if (showMode == 2) {
        P.noStroke();
      }
    }
    P.textureMode(NORMAL);

    if (explosion) {

      P.vertex(globe[0].x, globe[0].y, globe[0].z, globeTexture.y, globeTexture.x);
      P.vertex(globe[1].x, globe[1].y, globe[1].z, tempRight.y, tempRight.x);
      P.vertex(globe[2].x, globe[2].y, globe[2].z, tempDown.y, tempDown.x);
      /*
      P.translate(center1.x, center1.y, center1.z);
       P.rotate(radians(frameCount+ii+jj));
       float tempX, tempY, tempZ;
       
       P.scale(0.3);
       P.vertex(globe[0].x-center1.x, globe[0].y-center1.y, globe[0].z-center1.z, globeTexture.y, globeTexture.x);
       P.vertex(globe[1].x-center1.x, globe[1].y-center1.y, globe[1].z-center1.z, tempRight.y, tempRight.x);
       P.vertex(globe[2].x-center1.x, globe[2].y-center1.y, globe[2].z-center1.z, tempDown.y, tempDown.x);*/
    } else {
      //println("Hi");P
      P.vertex(globe[0].x, globe[0].y, globe[0].z, globeTexture.y, globeTexture.x);
      P.vertex(globe[1].x, globe[1].y, globe[1].z, tempRight.y, tempRight.x);
      P.vertex(globe[2].x, globe[2].y, globe[2].z, tempDown.y, tempDown.x);
    }
    P.endShape(CLOSE);

    if (showMode == 1&&textureOn!=true) {
      P.beginShape(POINTS);
    } else {
      P.beginShape(TRIANGLE_STRIP);
    }
    if (textureOn==true&& !explosion) {
      P.texture(orbitTexture);
    } else {
      if (showMode == 0) {
        P.stroke(255, 100);
        //strokeWeight(0.5);
      } else if (showMode == 1) {
        P.stroke(255, 150);
      } else if (showMode == 2) {
        P.noStroke();
      }
    }
    if (explosion) {
      /*
      P.translate(center2.x, center2.y, center2.z);
       P.rotate(radians(frameCount+ii+jj));
       float tempX, tempY, tempZ;
       
       //tempX= 
       P.scale(0.3);*/


      P.vertex(globe[3].x, globe[3].y, globe[3].z, globeTexture.y, globeTexture.x);
      P.vertex(globe[4].x, globe[4].y, globe[4].z, tempRight.y, tempRight.x);
      P.vertex(globe[5].x, globe[5].y, globe[5].z, tempDown.y, tempDown.x);
      //P.vertex(globe[3].x-center2.x, globe[3].y-center2.y, globe[3].z-center2.z, globeTexture.y, globeTexture.x);
      //P.vertex(globe[4].x-center2.x, globe[4].y-center2.y, globe[4].z-center2.z, tempRight.y, tempRight.x);
      //P.vertex(globe[5].x-center2.x, globe[5].y-center2.y, globe[5].z-center2.z, tempDown.y, tempDown.x);
    } else {
      P.vertex(globe[3].x, globe[3].y, globe[3].z, globeTexture.y, globeTexture.x);
      P.vertex(globe[4].x, globe[4].y, globe[4].z, tempRight.y, tempRight.x);
      P.vertex(globe[5].x, globe[5].y, globe[5].z, tempDown.y, tempDown.x);
    }
    P.endShape(CLOSE);

    popMatrix();
  }
  void exploded(float r1, float r2, float i, float j) {
    r = explosionR1;
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


    r = explosionR2;
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

    r = er+random(-800, 800);
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


void orbitTextureDraw(PGraphics P) {
  P.beginDraw();
  P.tint(255);
  P.background(0, 0);
  if (changeTexture==true) {
    currentPlanetImage = (int)random(5);
    changeTexture = false;
  }
  P.image(planetImage[currentPlanetImage], 0, 0, P.width, P.height);
  P.endDraw();
}
void resetSphereLocation() {
  for (int i=0; i<total; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = 1;
    for (int j=0; j<total; j++) {
      // lat -Pi/2 ~ Pi/2
      // lon -PI ~ PI
      float lon = map(j, 0, total, -PI, PI);
      float r1 = 1;
      Geometry G = geometry.get(i*(total+1) + j);
      G.renewLocation(r1, r2, i, j);
    }
  }
}
