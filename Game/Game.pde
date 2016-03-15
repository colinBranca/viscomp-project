Plate plate;

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
  camera();
  
  plate = new Plate(300, 10, 300);
  plate.fill(0, 256, 256);
  plate.setRotSpeed(50.0);
  plate.setRotateXBounds(- PI / 3, PI / 3);
}

void draw() {
  background(200);
  directionalLight(120, 120, 120, 0, 1, 0);
  ambientLight(120, 120, 120);
  translate(width/2, height/2, 0);
  
  plate.draw();
}

void mouseDragged() {
  plate.rotateX(pmouseY - mouseY);
}