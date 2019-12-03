import 'dart:async';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/gltf.dart';
import 'package:webgl/src/curve/bezier_curve2.dart';

class CloundCurvesProject extends GLTFProject {
  final int pointCount = 1600;

  CloundCurvesProject._();
  static Future<CloundCurvesProject> build() async {
    await AssetLibrary.loadDefault();
    return await new CloundCurvesProject._()
      .._setup();
  }

  void _setup() {
    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    mainCamera = new GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3(0.0, 0.0, 0.0)
      ..translation = new Vector3(200.0, 200.0, 200.0);

    //>

    GLTFNode generatePoint(int index) {
      GLTFNode point = new GLTFNode.point()
        ..translation = (((new Vector3.random() - new Vector3(.5, .5, .5)) *
            100) ..multiply(new Vector3(4.0,3.0,4.0)));
      (point.material as MaterialPoint)
        ..pointSize = 2.5
        ..color = new Vector4(0.0, 0.0, 0.0, 1.0);
      scene.addNode(point);
      return point;
    }

    List<GLTFNode> points =
        new List<GLTFNode>.generate(pointCount, generatePoint);

    Random random = new Random();
    GLTFNode firstPoint = points[random.nextInt(points.length)];
    (firstPoint.material as MaterialPoint)
      ..pointSize = 6
      ..color = new Vector4(0.0, 0.0, 1.0, 1.0);

    generateDirectNearestLine(points.toList(), firstPoint);
//    generateDirectNearestCurve(points.toList(), firstPoint);
//    generateNearestThreeLines(points.toList(), firstPoint);
  }

  GLTFNode getNearestPoint(GLTFNode startPoint, List<GLTFNode> points) {
    num minDistance;
    GLTFNode point;
    points.forEach((p) {
      num distance = startPoint.translation.distanceTo(p.translation);
      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        point = p;
      }
    });
    return point;
  }

  void generateDirectNearestLine(List<GLTFNode> points, GLTFNode firstPoint) {
    Random random = new Random();

    List<GLTFNode> restPoints = points.toList();
    List<GLTFNode> currentPoints = [];

    currentPoints.add(firstPoint);
    restPoints.remove(firstPoint);

    GLTFNode lastPoint = firstPoint;

    GLTFNode generateNearestDirectCurve(int index) {
      int loopCount = restPoints.length;
      for (var i = 0; i < loopCount; ++i) {
        GLTFNode nearestPoint = getNearestPoint(lastPoint, restPoints);
        currentPoints.add(nearestPoint);
        restPoints.remove(nearestPoint);
        lastPoint = nearestPoint;
      }

      GLTFNode curve =
          new GLTFNode.line(currentPoints.map((n) => n.translation).toList());
      curve.material = new MaterialBaseColor(new Vector4(0.866, 0.431, 0.023, 1.0));
      scene.addNode(curve);
      return curve;
    }

    new List<GLTFNode>.generate(1, generateNearestDirectCurve);
  }

  void generateDirectNearestCurve(List<GLTFNode> points, GLTFNode firstPoint,
      {bool useCurve: true}) {
    Random random = new Random();

    List<GLTFNode> restPoints = points.toList();
    List<GLTFNode> currentPoints = [];

    currentPoints.add(firstPoint);
    restPoints.remove(firstPoint);

    GLTFNode lastPoint = firstPoint;

    GLTFNode generateNearestDirectCurve(int index) {
      int loopCount = restPoints.length;
      for (int i = 0; i < loopCount; ++i) {
        GLTFNode nearestPoint = getNearestPoint(lastPoint, restPoints);
        currentPoints.add(nearestPoint);
        restPoints.remove(nearestPoint);
        lastPoint = nearestPoint;
      }

      List<Vector3> linePoints = [];
      if (useCurve) {
        List<Vector3> basePoints = points.map((n)=> n.translation).toList();
        BezierCurve2 bezierCurve = new BezierCurve2(basePoints);
        linePoints = bezierCurve.getCurvePoints(basePoints, 0.001);
      } else {
        linePoints = currentPoints.map((n) => n.translation).toList();
      }

      GLTFNode curve = new GLTFNode.line(linePoints);
      curve.material = new MaterialBaseColor(new Vector4(0.133, 0.341, 0.478, 1.0));
      scene.addNode(curve);
      return curve;
    }

    List<GLTFNode> curves =
        new List<GLTFNode>.generate(1, generateNearestDirectCurve);
  }

  void generateNearestThreeLines(List<GLTFNode> points, GLTFNode firstPoint) {
    List<GLTFNode> restPoints = points.toList();

    List<GLTFNode> currentPoints = [];

    currentPoints.add(firstPoint);
    restPoints.remove(firstPoint);

    GLTFNode getNearestCurve(int index) {
      num minDistance;
      GLTFNode fromPoint;
      GLTFNode toPoint;

      for (GLTFNode currentPoint in currentPoints) {
        GLTFNode nearestPoint = getNearestPoint(currentPoint, restPoints);
        num distance =
            currentPoint.translation.distanceTo(nearestPoint.translation);

        if (minDistance == null || distance < minDistance) {
          minDistance = distance;
          fromPoint = currentPoint;
          toPoint = nearestPoint;
        }
      }

      currentPoints.add(toPoint);
      restPoints.remove(toPoint);

      GLTFNode curve = new GLTFNode.line(
          [fromPoint, toPoint].map((p) => p.translation).toList());
      curve.material = new MaterialBaseColor(new Vector4(0.0, 0.0, 0.0, 1.0));
      scene.addNode(curve);
      return curve;
    }

    List<GLTFNode> curves =
        new List<GLTFNode>.generate(points.length - 1, getNearestCurve);
  }
}
