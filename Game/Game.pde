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
  fill(0, 102, 153);
  textSize(100);
  text(speed, 1, 1);
  fill(100, 100, 100);
  translate(width/2, height/2, 0);
  rotateX(alpha);
  rotateZ(beta);
  box(1000, 20, 1000);
}

float alpha = 0;
float beta = 0;

float pressedAlpha = 0;
float pressedBeta = 0;

float pressedMouseX = 0;
float pressedMouseY = 0;

float speed = 500;

void mousePressed() {
  pressedMouseY = mouseY;
  pressedAlpha = alpha;
  pressedMouseX = mouseX;
  pressedBeta = beta;
}

void mouseDragged() {
  alpha = pressedAlpha + (pressedMouseY - mouseY)/speed;
  alpha = between(alpha, -PI/3, PI/3);
  beta = pressedBeta + (pressedMouseX - mouseX)/speed;
  beta = between(beta, -PI/3, PI/3);
}

void mouseWheel(MouseEvent e) {
  speed += e.getCount(); 
  speed = between(speed, 0, 1000);
}

float between(float n, float min, float max) {
  if(n > max) {
    return max;
  }
  else if(n < min) {
    return min;
  }
  return n;
}