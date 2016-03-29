Environment env = new Environment();

void settings() {
  size(800, 800, P3D);
}

void setup() {
  noStroke();

  // Set default mode
  env.mode = DEFAULT_MODE;

  // Create plate
  env.plate = new ShapePlate(width/2, width/70, width/2);
  env.plate.fill(150, 150, 150);
  env.plate.rotSpeed = new BoundedFloat(50, 1, 100);
  env.plate.rotX = new BoundedFloat(0, - PI / 3, PI / 3);
  env.plate.rotZ = new BoundedFloat(0, - PI / 3, PI / 3);
  
  // Create ball and add to the plate
  ShapeBall ball = new ShapeBall(20, env.plate);
  env.plate.addChild(ball);
  
}

void draw() {
  env.mode.update(env);
  env.mode.draw(env);
}
void mouseDragged() {
  env.mode.mouseDragged(env);
}

void mouseWheel(MouseEvent event) {
  env.mode.mouseWheel(env, event);
}