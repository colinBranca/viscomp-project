class ShapeBox extends Shape {
  float width;
  float depth;
  float height;
  
  ShapeBox(float width, float depth, float height) {
    super();
    
    this.shape = createShape(BOX, width, depth, height);
    
    this.width = width;
    this.depth = depth;
    this.height = height;
  }
  
  void draw() {
    super.draw();
  }
}