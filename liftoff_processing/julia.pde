void julia(PGraphics P) {
  float ca = sin(radians(juliaAngle))/1.3;
  float cb = cos(radians(juliaAngle*2.13))/1.7;
  juliaAngle += 0.3;
  int maxierations = 20;
  float w = 2;
  float h = (w*P.height)/P.width;

  float xmin = -w/2;
  float ymin = -h/2;

  float xmax = xmin+w;
  float ymax = ymin+h;

  float dx = (xmax-xmin)/P.width;
  float dy = (ymax-ymin)/P.height;

  float y = ymin;

  P.beginDraw();
  P.loadPixels();
  for (int j=0; j<P.height; j++) {

    float x = xmin;
    for (int i = 0; i<P.width; i++) {

      float a = x;
      float b = y;

      int n = 0;
      while (n<maxierations) {
        float aa = a*a;
        float bb = b*b;

        if (aa+bb>4.0) {
          break;
        } 
        float twoab = 2*a*b;
        a = aa - bb + ca;
        b = twoab + cb;
        n++;
      }
      //float bright = map(n, 0, maxierations, 0, 255);
      float bright = map(n, 0, maxierations, 0, 1);
      bright = map(sqrt(bright), 0, 1, 0, 255);

      if (n == maxierations)
        P.pixels[i+j*P.width] = color(255);
      else {
        float hue = sqrt(float(n)/maxierations) * 255;
        P.pixels[i+j*P.width] = color(hue);
      }
      x+=dx;
    }
    y+=dy;
  }
  P.updatePixels();
  P.endDraw();
}
