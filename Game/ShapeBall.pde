class ShapeBall extends ShapeSphere {
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  PVector gravityForce = new PVector(0, 0);
  final float gravityConstant = 1;
  final float normalForce = 1;
  final float mu = 0.3;
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

    velocity.add(gravityForce.add(friction));
    position.add(velocity);

    checkEdges();
    checkCylinderCollision();
  }

  void checkEdges() {
    if (position.x > plate.width/2 || position.x < -plate.width/2) {
      velocity.x = velocity.x * -1;
      position.x = constrain(position.x, -plate.width/2, plate.width/2);
    }
    if (position.y > plate.depth/2 || position.y < -plate.depth/2) {
      velocity.y = velocity.y * -1;
      position.y = constrain(position.y, -plate.depth/2, plate.depth/2);
    }
  }

  void checkCylinderCollision() {
    for (ShapeCylinder cylinder : plate.cylinders) {
      if (position.dist(cylinder.position) < radius + cylinder.radius) {
        PVector n = position.copy().sub(cylinder.position).normalize();
        position = cylinder.position.copy().add(n.copy().mult(radius + cylinder.radius));
        velocity = velocity.sub(n.mult(2*velocity.dot(n)));
      }
    }
  }

  void draw() {
    pushMatrix();
    translate(position.x, -plate.height/2 - radius, position.y);
    super.draw();
    popMatrix();
  }
}