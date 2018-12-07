void mode3() { 
  julia(juliaTexture);
  colorMode(RGB, 255);
  blendMode(SUBTRACT);  
  //background(0);
  if (transiting==false)
    background(255);
  float shakeGlitch = map(totalAmp, 0, 100000, 0, 15);
  //println(totalAmp);
  //if (random(shakeGlitch)<5) {
  //}
  soundCheck();  
  camera(100*sin(radians(frameCount)), 0, 1000, 0, 0, 0, 0, 1, 0);

  if (phase3ShowBalls) {
    mode3A();
  }
  if (phase3ShowTerrain) {
    mode3B();
  }
  if (phase3ShowAttrator) {
    mode3C();
  }

  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  if (juliaShowTrigger) {
    tint(100);
    imageMode(CORNER);
    image(juliaTexture, 0, 0, width, height);
    juliaShowTrigger=false;
    tint(255);
  }
}
void mode4() {
}
