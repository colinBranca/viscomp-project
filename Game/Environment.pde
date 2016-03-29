class Environment {
  Mode mode;
  ShapePlate plate;

  void switchMode(Mode mode) {
    if (this.mode != null) {
      this.mode.exit(this);
    }
    
    this.mode = mode;
    mode.enter(this);
  }
}