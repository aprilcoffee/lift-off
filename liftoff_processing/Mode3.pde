void mode3() { 
  julia(juliaTexture);
  colorMode(HSB, 255);
  blendMode(ADD);
  //background(0);
  if (transiting==false)
    background(0);
  float shakeGlitch = map(totalAmp, 0, 100000, 0, 15);
  //println(totalAmp);
  //if (random(shakeGlitch)<5) {
  //}
  soundCheck();  

  if (frameCount%10==0) {
    println(totalAmp);
  }
  float phase3CamXX = 0;
  float phase3CamYY = 0;

  if (cameraMovingX) {
    phase3CamXX=500*sin(radians(frameCount));
  } else {
    phase3CamXX = 0;
  }
  if (cameraMovingY) {
    phase3CamYY= -abs(200*sin(radians(frameCount*1.73)));
  } else {
    phase3CamYY= 0;
  }

  if (randomCam==true) {
    if (randomCamTrigger==true) { 
      phase3CamXX=random(-500, 500);
      phase3CamYY=random(-200, 100);
      randomCamTrigger=false;
    }
  }

  phase3CamX += (phase3CamXX - phase3CamX *0.3);
  phase3CamY += (phase3CamYY - phase3CamY *0.3);
  camera(phase3CamX, phase3CamY, 1000, 0, 0, 0, 0, 1, 0);

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
