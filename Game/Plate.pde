class Plate extends Shape {
  private PShape plate;

  private BoundedFloat rotX; // Rotation arround X axis
  private BoundedFloat rotZ; // Rotation arround Z axix
  private BoundedFloat rotSpeed; // Rotation "speed"

  private float w; // Width
  private float h; // Height
  private float d; // Depth

  Plate(float w, float h, float d) {
    this.w = w;
    this.h = h;
    this.d = d;

    shape = createShape(GROUP);

    plate = createShape(BOX, w, h, d);
    shape.addChild(plate);
    
    rotX = new BoundedFloat();
    rotSpeed = new BoundedFloat();
  }

  public void update() {
  }
  
  public void setRotSpeed(float val) {
    rotSpeed.setValue(val);
  }
  
  public void changeRotSpeed(float diff) {
    rotSpeed.changeValue(diff);
  }

  public void rotateX(float diff) {
    diff /= rotSpeed.getValue();
    
    rotX.changeValue(diff);
    
    println(rotX.getValue());
    
    if(!rotX.isExtremum()) {
      shape.rotateX(diff);
    }
  }
  
  public void setRotateXBounds(float min, float max) {
    rotX.setBounds(min, max);
  }
}