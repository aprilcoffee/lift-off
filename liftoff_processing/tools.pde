class textGenerator {
  char[] title;
  float[] titleFloat;
  float[] titleTargetFloat;

  int textLength;
  textGenerator(String S) {

    title = new char[20];
    titleFloat = new float[20];
    titleTargetFloat = new float[20];

    char[] temp = S.toCharArray();
    textLength = temp.length;
    for (int s=0; s<temp.length; s++) {
      titleTargetFloat[s] = int(temp[s]);
    }
  }
  void show(float x, float y, int textSize) {
    for (int s=0; s<textLength; s++) {
      titleFloat[s] += (titleTargetFloat[s] - titleFloat[s])*0.3;
      if ((titleTargetFloat[s] - titleFloat[s]) < 0.1 && (titleTargetFloat[s] - titleFloat[s])>0) {
        titleFloat[s]+=1;
      }
    }
    for (int s=0; s<textLength; s++) {
      title[s] = char(floor(titleFloat[s]));
    }
    int catchLength=0;
    for (catchLength=0; catchLength<textLength; catchLength++) {
      if (char(floor(titleFloat[catchLength])) == ' ')break;
    }
    char[] tempShow = new char[catchLength];
    for (int s=0; s<catchLength; s++) {
      tempShow[s]=char(floor(titleFloat[s]));
    }
    pushMatrix();
    translate(x, y);
    textAlign(LEFT);
    textSize(textSize);
    textMode(SHAPE);
    fill(255);
    text(new String(tempShow), 0, 0);
    popMatrix();
  }
  void showOnGraphics(float x, float y, int textSize, PGraphics P) {
    for (int s=0; s<textLength; s++) {
      titleFloat[s] += (titleTargetFloat[s] - titleFloat[s])*0.3;
      if ((titleTargetFloat[s] - titleFloat[s]) < 0.1 && (titleTargetFloat[s] - titleFloat[s])>0) {
        titleFloat[s]+=1;
      }
    }
    for (int s=0; s<textLength; s++) {
      title[s] = char(floor(titleFloat[s]));
    }
    int catchLength=0;
    for (catchLength=0; catchLength<textLength; catchLength++) {
      if (char(floor(titleFloat[catchLength])) == ' ')break;
    }
    char[] tempShow = new char[catchLength];
    for (int s=0; s<catchLength; s++) {
      tempShow[s]=char(floor(titleFloat[s]));
    }
    P.pushMatrix();
    P.translate(x, y);
    P.textAlign(LEFT);
    P.textSize(textSize);
    P.textMode(SHAPE);
    P.fill(255);
    P.text(new String(tempShow), 0, 0);
    P.popMatrix();
  }
  void update(String S) { 
    char[] temp = S.toCharArray();
    int newTextLength = temp.length;
    if (newTextLength < textLength) {
      for (int i=newTextLength; i<textLength; i++) {
        titleTargetFloat[i] = int(' ');
      }
    } else {
      textLength = newTextLength;
    }
    for (int s=0; s<temp.length; s++) {
      titleTargetFloat[s] = int(temp[s]);
    }
  }
}
void CPUperformanceUpdate() {
  for (Method method : operatingSystemMXBean.getClass().getDeclaredMethods()) {
    method.setAccessible(true);
    if (method.getName().startsWith("get") && Modifier.isPublic(method.getModifiers())) {
      Object value;
      try {
        value = method.invoke(operatingSystemMXBean);
      } 
      catch (Exception e) {
        value = e;
      } 
      //System.out.println(method.getName() + " = " + value);
      if (method.getName() == "getProcessCpuLoad") {
        fill(255);
        CPUperform = nfc(float(value.toString())*100, 3);
      }
    }
  }
}
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
