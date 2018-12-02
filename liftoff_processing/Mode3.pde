
void mode3() { 
  julia(juliaTexture);
  pushMatrix();
  colorMode(RGB, 255);
  blendMode(SUBTRACT);  
  background(255);
  float movementScale = spectrumScale ;
  float shakeGlitch = map(totalAmp, 0, 100000, 0, 15);
  //if (random(shakeGlitch)<5) {
  //}
  soundCheck();
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
  //drawTerrain();
  popMatrix();  
  /*
   translate(width/2, height/2);
   for (int s=0; s<blobs.size(); s++) {
   blobs.get(s).update();
   blobs.get(s).show();
   blobs.get(s).cons();
   }
   imageMode(CENTER);
   */
  if (juliaShowTrigger) {
    tint(100);
    image(juliaTexture, 0, 0, width, height);
    juliaShowTrigger=false;
    tint(255);
  }
  /*
  if (bobbyTrigger) {
   filter(INVERT);
   }*/
}
void mode4() {
}
