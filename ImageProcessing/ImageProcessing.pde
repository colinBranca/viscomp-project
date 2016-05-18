import processing.video.*;
Capture cam;

PImage img;
PImage camImg;
PImage result;
PImage resultHue;
PImage houghImg;
HScrollbar thresholdBar;
HScrollbar minHueBar;
HScrollbar maxHueBar;
float thresholdValue = 0;
float minHueValue = 0;
float maxHueValue = 0;


float[][]gaussian = {{9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};

void settings() {
  size(1600, 1000);
}

void setup() {

  //Webcam
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
  /* for older week
  thresholdBar = new HScrollbar(0, height/2 + 40, width/2, 20);
  minHueBar = new HScrollbar(width/2, height/2 + 20, width/2, 20);
  maxHueBar = new HScrollbar(width/2, height/2 + 60, width/2, 20);
  //noLoop();
  // no interactive behaviour: draw() will be called only once.
  result = createImage(width/2, height/2, ALPHA);
  resultHue = createImage(width/2, height/2, ALPHA);
  */
}

void draw() {
  /*for older week
  if (thresholdBar.getPos() != thresholdValue) {
    thresholdValue = thresholdBar.getPos();
    generateResult();
  }

  if (minHueBar.getPos() != minHueValue || maxHueBar.getPos() != maxHueValue) {
    minHueValue = minHueBar.getPos();
    maxHueValue = maxHueBar.getPos();
    hueImage();
  }
  */

  if (cam.available() == true) {
    cam.read();
  }
  //img = cam.get();
  img = loadImage("board1.jpg");

  PImage resultGauss = convolute(img, gaussian);
  PImage resultSobel = sobel(resultGauss);
  

  background(100, 100, 100);
  image(img, 0, 0);
  hough(resultSobel);
  
  /*
  image(result, 0, height/2); 
  image(resultHue, width/2, height/2);


  thresholdBar.display();
  thresholdBar.update();
  minHueBar.display();
  minHueBar.update();
  maxHueBar.display();
  maxHueBar.update();
  */
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
      if(max < sum_h) {
        max = sum_h;
      }
      if(max < sum_v) {
        max = sum_v;
      }
      
      float sum = sqrt(pow(sum_h, 2) + pow(sum_v, 2));

      buffer[y*img.width + x]=sum;
      
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) {
        resultSob.pixels[y * img.width + x] = 255;
      } else {
        resultSob.pixels[y * img.width + x] = 0;
      }
    }
  }
  
  resultSob.updatePixels();
  return resultSob;
}

PImage convolute(PImage img, float[][]kernel) {
  loadPixels();
  PImage convolution = createImage(img.width, img.height, ALPHA);

  for (int x=0; x<img.width; x++) {
    for (int y=0; y<img.width; y++) {
      float r = 0.0;
      float g = 0.0;
      float b = 0.0;
      float w = 0.0;
      for (int i=0; i<kernel.length; i++) {
        for (int j=0; j<kernel[i].length; j++) {
          r+=red(img.get(x+i-(kernel.length/2), y+j-(kernel.length/2)))*kernel[i][j];
          g+=green(img.get(x+i-(kernel.length/2), y+j-(kernel.length/2)))*kernel[i][j];
          b+=blue(img.get(x+i-(kernel.length/2), y+j-(kernel.length/2)))*kernel[i][j];
          w+=kernel[i][j];
        }
      }
      if(w==0) {
        w = 1.0;
      }
      convolution.set(x, y, color(r/w, g/w, b/w));
    }
  }
  convolution.updatePixels();
  return convolution;
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
        for (int p=0; p<phiDim; p++) {
          float phi = p*discretizationStepsPhi;
          float r = (float)(x*cos(phi) + y*sin(phi));

          accumulator[(rDim+2) + p*(rDim+2) + 1 + (int)Math.round(r/discretizationStepsR) + (rDim-1)/2]++;
        }
      }
    }
  }

  houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  // You may want to resize the accumulator to make it easier to see:
  houghImg.resize(400, 400);
  houghImg.updatePixels();

  for (int idx = 0; idx < accumulator.length; idx++) {
    if (accumulator[idx] > 200) {
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim + 2)) - 1;
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)
      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        } else
          line(x2, y2, x3, y3);
      }
    }
  }
}