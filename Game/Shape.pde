abstract class Shape {
  PShape shape;

  void draw() {
    shape(shape);
  }

  void fill(float r, float g, float b) {
    shape.setFill(color(r, g, b));
  }
}