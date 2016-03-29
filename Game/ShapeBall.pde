class ShapeBall extends ShapeSphere {
  PVector position;
  PVector velocity;
  ShapePlate plate;

  ShapeBall(float radius, ShapePlate plate) {
    super(radius);
    this.plate = plate;
    position = new PVector();
    velocity = new PVector();
  }

  void draw() {
    pushMatrix();
    translate(position.x, -plate.height / 2 - radius, position.z);
    super.draw();
    popMatrix();
  }
}