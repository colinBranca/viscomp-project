abstract class Shape {
  PShape shape;
  color fillColor;

  void draw(PGraphics surface) {
    surface.shape(shape);
  }

  void update() {
  }

  void fill(float r, float g, float b) {
    fillColor = color(r, g, b);
    shape.setFill(fillColor);
  }

  void fill(color c) {
    fillColor = c;
    shape.setFill(c);
  }
}