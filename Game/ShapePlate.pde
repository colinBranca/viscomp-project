class ShapePlate extends ShapeBox {
  float SPEED_FACTOR = 0.0001;
  
  BoundedFloat rotX;     // Rotation arround world's X-axis
  BoundedFloat rotY;     // Rotation arround world's Y-axis
  BoundedFloat rotZ;     // Rotation arround world's Z-axis
  BoundedFloat rotSpeed; // Rotation speed
  
  ShapePlate(float width, float depth, float height) {
    super(width, depth, height);
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
    // shape.rotateZ(rotZ.value) would rotate arround shape's Z-axis,
    // which is not what we want here.
    
    super.draw();
    
    popMatrix();
  }
}