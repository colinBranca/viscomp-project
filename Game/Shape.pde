abstract class Shape {
  protected PShape shape;

  abstract void update();

  void draw() {
    shape(shape);
  }

  void fill(float r, float g, float b) {
    shape.setFill(color(r, g, b));
  }
}