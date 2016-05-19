ArrayList<PVector> getIntersections(List<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);
      // compute the intersection and add it to ’intersections’
      PVector intersect = intersection(line1, line2);
      intersections.add(intersect);
      // draw the intersection
      fill(255, 128, 0);
      ellipse(intersect.x, intersect.y, 10, 10);
    }
  }
  return intersections;
}

PVector intersection(PVector l1, PVector l2) {
  double sin1 = Math.sin(l1.y);
  double sin2 = Math.sin(l2.y);
  double cos1 = Math.cos(l1.y);
  double cos2 = Math.cos(l2.y);
  double d = cos2*sin1 - cos1*sin2;
  double r1 = l1.x;
  double r2 = l2.x;

  int x = (int)((r2*sin1 - r1*sin2)/d);
  int y = (int)((-r2*cos1 + r1*cos2)/d);

  return new PVector(x, y);
}