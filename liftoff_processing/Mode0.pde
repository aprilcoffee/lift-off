void initPhase() {
  background(0);
  imageMode(CENTER);
  colorMode(RGB, 255);
  blendMode(BLEND);
  pushMatrix();
  float shakeGlitch = map(transition0to1Dark, 0, 255, 5, 150);
  LTGlogo = loadImage("LTG.png");
  LTGlogo.loadPixels();
  color randomColor = color(random(255), random(255), random(255), 255);
  if (random(100)<(25+shakeGlitch/2)) {
    for (int y=0; y<LTGlogo.height; y++) {
      for (int x=0; x<LTGlogo.width; x++) {
        // get the color for the pixel at coordinates x/y
        color pixelColor = LTGlogo.pixels[y + x * LTGlogo.height];
        if (pixelColor == color(255)) {
          // percentage to mix
          float mixPercentage = .5 + random(50)/50;
          // mix colors by random percentage of new random color
          LTGlogo.pixels[y + x * LTGlogo.height] =  lerpColor(pixelColor, randomColor, mixPercentage);
        }
        if (random(100)<25) {
          randomColor = color(random(255), random(255), random(255), 255);
        }
      }
    }
  }
  LTGlogo.updatePixels();
  for (int s=0; s<100; s++) {
    int x1 = 0;
    int y1 = floor(random(LTGlogo.height));

    int x2 = round(x1 + random(-shakeGlitch, shakeGlitch));
    int y2 = round(y1 + random(-shakeGlitch/3, shakeGlitch/3));

    int w = LTGlogo.width;
    int h = floor(random(10));
    LTGlogo.set(x2, y2, LTGlogo.get(x1, y1, w, h));
  }
  translate(width/2, height/2);
  for (int s=0; s<blobs.size(); s++) {
    blobs.get(s).update();
    blobs.get(s).showMode1();
    blobs.get(s).cons();
  }
  image(LTGlogo, -10, 0, width*0.4, height*0.4);
  popMatrix();
  blendMode(BLEND);
}
