abstract class Mode {
  void enter(Environment env) {}
  void exit(Environment env) {}
  void draw(Environment env) {}
  void update(Environment env) {}
  void keyPressed(Environment env) {}
  void keyReleased(Environment env) {}
  void mouseDragged(Environment env) {}
  void mouseClicked(Environment env) {}
  void mouseWheel(Environment env, MouseEvent event) {}
}