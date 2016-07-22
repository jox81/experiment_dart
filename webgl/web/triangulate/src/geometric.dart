import 'package:vector_math/vector_math.dart';
import 'dart:math';

class Geometric{

  static double getAngleBetween3Points(Vector3 vec3P1, Vector3 vec3P2, Vector3 vec3P3){
    Vector3 edge1 = vec3P1-vec3P2;
    Vector3 edge2 = vec3P3-vec3P2;

    num dotValue = edge1.normalized().dot( edge2.normalized());

    //angle = atan2(norm(cross(a,b)), dot(a,b))
    double cross = edge1.normalized().cross(edge2.normalized()).z;
    double angle = atan2(cross, dotValue);
    return angle;
  }

  static double toDegree(double angleRadian){
    return angleRadian * 180 / PI;
  }

//Is point inside a triangle ?
/*function isPointInsideTriangle(vec3PointTest, vec3Point1, vec3Point2, vec3Point3){
    //return float
    function sign(vec3Point1, vec3Point2, vec3Point3)
    {
        return (vec3Point1[0] - vec3Point3[0]) * (vec3Point2[1] - vec3Point2[1]) - (vec3Point2[0] - vec3Point3[0]) * (vec3Point1[1] - vec3Point3[1]);
    }

    var b1, b2, b3;

    b1 = sign(vec3PointTest, vec3Point1, vec3Point2) < 0.0;
    b2 = sign(vec3PointTest, vec3Point2, vec3Point3) < 0.0;
    b3 = sign(vec3PointTest, vec3Point3, vec3Point1) < 0.0;

    return ((b1 == b2) && (b2 == b3));
}*/

  static bool isPointInsideTriangle(Vector3 pointTest, Vector3 point1, Vector3 point2, Vector3 point3){
    return is_in_triangle (pointTest.x,pointTest.y,point1.x,point1.y,point2.x,point2.y,point3.x,point3.y);
  }

  static bool is_in_triangle (double px,double py,double ax,double ay,double bx,double by,double cx,double cy){
    var v0 = [cx-ax,cy-ay];
    var v1 = [bx-ax,by-ay];
    var v2 = [px-ax,py-ay];

    var dot00 = (v0[0]*v0[0]) + (v0[1]*v0[1]);
    var dot01 = (v0[0]*v1[0]) + (v0[1]*v1[1]);
    var dot02 = (v0[0]*v2[0]) + (v0[1]*v2[1]);
    var dot11 = (v1[0]*v1[0]) + (v1[1]*v1[1]);
    var dot12 = (v1[0]*v2[0]) + (v1[1]*v2[1]);

    var invDenom = 1/ (dot00 * dot11 - dot01 * dot01);

    var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    var v = (dot00 * dot12 - dot01 * dot02) * invDenom;
    //Todo : case if u = 0 && v = 0 ? point on edge... sometimes outside/inside check edge intersection
    return ((u > 0) && (v > 0) && (u + v < 1));
  }


}
