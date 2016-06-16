Environment env = new Environment();
Mode world;

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();

  // Create plate
  env.plate = new ShapePlate(width/3, width/70, width/3);
  env.plate.fill(color(150, 150, 150, 120));
  env.plate.rotSpeed = new BoundedFloat(50, 1, 100);
  env.plate.rotX = new BoundedFloat(0, - PI / 3, PI / 3);
  env.plate.rotZ = new BoundedFloat(0, - PI / 3, PI / 3);

  // Create ball
  env.plate.ball = new ShapeBall(20, env.plate);
  env.plate.ball.fill(255, 180, 255);

  env.score = new Score(env);

  env.chartZoom = new BoundedFloat(6, 1, 11);

  world = new ModeWorld(env, width, height, 0, 0);
}

void draw() {
  world.update();
  world.draw();
}

void keyPressed() {
  world.keyPressed();
};

void keyReleased() {
  world.keyReleased();
};

void mouseDragged() {
  world.mouseDragged();
}

void mouseWheel(MouseEvent event) {
  world.mouseWheel(event);
}

void mouseClicked() {
  world.mouseClicked();
}

void mousePressed() {
  world.mousePressed();
}

void mouseReleased() {
  world.mouseReleased();
}