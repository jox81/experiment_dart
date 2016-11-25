import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:async';
import 'package:webgl/src/materials.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/scene.dart';

Future<Mesh> createAxis(Scene scene) async {

  //Material
  MaterialPoint materialPoint = await MaterialPoint.create(5.0);
  scene.materials.add(materialPoint);

  Mesh mesh = new Mesh()
    ..mode = GL.LINES
    ..vertices = [
      0.0,0.0,0.0,
      1.0,0.0,0.0,
      0.0,0.0,0.0,
      0.0,1.0,0.0,
      0.0,0.0,0.0,
      0.0,0.0,1.0,
    ]
    ..colors = [
      1.0,0.0,0.0,1.0,
      1.0,0.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,0.0,1.0,1.0,
      0.0,0.0,1.0,1.0,
    ]
    ..material = materialPoint;

  scene.meshes.add(mesh);

  return mesh;
}

//Points
Future<Mesh> createAxisPoints(MaterialPoint materialPoint) async {

  Mesh mesh = new Mesh()
    ..mode = GL.POINTS
    ..vertices = [
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 0.0, 1.0,
    ]
    ..colors = [
      1.0, 1.0, 0.0, 1.0,
      1.0, 0.0, 0.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
    ]
    ..material = materialPoint;

  return mesh;
}

Future<Mesh> createPoint(MaterialPoint materialPoint) async {

  Mesh mesh = new Mesh()
    ..mode = GL.POINTS
    ..vertices = [
      0.0, 0.0, 0.0,
    ]
    ..colors = [
      1.0, 1.0, 0.0, 1.0,
    ]
    ..material = materialPoint;

  return mesh;
}

class FrustrumGizmo implements IGizmo{

  Camera _camera;
  Matrix4 get _vpmatrix => _camera.vpMatrix;

  final c0 = new Vector3.zero();
  final c1 = new Vector3.zero();
  final c2 = new Vector3.zero();
  final c3 = new Vector3.zero();
  final c4 = new Vector3.zero();
  final c5 = new Vector3.zero();
  final c6 = new Vector3.zero();
  final c7 = new Vector3.zero();
  List<Vector3> get _frustrumCornersVectors => [c0,c1,c2,c3,c4,c5,c6,c7];

  @override
  List<Mesh> gizmoMeshes = [];

  FrustrumGizmo._internal();

  static  Future<FrustrumGizmo> create(Camera camera)async {
    FrustrumGizmo model = new FrustrumGizmo._internal()
    .._camera = camera;
    await model._createFrustrumModel(camera.vpMatrix);
    return model;
  }

  Future _createFrustrumModel(Matrix4 cameraMatrix) async {
    MaterialPoint materialPoint = await MaterialPoint.create(5.0);

    for(int i = 0; i < _frustrumCornersVectors.length; i++){
      gizmoMeshes.add(await createPoint(materialPoint));
    }

    updateGizmo();
  }

  @override
  void updateGizmo() {
    new Frustum.matrix(_vpmatrix)
      ..calculateCorners(c0, c1, c2, c3, c4, c5, c6, c7);

    for(int i = 0; i < _frustrumCornersVectors.length; i++){
      gizmoMeshes[i]
        ..transform.setTranslation(_frustrumCornersVectors[i]);
    }
  }
}
