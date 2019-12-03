import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/utils/utils_math.dart';

///Based on explantions from : https://webglfundamentals.org/webgl/lessons/webgl-3d-geometry-lathe.html
/// see also learning on : https://pomax.github.io/bezierinfo/

///
class BezierCurve {
  // gets points across all segments
  List<Vector3> getCurvePoints(List<Vector3> points, double tolerance) {
    List<Vector3> newPoints = [];
    final int numSegments = (points.length - 1) ~/ 3;
    for (int i = 0; i < numSegments; ++i) {
      final int offset = i * 3;
      getPointsOnBezierCurveWithSplitting(points, offset, tolerance, newPoints);
    }
    return newPoints;
  }

  /// Find all the points of the curve
  ///[numPoints] point counts on the curve
  ///[epsilon] smoothness
  List<Vector3> getPointsOnBezierCurve(
      List<Vector3> points, int offset, int numPoints) {
    List<Vector3> outPoints = [];
    for (int i = 0; i < numPoints; ++i) {
      final double t = i / (numPoints - 1);
      outPoints.add(_getPointOnBezierCurve(points, offset, t));
    }
    return outPoints;
  }

  /// Find a single point position on the curve using 4 [points] at [t] percentage
  ///[offset] the starting index point
  Vector3 _getPointOnBezierCurve(List<Vector3> points, int offset, double t) {
    assert(points.length >= 4);

    final double invT = (1 - t);
    Vector3 p1 = points[offset + 0] * (invT * invT * invT);
    Vector3 p2 = points[offset + 1] * (3 * t * invT * invT);
    Vector3 p3 = points[offset + 2] * (3 * invT * t * t);
    Vector3 p4 = points[offset + 3] * (t * t * t);

    return p1 + p2 + p3 + p4;
  }

  /// This method defines if a curve needs to be split or not.
  /// This method decides for a given curve how flat it is.
  num flatness(List<Vector3> points, int offset) {
    final Vector3 p1 = points[offset + 0];
    final Vector3 p2 = points[offset + 1];
    final Vector3 p3 = points[offset + 2];
    final Vector3 p4 = points[offset + 3];

    num ux = 3 * p2[0] - 2 * p1[0] - p4[0];
    ux *= ux;
    num uy = 3 * p2[1] - 2 * p1[1] - p4[1];
    uy *= uy;
    num vx = 3 * p3[0] - 2 * p4[0] - p1[0];
    vx *= vx;
    num vy = 3 * p3[1] - 2 * p4[1] - p1[1];
    vy *= vy;

    if (ux < vx) {
      ux = vx;
    }

    if (uy < vy) {
      uy = vy;
    }

    return ux + uy;
  }

  ///[flatness] method can be used in the function that gets points for a curve.
  ///First, this check if the cuvry is too curvy. If so subdivide, if not we'll add the points in.
  ///This algorithm does a good job of making sure we have enough points but it
  ///doesn't do such a great job of getting rid of unneeded points.
  List<Vector3> getPointsOnBezierCurveWithSplitting(List<Vector3> points, int offset, double tolerance, List<Vector3> newPoints) {
    List<Vector3> outPoints = newPoints ?? new List<Vector3>();
    if (flatness(points, offset) < tolerance) {

      // just add the end points of this curve
      outPoints.add(points[offset + 0]);
      outPoints.add(points[offset + 3]);

    } else {

      // subdivide
      final double t = .5;
      final Vector3 p1 = points[offset + 0];
      final Vector3 p2 = points[offset + 1];
      final Vector3 p3 = points[offset + 2];
      final Vector3 p4 = points[offset + 3];

      final Vector3 q1 = UtilsMath.lerpVec3(p1, p2, t);
      final Vector3 q2 = UtilsMath.lerpVec3(p2, p3, t);
      final Vector3 q3 = UtilsMath.lerpVec3(p3, p4, t);

      final Vector3 r1 = UtilsMath.lerpVec3(q1, q2, t);
      final Vector3 r2 = UtilsMath.lerpVec3(q2, q3, t);

      final Vector3 red = UtilsMath.lerpVec3(r1, r2, t);

      // do 1st half
      getPointsOnBezierCurveWithSplitting([p1, q1, r1, red], 0, tolerance, outPoints);
      // do 2nd half
      getPointsOnBezierCurveWithSplitting([red, r2, q3, p4], 0, tolerance, outPoints);

    }
    return outPoints;
  }

  List<Vector3> simplifyPoints(List<Vector3> points, int startIndex, int endIndex, double epsilon, [List<Vector3> newPoints]) {
    List<Vector3> outPoints = newPoints ?? new List<Vector3>();

    // find the most distance point from the endpoints
    final Vector3 s = points[startIndex];
    final Vector3 e = points[endIndex - 1];
    num maxDistanceSquare = 0;
    int maxNdx = 1;
    for (int i = startIndex + 1; i < endIndex - 1; ++i) {
      final num distanceSquare = _distanceToSegmentSquare(points[i], s, e);
      if (distanceSquare > maxDistanceSquare) {
        maxDistanceSquare = distanceSquare;
        maxNdx = i;
      }
    }

    // if that point is too far
    if (Math.sqrt(maxDistanceSquare) > epsilon) {
      // split
      simplifyPoints(points, startIndex, maxNdx + 1, epsilon, outPoints);
      simplifyPoints(points, maxNdx, endIndex, epsilon, outPoints);

    } else {
      // add the 2 end points
      outPoints.addAll([s, e]);
    }

    return outPoints;
  }

  // compute the distance squared from p to the line segment
  // formed by v and w
  num _distanceToSegmentSquare(Vector3 p, Vector3 v, Vector3 w) {
    final num l2 = v.distanceToSquared(w);
    if (l2 == 0) {
      return p.distanceToSquared(v);
    }
    double t = ((p[0] - v[0]) * (w[0] - v[0]) + (p[1] - v[1]) * (w[1] - v[1])) / l2;
    t = Math.max(0, Math.min(1, t));
    return p.distanceToSquared(UtilsMath.lerpVec3(v, w, t));
  }
}
