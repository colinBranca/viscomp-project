import processing.video.*;
import java.util.*;

PImage img;
PImage resultColor;
PImage resultSaturation;
PImage resultGauss;
PImage resultBinary;
PImage resultSobel;
PImage resultHough;

int nLines;

float discretizationStepsPhi = 0.06f;
float discretizationStepsR = 2.5f;
int rDim;
int phiDim;
int[] accumulator;

ArrayList<PVector> lines;
ArrayList<PVector> intersect;


float[][]gaussian = {{9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};


void settings() {
  size(1600, 800);
}

void setup() {
  img = loadImage("board1.jpg");
  img.resize(650, 500);

  resultColor = colorFilter(img, 80, 140);
  resultSaturation = saturationFilter(resultColor, 75, 255);
  resultGauss = convolute(resultSaturation, gaussian);
  resultBinary = binaryFilter(resultGauss, 25);
  resultSobel = sobel(resultBinary);

  //graph = new QuadGraph(hough.lines, img.width, img.height);
  //graph.findCycles();
}

void draw() {

  //image(resultSobel, width/2, 0);
  //image(resultHough, 0, 0);
  image(img, 0, 0);
  hough(resultSobel);
  resultHough = houghImage();
  noLoop();
}

void hough(PImage edgeImg) {

  phiDim = (int) (Math.PI / discretizationStepsPhi);
  rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  // our accumulator (with a 1 pix margin around)
  accumulator = new int[(phiDim + 2) * (rDim + 2)];

  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        for (int p=0; p<phiDim; p++) {
          int r = Math.round(x*cos(p) + y*sin(p));
          accumulator[(p+1)*(rDim+2) + (r + 1) + (rDim-1)/2]++;
        }
      }
    }
  }

  //PLOT THE LINE
  for (int idx = 0; idx < accumulator.length; idx++) {
    if (accumulator[idx] > 50) {
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
      println("x0 : " + x0);
      println("y0 : " + y0);
      println("x1 : " + x1);
      println("y1 : " + y1);
      println("x2 : " + x2);
      println("y2 : " + y2);
      println("x3 : " + x3);
      println("y3 : " + y3);
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
  //lines = bestLines(nLines);
  //intersections = getIntersections(lines);
}

PImage houghImage() {
  PImage img = createImage(rDim + 2, phiDim + 2, RGB);

  for (int i = 0; i < (rDim+2)*(phiDim+2); i++) {
    img.pixels[i] = color(min(255, accumulator[i]));
  }
  // You may want to resize the accumulator to make it easier to see:
  img.resize(400, 400);
  img.updatePixels();

  return img;
}