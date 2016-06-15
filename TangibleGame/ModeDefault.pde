class ModeDefault extends Mode {
  final float TEXT_MARGIN = 5;
  final String FLOAT_FORMAT = "%7.2f";
  final PFont TEXT_FONT = createFont("Monospaced", 12);
  boolean pressed = false;

  ModeDefault(Environment env, int width, int height, int x, int y) {
    super(env, width, height, x, y, P3D);
  }

  void draw() {
    surface.beginDraw();
    surface.perspective();
    surface.background(255, 255, 255);
    surface.lights();

    debugText();

    surface.translate(width/2, height/2, 0); // Draw plate at the center
    env.plate.draw(surface);
    surface.endDraw();
    super.draw();
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
    env.plate.update();

    if (frameCount % 40 == 0) {
      env.score.save();
    }
  }

  void mouseDragged() {
    if (pressed) {
      env.plate.rotate(pmouseY - mouseY, mouseX - pmouseX);
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
};