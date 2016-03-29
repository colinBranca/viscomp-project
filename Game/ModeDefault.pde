Mode DEFAULT_MODE = new Mode() {
  final float TEXT_MARGIN = 5;
  final String FLOAT_FORMAT = "%7.2f";
  
  void draw(Environment env) {
    camera();
    fill(0, 102, 153);
    background(200);
    ambientLight(120, 120, 120);
    directionalLight(160, 160, 160, 0, 1, 0);
    
    debugText();

    translate(width/2, height/2, 0); // Draw plate at the center
    env.plate.draw();
  }

  void debugText() {
    textFont(createFont("Monospaced", 12));
    textAlign(LEFT, BOTTOM);
    text("RotationX:     " + env.plate.rotX.toDegrees().format(FLOAT_FORMAT) + "\n"
       + "RotationZ:     " + env.plate.rotZ.toDegrees().format(FLOAT_FORMAT) + "\n"
       + "RotationSpeed: " + env.plate.rotSpeed.format(FLOAT_FORMAT), 
          TEXT_MARGIN, height - TEXT_MARGIN, 0);
  }

  void update(Environment env) {
  };

  void keyReleased(Environment env) {
  };

  void mouseDragged(Environment env) {
    env.plate.rotate(pmouseY - mouseY, 0, mouseX - pmouseX);
  };

  void mouseClicked(Environment env) {
  };

  void mouseWheel(Environment env, MouseEvent event) {
    env.plate.addRotationSpeed(event.getCount());
  }
};