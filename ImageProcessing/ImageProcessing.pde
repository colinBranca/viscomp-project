PImage img;
PImage result;
PImage resultHue;
HScrollbar thresholdBar;
HScrollbar minHueBar;
HScrollbar maxHueBar;
float thresholdValue = 0;
float minHueValue = 0;
float maxHueValue = 0;

void settings() {
  size(1600, 1200);
}

void setup() {
  img = loadImage("board1.jpg");
  thresholdBar = new HScrollbar(0, height/2 + 40, width/2, 20);
  minHueBar = new HScrollbar(width/2, height/2 + 20, width/2, 20);
  maxHueBar = new HScrollbar(width/2, height/2 + 60, width/2, 20);
  //noLoop();
  // no interactive behaviour: draw() will be called only once.
  result = createImage(width/2, height/2, RGB);
  resultHue = createImage(width/2, height/2, RGB);
}

void draw() {
  if (thresholdBar.getPos() != thresholdValue) {
    thresholdValue = thresholdBar.getPos();
    generateResult();
  }

  if (minHueBar.getPos() != minHueValue || maxHueBar.getPos() != maxHueValue) {
    minHueValue = minHueBar.getPos();
    maxHueValue = maxHueBar.getPos();
    hueImage();
  }

  background(0, 0, 0);
  image(img, width/4, 0);
  image(sobel(img), 0, height/2);
  image(resultHue, width/2, height/2);

  thresholdBar.display();
  thresholdBar.update();
  minHueBar.display();
  minHueBar.update();
  maxHueBar.display();
  maxHueBar.update();
}

void generateResult() {
  // create a new, initially transparent, 'result' image
  for (int i = 0; i < img.width * img.height; ++i) {
    if (brightness(img.pixels[i]) > thresholdValue * 255.0) {
      result.pixels[i] = 0xFFFFFF;
    } else {
      result.pixels[i] = 0;
    }
  }
  result.updatePixels();
}

void hueImage() {
  for (int i = 0; i < img.width * img.height; ++i) {
    if (hue(img.pixels[i]) < minHueValue*255 ||  hue(img.pixels[i]) > maxHueValue*255) { //deux Hbar car il doit etre compris entre deux trucs!
      resultHue.pixels[i] = 0;
    } else {
      resultHue.pixels[i] = img.pixels[i];
    }
  }
  resultHue.updatePixels();
}


PImage sobel(PImage img) {
  float[][] hKernel = { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0.f;
  float[] buffer = new float[img.width * img.height];
  // *************************************
  // Implement here the double convolution
  // *************************************
  float sum_h = 0.f;
  float sum_v = 0.f;
<<<<<<< HEAD
  for ( int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      for ( int range = -1; range <= 1; range++) {
        int pX = x+range;
        int pY = y+range;
      }
    }
  }


=======
  
  //Convolution
  for( int x = 0; x < img.width; x++){
    for(int y = 0; y < img.height; y++){
      sum_h = sum_h + convolution(img, hKernel, x, y);
      sum_v = sum_v + convolution(img, vKernel, x, y);
      float sum = (float)sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      
      buffer[x*img.width + y]=sum;
      if(max<sum){
        max=sum;
      }
    }
  }
  
  //Store in the result
>>>>>>> origin/Week08
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}

<<<<<<< HEAD
float convolution(float x, float y) {
  float result = 0.f;


=======
float convolution(PImage img, float[][]k, int x, int y){
  float result = 0.f;
  
  for(int i=-1; i<=1; i++){
    for(int j=-1; j<=1; j++){
      int px = x+i;
      int py = y+i;
      if(!(px<0 || py<0)){
        result = result + (k[i][j]*img.pixels[img.width*px + py]);
      }
    }
  }
  
>>>>>>> origin/Week08
  return result;
}