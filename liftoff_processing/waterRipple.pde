int waterCols = 200;
int waterRows = 200;
float [][] currentWater;
float [][] previousWater;
float dampening = 0.95;
void setupWater() {
  waterCols = waterRipple.width;
  waterRows = waterRipple.height;
  currentWater = new float[waterCols][waterRows];
  previousWater = new float[waterCols][waterRows];
}
void drawWaterRipple() {
  colorMode(RGB, 255);
  waterRipple.beginDraw();
  waterRipple.clear();
  waterRipple.loadPixels();
  for (int i = 1; i < waterCols-1; i++) {
    for (int j = 1; j < waterRows-1; j++) {
      currentWater[i][j] = (
        previousWater[i-1][j]+
        previousWater[i+1][j]+
        previousWater[i][j-1]+
        previousWater[i][j+1])/2 - 
        currentWater[i][j];

      currentWater[i][j] = currentWater[i][j] *dampening;
      int index = i+j*waterCols;
      waterRipple.pixels[index] = color(currentWater[i][j]*255);
    }
  }
  waterRipple.updatePixels();
  float [][] temp = previousWater;
  previousWater = currentWater;
  currentWater = temp;
  //waterRipple.filter(INVERT);
  waterRipple.endDraw();
}
