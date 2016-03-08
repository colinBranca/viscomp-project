void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
}

float depth = 2000;
void draw() {
  camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  rotateX(rx);
  rotateZ(rz);
  box(500, 20, 500);
}

float rx = 0;
float rz = 0;
void mouseDragged() {
  rx = map(mouseX, 0, width/2, 0, PI/3);
  rz = map(mouseY, 0, height/2, 0, PI/3); 
}