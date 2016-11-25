import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:async';
import 'package:webgl/src/materials.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/object3d.dart';
import 'package:webgl/src/scene.dart';

Mesh createAxis(Scene scene) {

  //Material
  MaterialPoint materialPoint = new MaterialPoint(5.0);
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
Mesh createAxisPoints(MaterialPoint materialPoint) {

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

Mesh createPoint(MaterialPoint materialPoint) {

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

  num frustrumPointSize = 3.0;
  Vector4 frustrumColor = new Vector4(0.0,0.7,1.0,1.0);

  num positionPointSize = 6.0;
  Vector4 positionColor = new Vector4(0.0,1.0,1.0,1.0);

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

  FrustrumGizmo(Camera camera) {
    _camera = camera;
    _createFrustrumModel(camera.vpMatrix);
  }

  _createFrustrumModel(Matrix4 cameraMatrix) {
    MaterialPoint materialFrustrum = new MaterialPoint(frustrumPointSize, color:frustrumColor);
    MaterialPoint materialPosition = new MaterialPoint(positionPointSize, color:positionColor);

    for(int i = 0; i < _frustrumCornersVectors.length; i++){
      gizmoMeshes.add(createPoint(materialFrustrum));
    }

    gizmoMeshes.add(createPoint(materialPosition));//position
    gizmoMeshes.add(createPoint(materialPosition));//target

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

    gizmoMeshes[8].transform.setTranslation(_camera.position);
    gizmoMeshes[9].transform.setTranslation(_camera.targetPosition);

  }
}


class CutomObject extends Object3d{

  CutomObject(Mesh mesh){
    super.mesh = mesh;
  }

  @override
  void render() {
    mesh.render();
  }

}

class Line extends Object3d{

  Vector3 point1, point2;

  Line(this.point1, this.point2){
    mesh = new Mesh.Line([point1, point2])
    ..material = new MaterialBaseColor(
        new Vector3(1.0, 0.0, 1.0));
  }

  @override
  void render() {
    mesh.render();
  }
}
