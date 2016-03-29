Mode ADD_CYLINDERS_MODE = new Mode() {
  final float CYLINDER_RADIUS     = 25;
  final float CYLINDER_HEIGHT     = 50;
  final int   CYLINDER_RESOLUTION = 50;
  final color CYLINDER_COLOR      = color(0, 255, 255);
  
  BoundedFloat plateRotXBefore;
  BoundedFloat plateRotZBefore;
  
  void enter(Environment env) {
    ortho();
    plateRotXBefore = env.plate.rotX;
    plateRotZBefore = env.plate.rotZ;
    env.plate.rotX = new BoundedFloat(-HALF_PI, -HALF_PI, -HALF_PI);
    env.plate.rotZ = new BoundedFloat(0, 0, 0);
  }
  
  void exit(Environment env) {
    env.plate.rotX = plateRotXBefore;
    env.plate.rotZ = plateRotZBefore;
  }
  
  void draw(Environment env) {
    background(255, 255, 255);
    lights();

    translate(width/2, height/2, 0); // Draw plate at the center
    env.plate.draw();
  }

  void keyReleased(Environment env) {
    if (key == CODED && keyCode == SHIFT) {
      env.switchMode(DEFAULT_MODE);
    }
  }
  
  void mouseClicked(Environment env) {
    PVector pos = new PVector(
      constrain(mouseX - width/2, -env.plate.width/2 + CYLINDER_RADIUS, env.plate.width/2 - CYLINDER_RADIUS),
      constrain(mouseY - height/2, -env.plate.depth/2 + CYLINDER_RADIUS, env.plate.depth/2 - CYLINDER_RADIUS)
    );
    
    ShapeCylinder cylinder = new ShapeCylinder(CYLINDER_RADIUS, CYLINDER_HEIGHT, CYLINDER_RESOLUTION, pos, env.plate);
    cylinder.fill(CYLINDER_COLOR);
    
    env.plate.addCylinder(cylinder);
  }
};