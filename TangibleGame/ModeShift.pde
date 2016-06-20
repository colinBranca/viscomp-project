class ModeShift extends Mode {
  final float CYLINDER_RADIUS     = 25;
  final float CYLINDER_HEIGHT     = 50;
  final int   CYLINDER_RESOLUTION = 50;
  final color CYLINDER_COLOR      = color(0, 255, 255);

  ModeShift(Environment env, int width, int height, int x, int y) {
    super(env, width, height, x, y, P3D);
  }

  BoundedFloat plateRotXBefore;
  BoundedFloat plateRotZBefore;

  void enter() {
    isActive = true;
    plateRotXBefore = env.plate.rotX;
    plateRotZBefore = env.plate.rotZ;
    env.plate.rotX = new BoundedFloat(-HALF_PI, -HALF_PI, -HALF_PI);
    env.plate.rotZ = new BoundedFloat(0, 0, 0);
  }

  void exit() {
    isActive = false;
    env.plate.rotX = plateRotXBefore;
    env.plate.rotZ = plateRotZBefore;
  }

  void draw() {
    surface.beginDraw();
    surface.ortho();
    surface.background(255, 255, 255);
    surface.lights();

    surface.translate(width/2, height/2, 0); // Draw plate at the center
    env.plate.draw(surface);
    surface.endDraw();
    super.draw();
  }

  void mouseClicked() {
    PVector pos = new PVector(
      constrain(mouseX - width/2, -env.plate.width/2 + CYLINDER_RADIUS, env.plate.width/2 - CYLINDER_RADIUS), 
      constrain(mouseY - height/2, -env.plate.depth/2 + CYLINDER_RADIUS, env.plate.depth/2 - CYLINDER_RADIUS)
      );

    ShapeCylinder cylinder = new ShapeCylinder(CYLINDER_RADIUS, CYLINDER_HEIGHT, CYLINDER_RESOLUTION, pos, env.plate);
    cylinder.fill(CYLINDER_COLOR);

    env.plate.addCylinder(cylinder);
  }
};