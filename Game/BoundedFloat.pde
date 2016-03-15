class BoundedFloat {
  private float value;
  private float min;
  private float max;

  BoundedFloat() {
    value = 0;
    min = Integer.MIN_VALUE;
    max = Integer.MAX_VALUE;
  }

  public void setBounds(float min, float max) {
    this.min = min;
    this.max = max;
  }

  public void setValue(float value) {
    // See: https://processing.org/reference/constrain_.html
    this.value = constrain(value, min, max);
  }
  
  public void changeValue(float diff) {
    setValue(value + diff);
  }

  public float getValue() {
    return value;
  }
  
  public Boolean isExtremum() {
    return value == min || value == max;
  }
}