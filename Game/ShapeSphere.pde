class ShapeSphere extends Shape {
  float radius;
  
  ShapeSphere(float radius) {
    super();
    
    this.shape = createShape(SPHERE, radius);
    
    this.radius = radius;
  }
}