PImage img;
PImage result;
PImage resultHue;
HScrollbar thresholdBar;
float thresholdValue = 0;

void settings() {
  size(1600, 1200);
}

void setup() {
  img = loadImage("board1.jpg");
  thresholdBar = new HScrollbar(width/4, height/2 - 20, width/2, 20);
  //noLoop();
  // no interactive behaviour: draw() will be called only once.
  result = createImage(width/2, height/2, RGB);
  resultHue = createImage(width/2, height/2, RGB);
}

void draw() {
  if(thresholdBar.getPos() != thresholdValue) {
    thresholdValue = thresholdBar.getPos();
    generateResult();
  }
  
  background(0, 0, 0);
  image(img, width/4, 0);
  image(result, 0, height/2);
  image(resultHue, width/2, height/2);

  thresholdBar.display();
  thresholdBar.update();
}

void generateResult(){
  // create a new, initially transparent, 'result' image
  for (int i = 0; i < img.width * img.height; ++i) {
    if (brightness(img.pixels[i]) > thresholdValue * 255.0) {
      result.pixels[i] = 0xFFFFFF;
    } else {
      result.pixels[i] = 0;
    }
  }
  result.updatePixels();
}

void hue(){}