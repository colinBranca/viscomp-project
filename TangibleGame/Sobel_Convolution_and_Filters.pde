final color WHITE = color(255);
final color BLACK = color(0);

void sobel(PImage img) {
  float[][] hKernel = {
    { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 }
  };

  float[][] vKernel = { 
    { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 }
  };
  
  int[] result = new int[img.pixels.length];
  // clear the image
  for (int i = 0; i < img.pixels.length; i++) {
    result[i] = BLACK;
  }
  
  float max=0.f;
  float[] buffer = new float[img.width * img.height];

  //Convolution
  for ( int x = 1; x < img.width - 1; x++) {
    for (int y = 1; y < img.height - 1; y++) {
      float sum_h = 0.f;
      float sum_v = 0.f;

      for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
          sum_h = sum_h + hKernel[i][j] * img.get(x-1+i, y-1+j);
          sum_v = sum_v + vKernel[i][j] * img.get(x-1+i, y-1+j);
        }
      }

      float sum = pow(sum_h, 2) + pow(sum_v, 2);
      if (max<sum) max = sum;

      buffer[y*img.width + x] = sum;

      if (buffer[y * img.width + x] > (int)(max * 0.3f)) {
        result[y * img.width + x] = color(255);
      } else {
        result[y * img.width + x] = color(0);
      }
    }
  }
  img.pixels = result;
}

void colorFilters(PImage img, int hueMin, int hueMax, int brightnessMin, int brightnessMax, int saturationMin, int saturationMax) {
  for (int i = 0; i != img.pixels.length; ++i) {
    int pixel = img.pixels[i];

    // Filter hue
    float hue = hue(pixel);
    if (hue < hueMin || hue > hueMax) {
      img.pixels[i] = BLACK;
      continue;
    }

    // Filter brightness
    float brightness = brightness(pixel);
    if (brightness < brightnessMin || brightness > brightnessMax) {
      img.pixels[i] = BLACK;
      continue;
    }

    // Filter saturation
    float saturation = saturation(pixel);
    if (saturation < saturationMin || saturation > saturationMax) {
      img.pixels[i] = BLACK;
      continue;
    }
  }
}

void convolute(PImage img, float[][] kernel) {
  int[] result = new int[img.pixels.length];
  for (int x = 0; x != img.width; ++x) {
    for (int y = 0; y != img.height; ++y) {
      float r = 0;
      float g = 0;
      float b = 0;
      float w = 0;
      
      for (int i = 0; i != kernel.length; ++i) {
        for (int j = 0; j != kernel[i].length; ++j) {
          int pixel = img.get(x + i - (kernel.length/2), y + j - (kernel.length/2));
          r += red(pixel) * kernel[i][j];
          g += green(pixel) * kernel[i][j];
          b += blue(pixel) * kernel[i][j];
          w += kernel[i][j];
        }
      }
      
      if (w == 0) {
        w = 1;
      }
      
      result[x + y * img.width] = color(r/w, g/w, b/w);
    }
  }
  img.pixels = result;
}

void binaryFilter(PImage img, int threshold) {
  for (int i = 0; i < img.pixels.length; ++i) {
    if (brightness(img.pixels[i]) >= threshold) {
      img.pixels[i] = WHITE;
    } else {
      img.pixels[i] = BLACK;
    }
  }
}