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
    if (proportion < 1) {
      proportion = proportion+proportionV;
    } else {
      proportion = 1;
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
