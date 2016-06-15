class ShapeBall extends ShapeSphere {
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  PVector gravityForce = new PVector(0, 0);
  final float gravityConstant = 100;
  final float normalForce = 100;
  final float mu = 0.2;
  final float frictionMagnitude = normalForce * mu;
  ShapePlate plate;

  ShapeBall(float radius, ShapePlate plate) {
    super(radius);
    this.plate = plate;
  }

  void update() {
    gravityForce.x = sin(plate.rotZ.value) * gravityConstant;
    gravityForce.y = -sin(plate.rotX.value) * gravityConstant;

    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce.add(friction).div(frameRate));
    position.add(velocity);

    checkEdges();
    checkCylinderCollision();
  }

  void checkEdges() {
    float minX = (-plate.width / 2) + radius;
    float maxX = (plate.width / 2) - radius;
    float minY = (-plate.depth / 2) + radius;
    float maxY = (plate.depth / 2) - radius;

    if (position.x < minX || position.x > maxX) {
      velocity.x = velocity.x * -1;
      position.x = constrain(position.x, minX, maxX);
      env.score.hitEdge();
    }

    if (position.y < minY || position.y > maxY) {
      velocity.y = velocity.y * -1;
      position.y = constrain(position.y, minY, maxY);
      env.score.hitEdge();
    }
  }

  void checkCylinderCollision() {
    for (ShapeCylinder cylinder : plate.cylinders) {
      if (position.dist(cylinder.position) < radius + cylinder.radius) {
        PVector n = position.copy().sub(cylinder.position).normalize();
        position = cylinder.position.copy().add(n.copy().mult(radius + cylinder.radius));
        velocity = velocity.sub(n.mult(2*velocity.dot(n)));
        env.score.hitCylinder();
      }
    }
  }

  void draw(PGraphics surface) {
    surface.pushMatrix();
    surface.translate(position.x, -plate.height/2 - radius, position.y);
    super.draw(surface);
    surface.popMatrix();
  }
}