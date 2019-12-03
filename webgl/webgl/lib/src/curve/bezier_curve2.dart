import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/gltf.dart';

///Based on explanations from : https://www.algosome.com/articles/continuous-bezier-curve-line.html
class BezierCurve2 extends GLTFNode{

  List<GLTFNode> _points;
  GLTFNode _curve;

  BezierCurve2(this._points){
    _curve = _createCurve();
    addChild(_curve);
  }

  @override
  void update(){
    _curve.mesh = _createCurve().mesh;
  }

  GLTFNode _createCurve() {
    List<Vector3> basePoints = _points.map((n)=> n.translation).toList();
    List<Vector3> curvedPointPositions = getCurvePoints(basePoints, 0.001);
    GLTFNode curve = new GLTFNode.line(curvedPointPositions, name:'curve');
    return curve;
  }

  /**
   * Generates several 3D points in a continuous Bezier curve based upon
   * the parameter list of points.
   * @param controls
   * @param detail
   * @return
   */
  List<Vector3> getCurvePoints(List<Vector3> controls, double detail) {
    if(controls.length < 2){
      throw new FormatException("controls.length must be > 1 : ${controls.length}");
    }
    if (!(0 <= detail && detail <= 1)) {
      throw new FormatException("detail is not in range : (0 <= detail && detail <= 1) : $detail");
    }

    List<Vector3> controlPoints = new List<Vector3>();
    List<Vector3> renderingPoints = new List<Vector3>();

    if(controls.length == 2){
      controlPoints.add(controls[0]);
      controlPoints.add(_getMiddlePoint(controls[0], controls[1]));
      controlPoints.add(controls[1]);
    }else if(controls.length <= 4){
      controlPoints.addAll(controls);
    }else {
      // generate the end and control points
      // from 2 existing points we add a point in the middle af two point
      for (int i = 1; i < controls.length - 1; i += 2) {
        //First control point needs to be take otherwise the curve is shifted to first middle point
        if(i == 1){
          controlPoints.add(controls[0]);
        }else {
          controlPoints.add(_getMiddlePoint(controls[i - 1], controls[i]));
        }
        controlPoints.add(controls[i]);
        controlPoints.add(controls[i + 1]);
        //?
        if (i + 2 < controls.length - 1) {
          controlPoints.add(_getMiddlePoint(controls[i + 1], controls[i + 2]));
        }
      }
    }

    //Generate the detailed points.
    Vector3 a0, a1, a2, a3;
    for (int i = 0; i < controlPoints.length - 2; i += 4) {
      a0 = controlPoints[i];
      a1 = controlPoints[i + 1];
      a2 = controlPoints[i + 2];
      if (i + 3 > controlPoints.length - 1) {
        //quad
        for (double j = 0; j < 1; j += detail) {
          renderingPoints.add(quadBezier(a0, a1, a2, j));
        }
      } else {
        //cubic
        a3 = controlPoints[i + 3];
        for (double j = 0; j < 1; j += detail) {
          renderingPoints.add(cubicBezier(a0, a1, a2, a3, j));
        }
      }
    }

    List<Vector3> points = renderingPoints.toList();
//    _simplifyPoints(points, 0, points.length,0.01);

    return points;
  }

  // Todo (jpu) : remove this ?
//  List<Vector3> _simplifyPoints(List<Vector3> points, int startIndex, int endIndex, double epsilon, [List<Vector3> newPoints]) {
//    List<Vector3> outPoints = newPoints ?? new List<Vector3>();
//
//    // find the most distance point from the endpoints
//    final Vector3 s = points[startIndex];
//    final Vector3 e = points[endIndex - 1];
//    num maxDistanceSquare = 0;
//    int maxNdx = 1;
//    for (int i = startIndex + 1; i < endIndex - 1; ++i) {
//      final num distanceSquare = _distanceToSegmentSquare(points[i], s, e);
//      if (distanceSquare > maxDistanceSquare) {
//        maxDistanceSquare = distanceSquare;
//        maxNdx = i;
//      }
//    }
//
//    // if that point is too far
//    if (Math.sqrt(maxDistanceSquare) > epsilon) {
//      // split
//      _simplifyPoints(points, startIndex, maxNdx + 1, epsilon, outPoints);
//      _simplifyPoints(points, maxNdx, endIndex, epsilon, outPoints);
//
//    } else {
//      // add the 2 end points
//      outPoints.addAll([s, e]);
//    }
//
//    return outPoints;
//  }

  /// compute the distance squared from p to the line segment
  /// formed by v and w
  // Todo (jpu) : remove this ?
//  num _distanceToSegmentSquare(Vector3 p, Vector3 v, Vector3 w) {
//    final num l2 = v.distanceToSquared(w);
//    if (l2 == 0) {
//      return p.distanceToSquared(v);
//    }
//    double t = ((p[0] - v[0]) * (w[0] - v[0]) + (p[1] - v[1]) * (w[1] - v[1])) / l2;
//    t = Math.max(0, Math.min(1, t));
//    return p.distanceToSquared(UtilsMath.lerpVec3(v, w, t));
//  }

  /**
   * A cubic bezier method to calculate the point at t along the Bezier Curve give
   * the parameter points.
   * @param p1
   * @param p2
   * @param p3
   * @param p4
   * @param t A value between 0 and 1, inclusive.
   * @return
   */
  Vector3 cubicBezier(
      Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4, double t) {
    return new Vector3(
        _cubicBezierPoint(p1.x, p2.x, p3.x, p4.x, t),
        _cubicBezierPoint(p1.y, p2.y, p3.y, p4.y, t),
        _cubicBezierPoint(p1.z, p2.z, p3.z, p4.z, t));
  }

  /**
   * A quadratic Bezier method to calculate the point at t along the Bezier Curve give
   * the parameter points.
   * @param p1
   * @param p2
   * @param p3
   * @param t A value between 0 and 1, inclusive.
   * @return
   */
  Vector3 quadBezier(Vector3 p1, Vector3 p2, Vector3 p3, double t) {
    return new Vector3(
        _quadBezierPoint(p1.x, p2.x, p3.x, t),
        _quadBezierPoint(p1.y, p2.y, p3.y, t),
        _quadBezierPoint(p1.z, p2.z, p3.z, t));
  }

  /**
   * The cubic Bezier equation.
   * @param a0
   * @param a1
   * @param a2
   * @param a3
   * @param t
   * @return
   */
  double _cubicBezierPoint(
      double a0, double a1, double a2, double a3, double t) {
    return (Math.pow(1 - t, 3) * a0 +
        3 * Math.pow(1 - t, 2) * t * a1 +
        3 * (1 - t) * Math.pow(t, 2) * a2 +
        Math.pow(t, 3) * a3) as double;
  }

  /**
   * The quadratic Bezier equation,
   * @param a0
   * @param a1
   * @param a2
   * @param t
   * @return
   */
  double _quadBezierPoint(double a0, double a1, double a2, double t) {
    return (Math.pow(1 - t, 2) * a0 + 2 * (1 - t) * t * a1 + Math.pow(t, 2) * a2) as double;
  }

  /**
   * Calculates the center point between the two parameter points.
   * @param p1
   * @param p2
   * @return
   */
  Vector3 _getMiddlePoint(Vector3 p1, Vector3 p2) {
    return new Vector3((p1.x + p2.x) / 2, (p1.y + p2.y) / 2, (p1.z + p2.z) / 2);
  }
}
