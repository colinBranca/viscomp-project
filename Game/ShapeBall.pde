class ShapeBall extends ShapeSphere {
  PVector position = new PVector();
  PVector velocity = new PVector();
  PVector gravityForce = new PVector();
  final float gravityConstant = 1;
  final float normalForce = 1;
  final float mu = 0.3;
  final float frictionMagnitude = normalForce * mu;
  ShapePlate plate;

  ShapeBall(float radius, ShapePlate plate) {
    super(radius);
    this.plate = plate;
    this.position.y = -plate.height / 2 - radius;
  }

  void update() {
    gravityForce.x = sin(plate.rotZ.value) * gravityConstant;
    gravityForce.z = -sin(plate.rotX.value) * gravityConstant;

    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce.add(friction));
    position.add(velocity);

    checkEdges();
  }

  void checkEdges() {
    if (position.x > plate.width/2 || position.x < -plate.width/2) {
      velocity.x = velocity.x * -1;
      position.x = constrain(position.x, -plate.width/2, plate.width/2);
    }
    if (position.z > plate.depth/2 || position.z < -plate.depth/2) {
      velocity.z = velocity.z * -1;
      position.z = constrain(position.z, -plate.depth/2, plate.depth/2);
    }
  }

  void draw() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix();
  }
}