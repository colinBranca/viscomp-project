Mode DEFAULT_MODE = new Mode() {
  final float TEXT_MARGIN = 5;
  final String FLOAT_FORMAT = "%7.2f";
  
  void enter(Environment env) {
    perspective();
  }
  
  void draw(Environment env) {
    background(255);
    lights();
    
    debugText();

    translate(width/2, height/2, 0); // Draw plate at the center
    env.plate.draw();
  }

  void debugText() {
    pushStyle();
    fill(0, 0, 0);
    textFont(createFont("Monospaced", 12));
    textAlign(LEFT, BOTTOM);
    text(
      "frameRate:     " + frameRate + "\n"
       + "RotationX:     " + env.plate.rotX.toDegrees().format(FLOAT_FORMAT) + "\n"
       + "RotationZ:     " + env.plate.rotZ.toDegrees().format(FLOAT_FORMAT) + "\n"
       + "RotationSpeed: " + env.plate.rotSpeed.format(FLOAT_FORMAT), 
          TEXT_MARGIN, height - TEXT_MARGIN, 0);
    popStyle();
  }

  void update(Environment env) {
    env.plate.update();
  }
  
  void keyPressed(Environment env) {
    if (key == CODED && keyCode == SHIFT) {
      env.switchMode(ADD_CYLINDERS_MODE);
    }
  }

  void mouseDragged(Environment env) {
    env.plate.rotate(pmouseY - mouseY, mouseX - pmouseX);
  }

  void mouseWheel(Environment env, MouseEvent event) {
    env.plate.addRotationSpeed(event.getCount());
  }
};