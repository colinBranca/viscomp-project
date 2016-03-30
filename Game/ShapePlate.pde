class ShapePlate extends ShapeBox {
  final float SPEED_FACTOR = 0.0001;

  BoundedFloat rotX;     // Rotation arround world's X-axis
  BoundedFloat rotZ;     // Rotation arround world's Z-axis
  BoundedFloat rotSpeed; // Rotation speed

  ArrayList<ShapeCylinder> cylinders;
  ShapeBall ball;


  ShapePlate(float width, float height, float depth) {
    super(width, height, depth);

    cylinders = new ArrayList<ShapeCylinder>();
  }

  void rotate(float diffX, float diffZ) {
    rotX = rotX.add(diffX * rotSpeed.value * SPEED_FACTOR);
    rotZ = rotZ.add(diffZ * rotSpeed.value * SPEED_FACTOR);
  }

  void addRotationSpeed(float n) {
    rotSpeed = rotSpeed.add(n);
  }

  void draw() {
    pushMatrix();

    rotateX(rotX.value);
    rotateZ(rotZ.value);
    // shape.rotateN() would rotate arround shape's N-axis,
    // which is not what we want here.

    super.draw();
    ball.draw();

    for (ShapeCylinder cylinder : cylinders) {
      cylinder.draw();
    }

    popMatrix();
  }

  void update() {
    super.update();
    ball.update();

    for (ShapeCylinder cylinder : cylinders) {
      cylinder.update();
    }
  }

  void addCylinder(ShapeCylinder shape) {
    cylinders.add(shape);
  }
}