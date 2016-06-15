/**
 * Draw found lines at position (x, y)
 */
void drawPolarLines(List<PVector> lines, int width, int height, int x, int y) {
  pushMatrix();
  pushStyle();
  translate(x, y);
  stroke(204, 102, 0);

  for (int i=0; i < lines.size(); i++) {
    PVector vect = lines.get(i);
    float r = vect.x;
    float phi = vect.y;

    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = width;
    int y2 = (int) ((-cos(phi) / sin(phi)) * x2 + (r / sin(phi)));
    int y3 = height;
    int x3 = (int) (((r/sin(phi))-y3)*(sin(phi)/cos(phi)));

    // Finally, plot the lines
    if (y0 > 0 && y0<height) {
      if (x1 > 0 && x1<width)
        line(x0, y0, x1, y1);
      else if (y2 > 0 && y2<height)
        line(x0, y0, x2, y2);
      else {
        if (x3>0 && x3<width)
          line(x0, y0, x3, y3);
      }
    } else {
      if (x1 > 0 && x1<width) {
        if (y2 > 0 && y2<height)
          line(x1, y1, x2, y2);
        else {
          if (x3 > 0 && x3<width)
            line(x1, y1, x3, y3);
        }
      } else {
        if (y2 > 0 && y2<height && x3>0 && x3<width)
          line(x2, y2, x3, y3);
      }
    }
  }

  popStyle();
  popMatrix();
}