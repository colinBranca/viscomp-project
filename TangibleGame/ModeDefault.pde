class ModeDefault extends Mode {
  final float TEXT_MARGIN = 5;
  final String FLOAT_FORMAT = "%7.2f";
  final PFont TEXT_FONT = createFont("Monospaced", 12);
  final float[][] gaussian = {
    {9, 12, 9}, 
    {12, 15, 12}, 
    {9, 12, 9}
  };
  boolean pressed = false;
  List<PVector> quad;
  PImage img;

  ModeDefault(Environment env, int width, int height, int x, int y) {
    super(env, width, height, x, y, P3D);
  }

  void draw() {
    surface.beginDraw();
    surface.perspective();
    surface.background(255, 255, 255);
    surface.lights();

    debugText();
    debugImg();

    surface.translate(width/2, height/2, 0); // Draw plate at the center
    env.plate.draw(surface);
    surface.endDraw();
    super.draw();
  }

  void debugImg() {
    surface.image(env.cam.get(), 0, 0, 200, 150);
    img.updatePixels();
    surface.image(img, 200, 0, 200, 150);
    
    if (quad != null) {
      surface.pushStyle();
      surface.fill(color(255, 255, 0));

      for (PVector p : quad) {
        surface.ellipse(map(p.x, 0, img.width, 200, 400), map(p.y, 0, img.height, 0, 150), 10, 10);
      }

      surface.popStyle();
    }
  }

  void debugText() {
    surface.pushStyle();
    surface.fill(0, 0, 0);
    surface.textFont(TEXT_FONT);
    surface.textAlign(LEFT, BOTTOM);
    surface.text(
      "frameRate:     " + frameRate + "\n"
      + "RotationX:     " + env.plate.rotX.toDegrees().format(FLOAT_FORMAT) + "\n"
      + "RotationZ:     " + env.plate.rotZ.toDegrees().format(FLOAT_FORMAT) + "\n"
      + "RotationSpeed: " + env.plate.rotSpeed.format(FLOAT_FORMAT) + "\n"
      + "Max Score:     " + String.format(FLOAT_FORMAT, env.score.max), 
      TEXT_MARGIN, height - TEXT_MARGIN, 0);
    surface.popStyle();
  }

  void update() {
    updateRotation();
    env.plate.update();

    if (frameCount % 40 == 0) {
      env.score.save();
    }
  }

  void mouseWheel(MouseEvent event) {
    env.plate.addRotationSpeed(event.getCount());
  }

  void mousePressed() {
    pressed = true;
  }

  void mouseReleased() {
    pressed = false;
  }

  void updateRotation() {
    img = env.cam.get();
    img.loadPixels();
    colorFilters(img, 85, 125, 35, 210, 75, 255);
    convolute(img, gaussian);
    binaryFilter(img, 35);
    sobel(img);

    Hough hough = new Hough(img, 6);
    QuadGraph graph = new QuadGraph(hough.lines, img.width, img.height);
    
    quad = graph.getMaxQuad();
    TwoDThreeD projection = new TwoDThreeD(img.width, img.height);

    if (quad != null) {
      PVector rotation = projection.get3DRotations(sortCorners(quad));
      env.plate.rotX = new BoundedFloat(rotation.x, - PI / 3, PI / 3);
      env.plate.rotZ = new BoundedFloat(rotation.y, - PI / 3, PI / 3);
    }
  }
};