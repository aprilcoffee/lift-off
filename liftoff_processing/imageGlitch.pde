PImage imageGlitch(PImage P) {
  PImage temp = P;
  /*
  temp.loadPixels();
   colorMode(RGB);
   color randomColor = color(random(255), random(255), random(255), 255);
   
   for (int y=0; y<temp.height; y++) {
   if (random(100)<10) {
   for (int x=0; x<temp.width; x++) {
   // get the color for the pixel at coordinates x/y
   color pixelColor = temp.pixels[y + x * temp.height];
   // percentage to mix
   float mixPercentage = .5 + random(50)/25;
   // mix colors by random percentage of new random color
   //temp.pixels[y + x * temp.height] =  lerpColor(pixelColor, randomColor, mixPercentage);
   temp.pixels[y + x * temp.height] = randomColor;
   if (random(100)<25) {
   randomColor = color(random(255), random(255), random(255), 255);
   }
   }
   }
   }
   
   temp.updatePixels();
   */
  if (random(100)<70) {
    for (int s=0; s<10; s++) {
      int x1 = 0;
      int y1 = floor(random(temp.height));

      int x2 = round(x1 + random(-10, 10));
      int y2 = round(y1 + random(-4, 4));

      int w = temp.width;
      int h = floor(random(10));
      temp.set(x2, y2, temp.get(x1, y1, w, h));
    }
  }
  return temp;
}
