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
  /*if (thresholdBar.getPos() != thresholdValue) {
    thresholdValue = thresholdBar.getPos();
    generateResult();
  }

  if (minHueBar.getPos() != minHueValue || maxHueBar.getPos() != maxHueValue) {
    minHueValue = minHueBar.getPos();
    maxHueValue = maxHueBar.getPos();
    hueImage();
  }

  PImage resultSobel = sobel(img);

  background(0, 0, 0);
  image(img, 0, 0);
  image(resultSobel, width/2, 0);
  image(result, 0, height/2); 
  image(resultHue, width/2, height/2);


  thresholdBar.display();
  thresholdBar.update();
  minHueBar.display();
  minHueBar.update();
  maxHueBar.display();
  maxHueBar.update();
  */
  
  hough(sobel(img));
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
    if (hue(img.pixels[i]) < minHueValue*255 ||  hue(img.pixels[i]) > maxHueValue*255) {
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
  loadPixels();

  PImage resultSob = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    resultSob.pixels[i] = color(0);
  }
  float max=0.f;
  float[] buffer = new float[img.width * img.height];
  // *************************************
  // Implement here the double convolution
  // *************************************

  //Convolution
  for ( int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      float sum_h = 0.f;
      float sum_v = 0.f;

      for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
          sum_h = sum_h + hKernel[i][j]*img.get(x-1+i, y-1+j); //convolution(img, hKernel, x, y);
          sum_v = sum_v + vKernel[i][j]*img.get(x-1+i, y-1+j); //convolution(img, vKernel, x, y);
        }
      }

      float sum = (float)sqrt(pow(sum_h, 2) + pow(sum_v, 2));

      buffer[y*img.width + x]=sum;
      if (max<sum) {
        max=sum;
      }
    }
  }

  //Store in the result
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        resultSob.pixels[y * img.width + x] = color(255);
      } else {
        resultSob.pixels[y * img.width + x] = color(0);
      }
    }
  }
  for (int i = 0; i < img.width * img.height; ++i) {
    if (hue(img.pixels[i]) < minHueValue*255 ||  hue(img.pixels[i]) > maxHueValue*255) {
      resultSob.pixels[i] = 0;
    }
  }
  resultSob.updatePixels();
  return resultSob;
}

void hough(PImage edgeImg) {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;

  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator with something like: r += (rDim - 1) / 2
        double phi = Math.atan((edgeImg.height-y)/x);
        double r = (rDim - 1) / 2 + x*Math.cos(phi) + (edgeImg.height-y)*Math.sin(phi);
        accumulator[(int)(phi*r)] = edgeImg.pixels[y * edgeImg.width + x];
      }
    }
  }
  
  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  // You may want to resize the accumulator to make it easier to see:
  // houghImg.resize(400, 400);
  houghImg.updatePixels();
}