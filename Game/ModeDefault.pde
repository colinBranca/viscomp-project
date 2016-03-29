Mode DEFAULT_MODE = new Mode() {
  final float TEXT_MARGIN = 5;
  final String FLOAT_FORMAT = "%7.2f";
  
  void draw(Environment env) {
    camera();
    background(255);
    lights();
    
    debugText();

    translate(width/2, height/2, 0); // Draw plate at the center
    env.plate.update();
    env.plate.draw();
  }

  void debugText() {
    pushStyle();
    fill(0, 0, 0);
    textFont(createFont("Monospaced", 12));
    textAlign(LEFT, BOTTOM);
    text("RotationX:     " + env.plate.rotX.toDegrees().format(FLOAT_FORMAT) + "\n"
       + "RotationZ:     " + env.plate.rotZ.toDegrees().format(FLOAT_FORMAT) + "\n"
       + "RotationSpeed: " + env.plate.rotSpeed.format(FLOAT_FORMAT), 
          TEXT_MARGIN, height - TEXT_MARGIN, 0);
    popStyle();
  }

  void update(Environment env) {
  };

  void keyReleased(Environment env) {
  };

  void mouseDragged(Environment env) {
    env.plate.rotate(pmouseY - mouseY, mouseX - pmouseX);
  };

  void mouseClicked(Environment env) {
  };

  void mouseWheel(Environment env, MouseEvent event) {
    env.plate.addRotationSpeed(event.getCount());
  }
};