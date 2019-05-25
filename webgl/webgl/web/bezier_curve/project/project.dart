import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/gltf.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/curve/bezier_curve.dart';

class BezierProject extends GLTFProject{

  BezierProject._();
  static Future<BezierProject> build() async {
    await AssetLibrary.loadDefault();
    return new BezierProject._().._setup();
  }

  MaterialPoint _materialPoint;
  MaterialPoint get materialPoint => _materialPoint ??= new MaterialPoint(pointSize:10.0, color:new Vector4(0.0, 0.66, 1.0, 1.0));

  void _setup() {

    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    mainCamera = new
    GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition =  new Vector3(10.0, 0.0, 0.0)
      ..translation = new Vector3(20.0, 20.0, 20.0);

    //>

    GLTFNode point1 = new GLTFNode.point(name:'point1')
      ..translation = new Vector3(0.0, 0.0, 0.0);
    (point1.material as MaterialPoint).color = new Vector4(1.0, 0.0, 0.0, 1.0);
    scene.addNode(point1);

    GLTFNode pointControlAfter1 = new GLTFNode.point(name:'pointControlAfter1')
      ..translation = new Vector3(0.0, 5.0, 0.0);
    (pointControlAfter1.material as MaterialPoint).color = new Vector4(0.5, 0.5, 0.5, 1.0);
    scene.addNode(pointControlAfter1);

    GLTFNode pointControlBefore2 = new GLTFNode.point(name:'pointControlBefore2')
      ..translation = new Vector3(8.0, 3.0, 0.0);
    (pointControlBefore2.material as MaterialPoint).color = new Vector4(0.5, 0.5, 0.5, 1.0);
    scene.addNode(pointControlBefore2);

    GLTFNode point2 = new GLTFNode.point(name:'point2')
      ..translation = new Vector3(5.0, 0.0, 0.0);
    scene.addNode(point2);

    //> Todo (jpu) : how to add more point to the curve?

    // To be smooth, cthis control point must be adapted to be mirrored from last point
    GLTFNode pointControlAfter2Auto = new GLTFNode.point(name:'pointControlAfter2Auto')
      ..translation = point2.translation + (point2.translation - pointControlBefore2.translation) * 1;
    (pointControlAfter2Auto.material as MaterialPoint).color = new Vector4(0.0, 0.0, 0.0, 1.0);
    scene.addNode(pointControlAfter2Auto);

    GLTFNode pointControlBefore3 = new GLTFNode.point(name:'pointControlBefore3')
      ..translation = new Vector3(0.0, 5.0, -2.0);
    (pointControlBefore3.material as MaterialPoint).color = new Vector4(0.5, 0.5, 0.5, 1.0);
    scene.addNode(pointControlBefore3);

    GLTFNode point3 = new GLTFNode.point(name:'point3')
      ..translation = new Vector3(5.0, 5.0, -2.0);
    scene.addNode(point3);

    List<GLTFNode> points = [
      point1,
      pointControlAfter1,
      pointControlBefore2,
      point2,
      pointControlAfter2Auto,
      pointControlBefore3,
      point3,
    ];
    List<Vector3> basePoints = points.map((n)=> n.translation).toList();

    BezierCurve bezierCurve = new BezierCurve();

    List<Vector3> curvedPointPositions = new List<Vector3>();

    curvedPointPositions.addAll(bezierCurve.getPointsOnBezierCurves(basePoints, 0.001));

    bezierCurve.simplifyPoints(curvedPointPositions, 0, curvedPointPositions.length,0.01);

    GLTFNode curve = new GLTFNode.line(curvedPointPositions, name:'curve');
    scene.addNode(curve);

  }

  void update({num currentTime : 0.0}) {
  }

  void play(){
  }
}