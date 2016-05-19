import processing.video.*;
import java.util.*;
Capture cam;
Hough hough;

PImage img;
PImage resultColor;
PImage resultSaturation;
PImage resultGauss;
PImage resultBinary;
PImage resultSobel;
PImage resultHough;

ArrayList<PVector> lines;
ArrayList<PVector> intersect;

float[][]gaussian = {{9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};


void settings() {
  size(1600, 1000);
}

void setup() {
  img = loadImage("board1.jpg");
  img.resize(640, 480);

  resultColor = colorFilter(img, 80, 140);
  resultSaturation = saturationFilter(resultColor, 75, 255);
  resultGauss = convolute(resultSaturation, gaussian);
  resultBinary = binaryFilter(resultGauss, 35);
  resultSobel = sobel(resultBinary);

  hough = new Hough(resultSobel, 6);
  resultHough = hough.houghImage();
}

void draw() {
  background(100, 100, 100);
  image(img, 0, 0);
  image(resultSobel, width/2, 0);
  image(resultHough, 0, height/2);

  noLoop();
}