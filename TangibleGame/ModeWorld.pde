class ModeWorld extends Mode {
  final float INFOS_HEIGHT_REL = 0.2;
  ModeDefault defaultMode;
  ModeShift shiftMode;
  ModeInformations infoMode;

  ModeWorld(Environment env, int width, int height, int x, int y ) {
    super(env, width, height, x, y, P3D);

    int infos_height = (int) (INFOS_HEIGHT_REL * height);
    int main_height = height - infos_height;

    defaultMode = new ModeDefault(env, width, main_height, 0, 0);
    shiftMode = new ModeShift(env, width, main_height, 0, 0);
    infoMode = new ModeInformations(env, width, infos_height, 0, main_height);

    addChild(defaultMode);
    addChild(shiftMode);
    addChild(infoMode);

    defaultMode.enter();
    infoMode.enter();
  }

  void keyPressed() {
    if (key == CODED && keyCode == SHIFT) {
      defaultMode.exit();
      shiftMode.enter();
    }
  }

  void keyReleased() {
    if (key == CODED && keyCode == SHIFT) {
      shiftMode.exit();
      defaultMode.enter();
    }
  }
}