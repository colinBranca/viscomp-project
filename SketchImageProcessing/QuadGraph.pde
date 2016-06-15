import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.ArrayList;
int nbr = 0;

class QuadGraph {
  List<int[]> cycles = new ArrayList<int[]>();
  int[][] graph;
  List<PVector> lines;
  int imgWidth;
  int imgHeight;

  QuadGraph(List<PVector> lines, int width, int height) {
    this.lines = lines;
    int n = lines.size();
    // The maximum possible number of edges is n * (n - 1)/2
    graph = new int[n * (n - 1)/2][2];
    this.imgWidth = width;
    this.imgHeight = height;

    int idx =0;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        if (intersect(lines.get(i), lines.get(j), width, height)) {
          graph[idx][0] = i;
          graph[idx][1] = j;
          idx++;
        }
      }
    }

    findCycles();
  }

  PVector intersection(PVector l1, PVector l2) {
    double sin1 = Math.sin(l1.y);
    double sin2 = Math.sin(l2.y);
    double cos1 = Math.cos(l1.y);
    double cos2 = Math.cos(l2.y);
    double d = cos2*sin1 - cos1*sin2;
    double r1 = l1.x;
    double r2 = l2.x;

    float x = (float)((r2*sin1 - r1*sin2)/d);
    float y = (float)((-r2*cos1 + r1*cos2)/d);

    return new PVector(x, y);
  }

  /** Returns true if polar lines 1 and 2 intersect 
   * inside an area of size (width, height)
   */
  boolean intersect(PVector line1, PVector line2, int width, int height) {
    PVector p = intersection(line1, line2);
    return 0 <= p.x && 0 <= p.y && width >= p.x && height >= p.y;
  }

  List<int[]> findCycles() {
    cycles.clear();
    for (int i = 0; i < graph.length; i++) {
      for (int j = 0; j < graph[i].length; j++) {
        findNewCycles(new int[] {graph[i][j]});
      }
    }
    for (int[] cy : cycles) {

      String s = "" + cy[0];
      for (int i = 1; i < cy.length; i++) {
        s += "," + cy[i];
      }
      println(s);
    }

    return cycles;
  }

  void findNewCycles(int[] path)
  {
    int n = path[0];
    int x;
    int[] sub = new int[path.length + 1];
    for (int i = 0; i < graph.length; i++) {
      for (int y = 0; y <= 1; y++) {
        if (graph[i][y] == n) {
          //  edge refers to our current node
          x = graph[i][(y + 1) % 2];
          if (!visited(x, path)) {
            //  neighbor node not on path yet
            sub[0] = x;
            System.arraycopy(path, 0, sub, 1, path.length);
            //  explore extended path
            findNewCycles(sub);
          } else if ((path.length == 4) && (x == path[path.length - 1])) {
            //cycle found
            int[] p = normalize(path);
            int[] inv = invert(p);
            if (isNew(p) && isNew(inv)) {
              cycles.add(p);
            }
          }
        }
      }
    }
  }

  int[] findMaxQuad() {
    float maxArea = 0;
    int[] maxQuad = null;

    for (int[] quad : cycles) {
      PVector l1 = lines.get(quad[0]);
      PVector l2 = lines.get(quad[1]);
      PVector l3 = lines.get(quad[2]);
      PVector l4 = lines.get(quad[3]);

      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

      boolean convex = isConvex(c12, c23, c34, c41);
      float area = areaOfQuad(c12, c23, c34, c41);
      boolean valid = validArea(area, 1000, 350000);
      boolean notFlat = nonFlatQuad(c12, c23, c34, c41);

      if (convex && valid && notFlat && area > maxArea) {
        maxArea = area;
        maxQuad = quad;
      }
    }

    return maxQuad;
  }

  //Calcule de l'area
  float areaOfQuad(PVector c1, PVector c2, PVector c3, PVector c4) {
    PVector v12= PVector.sub(c1, c2);
    PVector v23= PVector.sub(c2, c3);
    PVector v34= PVector.sub(c3, c4);
    PVector v41= PVector.sub(c4, c1);

    float a1=v12.cross(v23).z;
    float a2=v23.cross(v34).z;
    float a3=v34.cross(v41).z;
    float a4=v41.cross(v12).z;

    float area = Math.abs((a1 + a2 + a3 + a4)/2);
    return area;
  }

  //Dessine les quads
  void drawMaxQuad(int x, int y) {
    int[] quad = findMaxQuad();
    ArrayList<PVector> quadLines = new ArrayList<PVector>();

    if (quad == null) {
      return;
    }

    quadLines.add(lines.get(quad[0]));
    quadLines.add(lines.get(quad[1]));
    quadLines.add(lines.get(quad[2]));
    quadLines.add(lines.get(quad[3]));

    drawPolarLines(quadLines, imgWidth, imgHeight, x, y);

    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);

    pushMatrix();
    pushStyle();
    translate(x, y);
    fill(204, 102, 0);
    noStroke();

    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines)
    drawIntersection(l1, l2);
    drawIntersection(l2, l3);
    drawIntersection(l3, l4);
    drawIntersection(l4, l1);

    popStyle();
    popMatrix();
  }

  void drawIntersection(PVector l1, PVector l2) {
    PVector in = intersection(l1, l2);
    ellipse(in.x, in.y, 10, 10);
  }

  void getIntersections(ArrayList<PVector> intersections) {
    int[] quad = findMaxQuad();
    ArrayList<PVector> quadLines = new ArrayList<PVector>();

    if (quad == null) {
      return;
    }

    quadLines.add(lines.get(quad[0]));
    quadLines.add(lines.get(quad[1]));
    quadLines.add(lines.get(quad[2]));
    quadLines.add(lines.get(quad[3]));


    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    
    PVector i1 = intersection(l1, l2);
    PVector i2 = intersection(l2, l3);
    PVector i3 = intersection(l3, l4);
    PVector i4 = intersection(l4, l1);
    
    intersections.add(i1);
    intersections.add(i2);
    intersections.add(i3);
    intersections.add(i4);
  }
  
  void drawListOfIntersections(ArrayList<PVector> intersections){
    for(PVector in : intersections){
      ellipse(in.x, in.y, 10, 10);
    }
  }

  //  check of both arrays have same lengths and contents
  Boolean equals(int[] a, int[] b)
  {
    Boolean ret = (a[0] == b[0]) && (a.length == b.length);

    for (int i = 1; ret && (i < a.length); i++)
    {
      if (a[i] != b[i])
      {
        ret = false;
      }
    }

    return ret;
  }

  //  create a path array with reversed order
  int[] invert(int[] path)
  {
    int[] p = new int[path.length];

    for (int i = 0; i < path.length; i++)
    {
      p[i] = path[path.length - 1 - i];
    }

    return normalize(p);
  }

  //  rotate cycle path such that it begins with the smallest node
  int[] normalize(int[] path)
  {
    int[] p = new int[path.length];
    int x = smallest(path);
    int n;

    System.arraycopy(path, 0, p, 0, path.length);

    while (p[0] != x)
    {
      n = p[0];
      System.arraycopy(p, 1, p, 0, p.length - 1);
      p[p.length - 1] = n;
    }

    return p;
  }

  //  compare path against known cycles
  //  return true, iff path is not a known cycle
  Boolean isNew(int[] path)
  {
    Boolean ret = true;

    for (int[] p : cycles)
    {
      if (equals(p, path))
      {
        ret = false;
        break;
      }
    }

    return ret;
  }

  //  return the int of the array which is the smallest
  int smallest(int[] path)
  {
    int min = path[0];

    for (int p : path)
    {
      if (p < min)
      {
        min = p;
      }
    }

    return min;
  }

  //  check if vertex n is contained in path
  Boolean visited(int n, int[] path)
  {
    Boolean ret = false;

    for (int p : path)
    {
      if (p == n)
      {
        ret = true;
        break;
      }
    }

    return ret;
  }



  /** Check if a quad is convex or not.
   * 
   * Algo: take two adjacent edges and compute their cross-product. 
   * The sign of the z-component of all the cross-products is the 
   * same for a convex polygon.
   * 
   * See http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
   * for justification.
   * 
   * @param c1
   */
  boolean isConvex(PVector c1, PVector c2, PVector c3, PVector c4) {

    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float i1=v21.cross(v32).z;
    float i2=v32.cross(v43).z;
    float i3=v43.cross(v14).z;
    float i4=v14.cross(v21).z;

    if (   (i1>0 && i2>0 && i3>0 && i4>0) 
      || (i1<0 && i2<0 && i3<0 && i4<0))
      return true;
    else 
    System.out.println("Eliminating non-convex quad");
    return false;
  }

  /** Compute the area of a quad, and check it lays within a specific range
   */
  boolean validArea(float area, float min_area, float max_area) {

    System.out.println(area);
    boolean valid = (area < max_area && area > min_area);
    if (!valid) System.out.println("Area out of range");
    return valid;
  }

  /** Compute the (cosine) of the four angles of the quad, and check they are all large enough
   * (the quad representing our board should be close to a rectangle)
   */
  boolean nonFlatQuad(PVector c1, PVector c2, PVector c3, PVector c4) {

    // cos(70deg) ~= 0.3
    float min_cos = 0.5f;

    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float cos1=Math.abs(v21.dot(v32) / (v21.mag() * v32.mag()));
    float cos2=Math.abs(v32.dot(v43) / (v32.mag() * v43.mag()));
    float cos3=Math.abs(v43.dot(v14) / (v43.mag() * v14.mag()));
    float cos4=Math.abs(v14.dot(v21) / (v14.mag() * v21.mag()));

    if (cos1 < min_cos && cos2 < min_cos && cos3 < min_cos && cos4 < min_cos)
      return true;
    else {
      System.out.println("Flat quad");
      return false;
    }
  }

  List<PVector> sortCorners(List<PVector> quad) {

    // 1 - Sort corners so that they are ordered clockwise
    PVector a = quad.get(0);
    PVector b = quad.get(2);

    PVector center = new PVector((a.x+b.x)/2, (a.y+b.y)/2);

    Collections.sort(quad, new CWComparator(center));



    // 2 - Sort by upper left most corner
    PVector origin = new PVector(0, 0);
    float distToOrigin = 1000;

    for (PVector p : quad) {
      if (p.dist(origin) < distToOrigin) distToOrigin = p.dist(origin);
    }

    while (quad.get(0).dist(origin) != distToOrigin)
      Collections.rotate(quad, 1);


    return quad;
  }
}

