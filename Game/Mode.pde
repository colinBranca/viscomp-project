interface Mode {
  void draw(Environment env);
  void update(Environment env);
  void keyReleased(Environment env);
  void mouseDragged(Environment env);
  void mouseClicked(Environment env);
  void mouseWheel(Environment env, MouseEvent event);
}