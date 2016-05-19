public class Hough {
  PImage edgeImg;
  int nLines;

  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  int rDim;
  int phiDim;
  int[] accumulator;
  ArrayList<PVector> lines;
  ArrayList<PVector> intersections;

  Hough(PImage edgeImg, int nLines) {
    this.edgeImg = edgeImg;
    this.nLines = nLines;

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
            float phi = p*discretizationStepsPhi;
            int r = Math.round((x*cos(phi) + y*sin(phi))/discretizationStepsR);
            accumulator[(p+1)*(rDim+2) + r + 1 + (rDim-1)/2]++;
          }
        }
      }
    }
    lines = bestLines(nLines);
    intersections = getIntersections(lines);
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

  ArrayList<PVector> bestLines(int n) {
    ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
    ArrayList<PVector> lines= new ArrayList<PVector>();
    // size of the region we search for a local maximum
    int neighbourhood = 10;
    // only search around lines with more that this amount of votes
    // (to be adapted to your image)
    int minVotes = 200;
    for (int accR = 0; accR < rDim; accR++) {
      for (int accPhi = 0; accPhi < phiDim; accPhi++) {
        // compute current index in the accumulator
        int idx = (accPhi + 1) * (rDim + 2) + accR + 1 +(rDim-1)/2;
        if (accumulator[idx] > minVotes) {
          boolean bestCandidate=true;
          // iterate over the neighbourhood
          for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
            // check we are not outside the image
            if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
            for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
              // check we are not outside the image
              if (accR+dR < 0 || accR+dR >= rDim) continue;
              int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
              if (accumulator[idx] < accumulator[neighbourIdx]) {
                // the current idx is not a local maximum!
                bestCandidate=false;
                break;
              }
            }
            if (!bestCandidate) break;
          }
          if (bestCandidate) {
            // the current idx *is* a local maximum
            bestCandidates.add(idx);
          }
        }
      }
    }

    Collections.sort(bestCandidates, new HoughComparator(accumulator));

    for (int i=0; i<Math.min(n, bestCandidates.size()); i++) {
      int index = bestCandidates.get(i);
      //int accPhi = (int) (index / (rDim + 2)) - 1;
      for (int p=0; p<phiDim; p++) {
        
        int accR = index - (p + 1) * (rDim + 2) - 1 - (rDim-1)/2;
        float r = accR * discretizationStepsR;
        float phi = p * discretizationStepsPhi;

        lines.add(new PVector(r, phi));
      }
    }
    return lines;
  }

  void drawLines() {
    for (int i=0; i<lines.size(); i++) {
      PVector vect = lines.get(i);
      float r = vect.x;
      float phi = vect.y;

      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) ((-cos(phi) / sin(phi)) * x2 + (r / sin(phi)));
      int y3 = edgeImg.height;
      int x3 = (int) (((r/sin(phi))-y3)*(sin(phi)/cos(phi)));

      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0 && y0<edgeImg.height) {
        if (x1 > 0 && x1<edgeImg.width)
          line(x0, y0, x1, y1);
        else if (y2 > 0 && y2<edgeImg.height)
          line(x0, y0, x2, y2);
        else {
          if (x3>0 && x3<edgeImg.width)
            line(x0, y0, x3, y3);
        }
      } else {
        if (x1 > 0 && x1<img.width) {
          if (y2 > 0 && y2<img.height)
            line(x1, y1, x2, y2);
          else {
            if (x3 > 0 && x3<img.width)
              line(x1, y1, x3, y3);
          }
        } else {
          if (y2 > 0 && y2<edgeImg.height && x3>0 && x3<edgeImg.width)
            line(x2, y2, x3, y3);
        }
      }
    }
  }
}