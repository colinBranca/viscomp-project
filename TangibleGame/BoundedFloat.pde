class BoundedFloat {
  final float value;
  final float min;
  final float max;

  BoundedFloat() {
    value = 0;
    min = Integer.MIN_VALUE;
    max = Integer.MAX_VALUE;
  }

  BoundedFloat(float value, float min, float max) {
    this.min = min;
    this.max = max;
    // See: https://processing.org/reference/constrain_.html
    this.value = constrain(value, min, max);
  }

  public BoundedFloat withValue(float value) {
    return new BoundedFloat(value, min, max);
  }

  public BoundedFloat add(float diff) {
    return withValue(value + diff);
  }

  public String toString() {
    return format("%f");
  }

  public String format(String format) {
    return String.format(format, value)
      + " (min: " + String.format(format, min)
      + ", max: " + String.format(format, max) + ")";
  }

  public BoundedFloat toDegrees() {
    return new BoundedFloat(degrees(value), degrees(min), degrees(max));
  }
}