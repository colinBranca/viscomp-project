import java.util.Collections;
import java.util.Comparator;

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

public static List<PVector> sortCorners(List<PVector> quad) {
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
  for(int i=1; i<4; i++){
    double tan = Math.atan2(quad.get(i).y, quad.get(i).x);
    if(Math.abs((int)tan)<Math.abs((int)minTan)){
      minTan = tan;
      minIndex = i;
    }
  }
  
  Collections.rotate(quad, minIndex);
  //A ICI
  
  return quad;
}