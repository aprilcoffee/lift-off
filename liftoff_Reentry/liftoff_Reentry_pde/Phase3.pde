
class Particle {
  PVector pos;
  PVector ppos;
  PVector va, vt;
  PVector a, t;
  float cor_x, cor_y;
  Particle(int _cor_x, int _cor_y) {
    cor_x = _cor_x;
    cor_y = _cor_y;
    pos = PVector.mult(PVector.random3D(), width);
    ppos = PVector.mult(PVector.random3D(), width);
    //ppos.x = floor(random(width));
    //ppos.y = floor(random(height));
    randomlize();
  }
  void update() {
    pos.add(PVector.mult(PVector.sub(ppos, pos), 0.3));
  }
  void show() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);
    //stroke(map(pos.x, 0, width, 0, 255), 100, 200);
    stroke(255);

    if (cor_x%50==0 && cor_y%500==0) {
      fill(255, 0, 0);
      //text(nfc(cor_x/10- 50, 0), 10, 10);
      //text(nfc(cor_y/10- 50, 0), 10, 20);

      text(nfc(pos.x, 1), 10, 10);
      text(nfc(pos.y, 1), 10, 20);

      noFill();
    } else if (cor_y%50==0 && cor_x%500==0) {

      fill(255);
      //text(nfc(cor_x/10- 50, 0), 10, 10);
      //text(nfc(cor_y/10- 50, 0), 10, 20);
      text(nfc(pos.x, 1), 10, 10);
      text(nfc(pos.y, 1), 10, 20);
      noFill();
    }



    if (SG[3][6] == true) {
    }
    stroke(map(cor_x, 0, width, 0, 255), 
      map(cor_y, 0, height, 0, 255), 
      map(pos.z, -500, 500, 0, 255));
    stroke(180, 180, 250);

    if (cor_x%100==0 && cor_y%100==0) {
      for (int s=-5; s<5; s++) {
        if(SG[3][7] == true){
        stroke(255, 30, 30);
        }else if(SG[3][8]){
        stroke(255,250);
        }
        point(0+s, 0);        
        point(0, 0+s);
      }
    } else { 
      if (SG[3][5] == true) {
        stroke(180, 180, 250);
      } else if (SG[3][6]==true) {
        stroke(255, 250);
      }
      point(0, 0);
    }

    popMatrix();
  }
  void returnToGrid() {
    ppos.x = cor_x;
    ppos.y = cor_y;
    ppos.z = random(-10, 10);
  }
  void randomlize() { 
    ppos.x = random(width);
    ppos.y = random(height);
    ppos.z = random(-3000, 3000);
  }
  void randomSphere() {
    ppos = PVector.mult(PVector.random3D(), width/2);
  }
}
