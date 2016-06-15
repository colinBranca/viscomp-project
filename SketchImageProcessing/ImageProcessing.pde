import java.util.*;

class ImageProcessing {

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

  public ImageProcessing(PImage img) {
    this.img = img;
    this.img.resize(IMAGE_WIDTH, IMAGE_HEIGHT);

    graph = new QuadGraph(hough.lines, img.width, img.height);
    graph.getIntersections(intersect);
    graph.drawListOfIntersections(intersect);
    //graph.drawMaxQuad(0, 0);

    //Rotation
    TwoDThreeD twoDthree = new TwoDThreeD(IMAGE_WIDTH, IMAGE_HEIGHT);
    PVector rot = twoDthree.get3DRotations(intersect);
  }
  
  Hough applyTransformations(PImage img){
    PImage resultBrightness = brightnessFilter(hueImage(img, 80, 140), 30, 170);
    PImage resultSaturation = saturationFilter(resultBrightness, 75, 255);
    PImage resultGauss = convolute(resultSaturation, gaussian);
    PImage resultBinary = binaryFilter(resultGauss, 35);
    PImage resultSobel = sobel(resultBinary);

    Hough hough = new Hough(resultSobel, 6);
    
    return hough;
  }
  
}