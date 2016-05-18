public class Hough {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  int rDim;
  int phiDim;
  int[] accumulator;
  ArrayList<PVector> lines; 

  Hough(PImage edgeImg, int nLines) {
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
            //float phi = p*discretizationStepsPhi;
            int r = Math.round(x*cos(p) + y*sin(p));
            accumulator[(p+1)*(rDim+2) + r + 1 + (rDim-1)/2]++;
            //accumulator[(rDim+2) + p*(rDim+2) + 1 + r + (rDim-1)/2]++;
            //Math.round(r/discretizationStepsR)
          }
        }
      }
    }
    lines = bestLines(nLines);
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
        int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
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
      int accPhi = (int) (index / (rDim + 2)) - 1;
      int accR = index - (accPhi + 1) * (rDim + 2) - 1;
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;

      lines.add(new PVector(r, phi));
    }
    return lines;
  }
}