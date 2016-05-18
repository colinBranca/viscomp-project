import processing.video.*;
import java.util.*;
Capture cam;
Hough hough;

PImage img;
PImage camImg;
PImage result;
PImage resultHue;
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
  /*String[] cameras = Capture.list();
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
   }*/
  //for older week
  thresholdBar = new HScrollbar(0, height/2 + 40, width/2, 20);
  minHueBar = new HScrollbar(width/2, height/2 + 20, width/2, 20);
  maxHueBar = new HScrollbar(width/2, height/2 + 60, width/2, 20);
  //noLoop();
  // no interactive behaviour: draw() will be called only once.
  result = createImage(width/2, height/2, ALPHA);
  resultHue = createImage(width/2, height/2, ALPHA);
}

void draw() {
    img = loadImage("board1.jpg");

  /*for older week
  if (thresholdBar.getPos() != thresholdValue) {
    thresholdValue = thresholdBar.getPos();
    generateResult();
  }

  if (minHueBar.getPos() != minHueValue || maxHueBar.getPos() != maxHueValue) {
    minHueValue = minHueBar.getPos();
    maxHueValue = maxHueBar.getPos();
    hueImage();
  }*/


  /*if (cam.available() == true) {
   cam.read();
   }
   img = cam.get();*/
  
  background(100, 100, 100);
  
  image(img, width/2, 0);

  PImage resultGauss = convolute(img, gaussian);
  PImage resultSobel = sobel(resultGauss);
  
  hough = new Hough(resultSobel, 10);
  PImage resultHough = hough.houghImage();
  image(resultHough, 0, 0);

  /*image(result, 0, height/2); 
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
      if (max < sum_h) {
        max = sum_h;
      }
      if (max < sum_v) {
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
      if (w==0) {
        w = 1.0;
      }
      convolution.set(x, y, color(r/w, g/w, b/w));
    }
  }
  convolution.updatePixels();
  return convolution;
}