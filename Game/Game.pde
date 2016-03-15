void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
}

float depth = 2000;

// Radius of ball
float ballRadius = 35;

PVector ballPosition = new PVector(0, -ballRadius, 0);

// Rotation arround X axis
float alpha = 0;

// Rotation arround Z axis
float beta = 0;

float pressedAlpha = 0;
float pressedBeta = 0;

float pressedMouseX = 0;
float pressedMouseY = 0;

// Speed of plate's rotation
float speed = 500;

// Gravity force
PVector gravityForce = new PVector();

// Gravity constant
float gravityConstant = 1;

// Velocity
PVector velocity = new PVector(0, 0, 0);

float boxWidth = 1000;
float boxHeight = 20;
float boxDepth = 1000;

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
  box(boxWidth, boxHeight, boxDepth);

  // Update gravity force
  gravityForce.x = sin(beta) * gravityConstant;
  gravityForce.z = -sin(alpha) * gravityConstant;

  float normalForce = 1;
  float mu = 0.3;
  float frictionMagnitude = normalForce * mu;
  PVector friction = velocity.copy();
  friction.mult(-1);
  friction.normalize();
  friction.mult(frictionMagnitude);

  velocity.add(gravityForce.add(friction));
  ballPosition.add(velocity);

  checkEdges();
  drawBall(ballPosition, ballRadius);
}

void checkEdges() {
  if (ballPosition.x > boxWidth/2 || ballPosition.x < -boxWidth/2) {
    velocity.x = velocity.x * -1;
    ballPosition.x = between(ballPosition.x, -boxWidth/2, boxWidth/2);
  }
  if (ballPosition.z > boxDepth/2 || ballPosition.z < - boxDepth/2) {
    velocity.z = velocity.z * -1;
    ballPosition.z = between(ballPosition.z, -boxDepth/2, boxDepth/2);
  }
}

void drawBall(PVector pos, float radius) {
  pushMatrix();
  fill(255, 100, 160);
  translate(pos.x, pos.y, pos.z);
  sphere(radius);
  popMatrix();
}

void mousePressed() {
  pressedMouseY = mouseY;
  pressedAlpha = alpha;
  pressedMouseX = mouseX;
  pressedBeta = beta;
}

void mouseDragged() {
  alpha = pressedAlpha + (pressedMouseY - mouseY)/speed;
  alpha = between(alpha, -PI/3, PI/3);
  beta = pressedBeta - (pressedMouseX - mouseX)/speed;
  beta = between(beta, -PI/3, PI/3);
}

void mouseWheel(MouseEvent e) {
  speed += e.getCount(); 
  speed = between(speed, 0, 1000);
}

float between(float n, float min, float max) {
  if (n > max) {
    return max;
  } else if (n < min) {
    return min;
  }
  return n;
}