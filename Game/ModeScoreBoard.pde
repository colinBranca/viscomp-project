class ModeScoreBoard extends Mode {
  final float TEXT_MARGIN = 10;

  ModeScoreBoard(Environment env, int width, int height, int x, int y) {
    super(env, width, height, x, y, P2D);
  }

  void draw() {
    surface.beginDraw();
    surface.stroke(200);
    surface.strokeWeight(4);
    surface.fill(50);
    surface.rect(0, 0, width, height);
    surface.fill(200);
    surface.textSize(width/8);
    surface.textAlign(LEFT, TOP);
    surface.text("Total score\n" + env.score.value, TEXT_MARGIN, TEXT_MARGIN);
    surface.textAlign(LEFT, CENTER);
    surface.text("Velocity\n" + env.plate.ball.velocity.mag(), TEXT_MARGIN, height / 2);
    surface.textAlign(LEFT, BOTTOM);
    surface.text("Last score\n" + env.score.lastChange, TEXT_MARGIN, height - TEXT_MARGIN);
    surface.endDraw();
    super.draw();
  }
}