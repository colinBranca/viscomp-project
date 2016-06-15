class ModeScoreChart extends Mode {
  final color BACKGROUND_COLOR = color(190);
  final int squareInnerHeight; /* in pixels */
  final int margin = 1; /* in pixels */
  final int squareOuterHeight; /* in pixels */
  final int maxColHeight; /* in squares */

  ModeScoreChart(Environment env, int width, int height, int x, int y) {
    super(env, width, height, x, y, P2D);
    squareInnerHeight = (int) env.chartZoom.value;
    squareOuterHeight = squareInnerHeight + margin;
    maxColHeight = (height - margin) / squareOuterHeight;
  }

  void draw() {
    surface.beginDraw();
    surface.background(BACKGROUND_COLOR);
    surface.translate(0, height);
    surface.noStroke();

    int xPos = margin;
    int yPos;
    int colHeight;
    int squareInnerWidth = (int) env.chartZoom.value;
    int squareOuterWidth = squareInnerWidth + margin;

    for (float score : env.score.history) {
      if (score > 0) {
        colHeight = (int) map(score, 0, env.score.max, 0, maxColHeight);
        yPos = 0;

        for (int i = 0; i != colHeight; ++i) {
          yPos -= squareOuterHeight;
          surface.fill(map(i, 0, maxColHeight, 0, 160));
          surface.rect(xPos, yPos, squareInnerWidth, squareInnerHeight);
        }
      }
      xPos += squareOuterWidth;
    }

    surface.endDraw();
    super.draw();
  }
}