class ModeScrollBar extends Mode {
  final int CURSOR_WIDTH = 80;
  final color BACKGROUND_COLOR = color(190);
  final int maxCursorX;
  BoundedFloat value;
  boolean pressed = false;

  ModeScrollBar(Environment env, int width, int height, int x, int y, BoundedFloat value) {
    super(env, width, height, x, y, P2D);
    this.value = value;
    this.maxCursorX = width - CURSOR_WIDTH;
  }

  void draw() {
    surface.beginDraw();
    surface.background(BACKGROUND_COLOR);
    surface.fill(0);
    surface.rect(map(value.value, value.min, value.max, 0, maxCursorX), 0, CURSOR_WIDTH, height);
    surface.endDraw();
    super.draw();
  }

  void mouseDragged() {
    if (pressed) {
      updateValue();
    }
  }

  void mousePressed() {
    pressed = true;
    updateValue();
  }

  void mouseReleased() {
    pressed = false;
  }

  void updateValue() {
    value = value.withValue(map(mouseX - CURSOR_WIDTH / 2, x, x + maxCursorX, value.min, value.max));
  }
}