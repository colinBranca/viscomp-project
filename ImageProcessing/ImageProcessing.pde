import java.util.*;
import processing.video.*;
Hough hough;

Capture cam;

final int IMAGE_WIDTH = 640;
final int IMAGE_HEIGHT = 360;

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
int[] bestQuad;

float[][]gaussian = {
  {9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}
};


void settings() {
  size(IMAGE_WIDTH + IMAGE_HEIGHT + IMAGE_WIDTH, IMAGE_HEIGHT);
}

void setup() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, 640, 360, 30);
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  img = cam.get();
  img.resize(IMAGE_WIDTH, IMAGE_HEIGHT);
  image(img, 0, 0);

  resultHue = hueImage(img, 80, 110);
  resultBrightness = brightnessFilter(resultHue, 100, 255);
  resultSaturation = saturationFilter(resultBrightness, 60, 255);
  resultGauss = convolute(resultSaturation, gaussian);
  resultBinary = binaryFilter(resultGauss, 35);
  resultSobel = sobel(resultBinary);
  image(resultSobel, IMAGE_WIDTH + IMAGE_HEIGHT, 0);
  
  hough = new Hough(resultSobel, 6);
  resultHough = hough.getHoughImage();
  resultHough.resize(IMAGE_HEIGHT, IMAGE_HEIGHT);
  image(resultHough, IMAGE_WIDTH, 0);

  graph = new QuadGraph(hough.lines, img.width, img.height);
  graph.drawMaxQuad(0, 0);
}