abstract class Mode {
  Environment env;
  ArrayList<Mode> children;
  boolean isActive;
  int width;
  int height;
  int x;
  int y;
  PGraphics surface;

  Mode(Environment env, int width, int height, int x, int y, String renderer) {
    this.children = new ArrayList<Mode>();
    this.isActive = false;
    this.env = env;
    this.width = width;
    this.height = height;
    this.x = x;
    this.y = y;
    this.surface = createGraphics(width, height, renderer);
  }
  void addChild(Mode mode) {
    children.add(mode);
  }

  void enter() {
    this.isActive = true;
  }

  void exit() {
    this.isActive = false;
  }

  void draw() {
    image(surface, x, y);

    for (Mode child : children) {
      if (child.isActive) {
        child.draw();
      }
    }
  }

  void update() {
    for (Mode child : children) {
      if (child.isActive) {
        child.update();
      }
    }
  }

  void keyPressed() {
    for (Mode child : children) {
      if (child.isActive) {
        child.keyPressed();
      }
    }
  }

  void keyReleased() {
    for (Mode child : children) {
      if (child.isActive) {
        child.keyReleased();
      }
    }
  }

  void mouseDragged() {
    for (Mode child : children) {
      if (child.isActive) {
        child.mouseDragged();
      }
    }
  }

  void mouseClicked() {
    for (Mode child : children) {
      if (child.isActive && isMouseOver(child)) {
        child.mouseClicked();
      }
    }
  }

  void mousePressed() {
    for (Mode child : children) {
      if (child.isActive && isMouseOver(child)) {
        child.mousePressed();
      }
    }
  }

  void mouseReleased() {
    for (Mode child : children) {
      if (child.isActive) {
        child.mouseReleased();
      }
    }
  }

  void mouseWheel(MouseEvent event) {
    for (Mode child : children) {
      if (child.isActive && isMouseOver(child)) {
        child.mouseWheel(event);
      }
    }
  }

  boolean isMouseOver(Mode m) {
    return mouseX > m.x && mouseX < m.x + m.width && mouseY > m.y && mouseY < m.y + m.height;
  }
}