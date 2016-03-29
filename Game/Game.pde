Environment env = new Environment();

void settings() {
  size(800, 800, P3D);
}

void setup() {
  noStroke();

  env.mode = DEFAULT_MODE;

  env.plate = new ShapePlate(300, 10, 300);
  env.plate.fill(150, 150, 150);
  env.plate.rotSpeed = new BoundedFloat(50, 1, 100);
  env.plate.rotX = new BoundedFloat(0, - PI / 3, PI / 3);
  env.plate.rotY = new BoundedFloat(0, -90, 90);
  env.plate.rotZ = new BoundedFloat(0, - PI / 3, PI / 3);
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