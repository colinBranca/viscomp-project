import processing.video.*;
import java.util.*;
Capture cam;
Hough hough;

PImage img;
PImage resultHue;
PImage resultBrightness;
PImage resultSaturation;
PImage resultGauss;
PImage resultBinary;
PImage resultSobel;
PImage resultHough;

ArrayList<PVector> lines;
ArrayList<PVector> intersect;

QuadGraph graph;
List<int[]> quads;

float[][]gaussian = {{9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};


void settings() {
  size(1600, 1000);
}

void setup() {
  img = loadImage("board1.jpg");
  img.resize(640, 480);
  image(img, 0, 0);

  resultHue = hueImage(img, 80, 140);
  resultBrightness = brightnessFilter(resultHue, 30, 170);
  resultSaturation = saturationFilter(resultBrightness, 75, 255);
  resultGauss = convolute(resultSaturation, gaussian);
  resultBinary = binaryFilter(resultGauss, 35);
  resultSobel = sobel(resultBinary);

  hough = new Hough(resultSobel, 6);
  resultHough = hough.houghImage();

  image(resultSobel, width/2, 0);
  image(resultHough, 0, height/2);
  hough.drawLines();

  graph = new QuadGraph(hough.lines, img.width, img.height);
  quads = graph.findCycles();

  for (int[] quad : quads) {
    for (int i=0; i<quad.length; i++) {

      print(i + ") " + quad[i]);
    }
  }

  noLoop();
}