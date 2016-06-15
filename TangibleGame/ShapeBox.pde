class ShapeBox extends Shape {
  float width;
  float depth;
  float height;

  ShapeBox(float width, float height, float depth) {
    super();

    this.shape = createShape(BOX, width, height, depth);

    this.width = width;
    this.height = height;
    this.depth = depth;
  }
}