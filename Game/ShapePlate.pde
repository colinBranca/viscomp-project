class ShapePlate extends ShapeBox {
  final float SPEED_FACTOR = 0.0001;

  BoundedFloat rotX;     // Rotation arround world's X-axis
  BoundedFloat rotY;     // Rotation arround world's Y-axis
  BoundedFloat rotZ;     // Rotation arround world's Z-axis
  BoundedFloat rotSpeed; // Rotation speed

  ArrayList<Shape> children;

  ShapePlate(float width, float height, float depth) {
    super(width, height, depth);
    
    children = new ArrayList<Shape>();
  }

  void rotate(float x, float y, float z) {
    rotX = rotX.add(x * rotSpeed.value * SPEED_FACTOR);
    rotY = rotY.add(y * rotSpeed.value * SPEED_FACTOR);
    rotZ = rotZ.add(z * rotSpeed.value * SPEED_FACTOR);
  }

  void addRotationSpeed(float n) {
    rotSpeed = rotSpeed.add(n);
  }

  void draw() {
    pushMatrix();

    rotateX(rotX.value);
    rotateY(rotY.value);
    rotateZ(rotZ.value);
    // shape.rotateN() would rotate arround shape's N-axis,
    // which is not what we want here.

    super.draw();
    
    for(Shape shape : children) {
      shape.draw();
    }

    popMatrix();
  }
  
  void update() {
    for(Shape shape : children) {
      shape.update();
    }
  }

  void addChild(Shape shape) {
    children.add(shape);
  }
}