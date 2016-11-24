import 'package:vector_math/vector_math.dart';
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

class FrustrumModel{

  Frustum frustum;

  final c0 = new Vector3.zero();
  final c1 = new Vector3.zero();
  final c2 = new Vector3.zero();
  final c3 = new Vector3.zero();
  final c4 = new Vector3.zero();
  final c5 = new Vector3.zero();
  final c6 = new Vector3.zero();
  final c7 = new Vector3.zero();
  List<Vector3> get frustrumCornersVectors => [c0,c1,c2,c3,c4,c5,c6,c7];

  List<Mesh> frustrumCorners = [];

  FrustrumModel._internal(Matrix4 matrix){
    frustum = new Frustum.matrix(matrix);
  }

  static  Future<FrustrumModel> create(Matrix4 cameraMatrix)async {
    FrustrumModel model = new FrustrumModel._internal(cameraMatrix);
    await model._createFrustrumModel(cameraMatrix);
    return model;
  }

  ///Test point frusturm corner
  Future _createFrustrumModel(Matrix4 cameraMatrix) async {
    MaterialPoint materialPoint = await MaterialPoint.create(5.0);

    for(int i = 0; i < frustrumCornersVectors.length; i++){
      frustrumCorners.add(await createPoint(materialPoint));
    }

    update(cameraMatrix);

  }

  void update(Matrix4 matrix) {
    frustum = new Frustum.matrix(matrix);
    frustum.calculateCorners(c0, c1, c2, c3, c4, c5, c6, c7);

    for(int i = 0; i < frustrumCornersVectors.length; i++){
      frustrumCorners[i]
        ..transform.setTranslation(frustrumCornersVectors[i]);
    }
  }
}
