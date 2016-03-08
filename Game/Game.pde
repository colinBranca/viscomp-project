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
  box(1000, 20, 1000);
}

float rx = 0;
float rz = 0;
float currentX = 0;
float currentY = 0;

void mousePressed() {
  currentX = mouseX;
  currentY = mouseY;
}

void mouseDragged() {
  rx = map(currentX - mouseX, -width, width, -PI/3, PI/3);
  rz = map(currentY - mouseY, -height, height, -PI/3, PI/3);
}