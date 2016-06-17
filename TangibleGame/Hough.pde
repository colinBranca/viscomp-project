public class Hough {
  // size of the region we search for a local maximum
  static final int neighbourhood = 10;

  // only search around lines with more that this amount of votes
  // (to be adapted to your image)
  static final int minVotes = 100;

  static final float discretizationStepsPhi = 0.06f;
  static final float discretizationStepsR = 2.5f;

  PImage edgeImg;
  int nLines;
  int rDim;
  int phiDim;
  
  int[] accumulator;
  ArrayList<PVector> lines;
  ArrayList<PVector> intersections;

  Hough(PImage edgeImg, int nLines) {
    this.edgeImg = edgeImg;
    this.nLines = nLines;
    this.phiDim = (int) (Math.PI / discretizationStepsPhi);
    this.rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

    fillAccumulator();
    findBestLines();
  }

  /**
   * Fill the accumulator
   * Assignment 9, Step 2
   */
  void fillAccumulator() {
    // our accumulator (with a 1 pix margin around)
    accumulator = new int[(phiDim + 2) * (rDim + 2)];

    // Fill the accumulator: on edge points (ie, white pixels of the edge
    // image), store all possible (r, phi) pairs describing lines going
    // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
      for (int x = 0; x < edgeImg.width; x++) {
        // Are we on an edge?
        if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
          for (int p = 0; p < phiDim; p++) {
            float phi = p * discretizationStepsPhi;
            int r = Math.round((x * cos(phi) + y * sin(phi)) / discretizationStepsR);
            accumulator[(p + 1) * (rDim + 2) + (r + 1) + (rDim - 1) / 2] += 1;
          }
        }
      }
    }
  }

  PImage getHoughImage() {
    PImage img = createImage(rDim + 2, phiDim + 2, RGB);

    for (int i = 0; i < accumulator.length; i++) {
      img.pixels[i] = color(min(255, accumulator[i]));
    }

    img.updatePixels();

    return img;
  }

  void findBestLines() {
    lines = new ArrayList<PVector>();
    ArrayList<Integer> bestCandidates = new ArrayList<Integer>();

    for (int accR = 0; accR < rDim; accR++) {
      for (int accPhi = 0; accPhi < phiDim; accPhi++) {
        // compute current index in the accumulator
        int idx = (accPhi + 1) * (rDim + 2) + accR + 1 +(rDim-1)/2;

        if (accumulator[idx] > minVotes) {
          boolean bestCandidate = true;

          // iterate over the neighbourhood
          for (int dPhi = -neighbourhood / 2; dPhi < neighbourhood / 2 + 1; dPhi++) {
            // check we are not outside the image
            if ( accPhi + dPhi < 0 || accPhi + dPhi >= phiDim) {
              continue;
            }

            for (int dR = -neighbourhood / 2; dR < neighbourhood / 2 + 1; dR++) {
              // check we are not outside the image
              if (accR + dR < 0 || accR + dR >= rDim) {
                continue;
              }

              int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;

              if (accumulator[idx] < accumulator[neighbourIdx]) {
                // the current idx is not a local maximum!
                bestCandidate = false;
                break;
              }
            }

            if (!bestCandidate) {
              break;
            }
          }

          if (bestCandidate) {
            // the current idx *is* a local maximum
            bestCandidates.add(idx);
          }
        }
      }
    }

    Collections.sort(bestCandidates, new HoughComparator(accumulator));

    int iMax = Math.min(nLines, bestCandidates.size());

    for (int i = 0; i < iMax; i++) {
      int index = bestCandidates.get(i);
      int accPhi = (int) (index / (rDim + 2)) - 1;
      int accR = index - (accPhi + 1) * (rDim + 2) - 1;
      float r = (accR - (rDim - 1) / 2) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      lines.add(new PVector(r, phi));
    }
  }
}

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }

  @Override public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2] || (accumulator[l1] == accumulator[l2] && l1 < l2)) {
      return -1;
    }
    return 1;
  }
}