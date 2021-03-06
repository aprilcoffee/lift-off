
class Particle {
  PVector pos;
  PVector ppos;
  PVector va, vt;
  PVector a, t;
  float cor_x, cor_y;
  Particle(int _cor_x, int _cor_y) {
    cor_x = _cor_x;
    cor_y = _cor_y;
    pos = PVector.mult(PVector.random3D(), newHeight*2);
    ppos = PVector.mult(PVector.random3D(), newHeight*2);
    //ppos.x = floor(random(width));
    //ppos.y = floor(random(height));
    returnToGrid();
  }
  void update() {
    pos.add(PVector.mult(PVector.sub(ppos, pos), 0.1));
  }
  void show(PGraphics P) {
    P.pushMatrix();

    P.translate(pos.x, pos.y, pos.z);
    //stroke(map(pos.x, 0, width, 0, 255), 100, 200);
    P.stroke(255);

    if (cor_x%210==0 && cor_y%newHeight%450==0) {
      P.fill(255, 0, 0);
      //text(nfc(cor_x/10- 50, 0), 10, 10);
      //text(nfc(cor_y/10- 50, 0), 10, 20);

      P.text(nfc(pos.x, 1), 10, 10);
      //P.text(nfc(pos.y, 1), 10, 20);

      P.noFill();
    } else if (cor_y%210==0 && cor_x%960==0) {
      P.fill(255);
      //text(nfc(cor_x/10- 50, 0), 10, 10);
      //text(nfc(cor_y/10- 50, 0), 10, 20);
      //P.text(nfc(pos.x, 1), 10, 10);
      P.text(nfc(pos.y, 1), 10, 20);
      noFill();
    }


    if (SG[3][6] == true) {
    }

    P.stroke(map(cor_x, 0, P.width, 0, 255), 
      map(cor_y, 0, P.height, 0, 255), 
      map(pos.z, -500, 500, 0, 255));
    if (CN[3][0]==0) {
      P.stroke(255, 250);
    } else if (CN[3][0]>=1) {
      P.stroke(255, 30, 30);
    }
    if (cor_x%180==0 && cor_y%180==0) {
      for (int s=-5; s<5; s++) {
        //if (SG[3][7] == true) {
        //  P.stroke(255, 30, 30);
        //} else if (SG[3][8]) {
        //  P.stroke(255, 250);
        //}
        P.point(0+s, 0);        
        P.point(0, 0+s);
      }
    } else { 
      if (SG[3][5] == true) {
        P.stroke(180, 180, 250);
      } else if (SG[3][6]==true) {
        P.stroke(255, 250);
      }
      P.stroke(180, 180, 250);
      P.point(0, 0);
    }

    P.popMatrix();
  }
  void returnToGrid() {
    ppos.x = cor_x;
    ppos.y = cor_y;
    ppos.z = random(-10, 10);
  }
  void randomlize() { 
    ppos.x = random(newHeight*2);
    ppos.y = random(newHeight);
    ppos.z = random(-1000, 1000);
  }
  void randomSphere() {
    ppos = PVector.mult(PVector.random3D(), newHeight/2);
  }
}