class CWComparator implements Comparator<PVector> {

  PVector center;

  public CWComparator(PVector center) {
    this.center = center;
  }

  @Override
    public int compare(PVector b, PVector d) {
    if (Math.atan2(b.y-center.y, b.x-center.x)<Math.atan2(d.y-center.y, d.x-center.x))      
      return -1; 
    else return 1;
  }
}

public List<PVector> sortCorners(List<PVector> quad) {
  // Sort corners so that they are ordered clockwise
  PVector a = quad.get(0);
  PVector b = quad.get(2);
  PVector center = new PVector((a.x+b.x)/2, (a.y+b.y)/2);
  java.util.Collections.sort(quad, new CWComparator(center));
  // TODO:
  // Re-order the corners so that the first one is the closest to the
  // origin (0,0) of the image.
  //
  // You can use Collections.rotate to shift the corners inside the quad.
  //ICI
  int minIndex = 0;
  double minTan = Math.atan2(quad.get(0).y, quad.get(0).x);
  for (int i=1; i<4; i++) {
    double tan = Math.atan2(quad.get(i).y, quad.get(i).x);
    if (Math.abs((int)tan)<Math.abs((int)minTan)) {
      minTan = tan;
      minIndex = i;
    }
  }

  Collections.rotate(quad, minIndex);
  //A ICI

  return quad;
}