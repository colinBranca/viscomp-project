import java.util.*;
Hough hough;

final int IMAGE_WIDTH = 600;
final int IMAGE_HEIGHT = 450;

PImage img;
PImage resultHue;
PImage resultBrightness;
PImage resultSaturation;
PImage resultGauss;
PImage resultBinary;
PImage resultSobel;
PImage resultHough;

ArrayList<PVector> lines;
ArrayList<PVector> intersect = new ArrayList<PVector>();

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
  img = loadImage("board2.jpg");
  img.resize(IMAGE_WIDTH, IMAGE_HEIGHT);
  //image(img, 0, 0);

  resultHue = hueImage(img, 80, 140);
  resultBrightness = brightnessFilter(hueImage(img, 80, 140), 30, 170);
  resultSaturation = saturationFilter(resultBrightness, 75, 255);
  resultGauss = convolute(resultSaturation, gaussian);
  resultBinary = binaryFilter(resultGauss, 35);
  resultSobel = sobel(resultBinary);
  //image(resultSobel, IMAGE_WIDTH + IMAGE_HEIGHT, 0);;

  hough = new Hough(resultSobel, 6);
  resultHough = hough.getHoughImage();
  resultHough.resize(IMAGE_HEIGHT, IMAGE_HEIGHT);
  //image(resultHough, IMAGE_WIDTH, 0);

  //image(img, 0, IMAGE_HEIGHT);
  //hough.drawBestLines(0, IMAGE_HEIGHT);

  graph = new QuadGraph(hough.lines, img.width, img.height);
  graph.getIntersections(intersect);
  graph.drawListOfIntersections(intersect);
  //graph.drawMaxQuad(0, 0);
  
  //Rotation
  TwoDThreeD twoDthree = new TwoDThreeD(IMAGE_WIDTH, IMAGE_HEIGHT);
  PVector rot = twoDthree.get3DRotations(intersect);

  noLoop();
}