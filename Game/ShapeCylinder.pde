class ShapeCylinder extends Shape {
  final float radius;
  final float height;
  final int resolution;
  PVector position;
  ShapePlate plate;

  ShapeCylinder(float radius, float height, int resolution, PVector position, ShapePlate plate) {
    this.radius = radius;
    this.height = height;
    this.resolution = resolution;
    this.position = position;
    this.plate = plate;

    float angle;
    float[] x = new float[resolution + 1];
    float[] z = new float[resolution + 1];

    // Generate X and Z coordinates for `resolution` vertices on the circle
    for (int i = 0; i != x.length; ++i) {
      angle = (TWO_PI / resolution) * i;
      x[i] = sin(angle) * radius;
      z[i] = cos(angle) * radius;
    }

    shape = createShape(GROUP);

    // Create the side
    PShape side = createShape();
    side.beginShape(QUAD_STRIP);
    for (int i = 0; i != x.length; ++i) {
      side.vertex(x[i], 0, z[i]);
      side.vertex(x[i], -height, z[i]);
    }
    side.endShape();
    shape.addChild(side);
    
    // Create the bottom
    PShape bottom = createShape();
    bottom.beginShape(TRIANGLE_FAN);
    for (int i = 0; i != x.length; ++i) {
      bottom.vertex(x[i], 0, z[i]);
    }
    bottom.endShape();
    shape.addChild(bottom);
    
    // Create the top
    PShape top = createShape();
    top.beginShape(TRIANGLE_FAN);
    for (int i = 0; i != x.length; ++i) {
      top.vertex(x[i], -height, z[i]);
    }
    top.endShape();
    shape.addChild(top);
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, -plate.height/2, position.y);
    shape(shape);
    popMatrix();
  }
}