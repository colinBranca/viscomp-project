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

  //Convolution
  for ( int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      float sum_h = 0.f;
      float sum_v = 0.f;

      for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
          sum_h = sum_h + hKernel[i][j]*img.get(x-1+i, y-1+j);
          sum_v = sum_v + vKernel[i][j]*img.get(x-1+i, y-1+j);
        }
      }

      float sum = pow(sum_h, 2) + pow(sum_v, 2);
      if (max<sum) max = sum;

      buffer[y*img.width + x] = sum;

      if (buffer[y * img.width + x] > (int)(max * 0.3f)) {
        resultSob.pixels[y * img.width + x] = color(255);
      } else {
        resultSob.pixels[y * img.width + x] = color(0);
      }
    }
  }

  updatePixels();
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
  updatePixels();
  return convolution;
}

PImage saturationFilter(PImage img, int min, int max) {
  loadPixels();
  PImage sat = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (saturation(img.pixels[i]) >= min && saturation(img.pixels[i]) <= max) {
      sat.pixels[i] = img.pixels[i];
    } else {
      sat.pixels[i] = color(0);
    }
  }
  updatePixels();
  return sat;
}

PImage colorFilter(PImage img, int min, int max) {
  loadPixels();
  PImage col = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (hue(img.pixels[i]) >= min && hue(img.pixels[i]) <= max) {
      col.pixels[i] = img.pixels[i];
    } else {
      col.pixels[i] = color(0);
    }
  }
  updatePixels();
  return col;
}

PImage binaryFilter(PImage img, int threshold) {
  loadPixels();
  PImage  binary = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) >= threshold) {
      binary.pixels[i] = color(255);
    } else {
      binary.pixels[i] = color(0);
    }
  }
  updatePixels();
  return binary;
}