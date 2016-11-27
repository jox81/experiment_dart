import 'dart:collection';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/materials.dart';

Vector4 _defaultModelColor = new Vector4(1.0,0.5,0.0,1.0);

abstract class Object3d {
  String name; //Todo : S'assurer que les noms soient uniques ?!
  Mesh mesh;
  IGizmo gizmo;

  //Transform : position, rotation, scale
  Matrix4 transform = new Matrix4.identity();

  Vector3 position = new Vector3.zero(); //needed ?

  Material material;

  void render() {
    if (material == null) {
      throw new Exception(
          "Can't render object : the material mustn't be null to render the mesh in ${this.runtimeType}");
    }

    material.render(this);
  }
}

class CustomObject extends Object3d {
  CustomObject();
}

class JsonObject extends Object3d {
  JsonObject(Map jsonFile){
    mesh = new Mesh()
      ..vertices = jsonFile['meshes'][0]['vertices']
      ..indices = jsonFile['meshes'][0]['faces']
          .expand((i) => i)
          .toList()
      ..textureCoords = jsonFile['meshes'][0]['texturecoords'][0]
      ..vertexNormals = jsonFile['meshes'][0]['normals'];
    material = new MaterialBase();
  }
}

class PointModel extends Object3d {
  PointModel() {
    mesh = new Mesh.Point();
    material = new MaterialPoint(pointSize:5.0 ,color:_defaultModelColor);
  }
}

class LineModel extends Object3d {
  Vector3 point1, point2;

  LineModel(this.point1, this.point2) {
    mesh = new Mesh.Line([point1, point2]);
    material = new MaterialBase();
  }

  @override
  void render() {
    _update();
    super.render();
  }

  _update(){
    mesh.vertices = [];
    mesh.vertices
      ..addAll(point1.storage)
      ..addAll(point2.storage);
  }
}

class MultiLineModel extends Object3d {
  MultiLineModel(List<Vector3> points) {
    mesh = new Mesh.Line(points);
    material = new MaterialBase();
  }
}

class TriangleModel extends Object3d {
  TriangleModel() {
    mesh = new Mesh.Triangle();
    material = new MaterialBase();
  }
}

class QuadModel extends Object3d {
  QuadModel() {
    mesh = new Mesh.Rectangle();
    material = new MaterialBase();
  }
}

class PyramidModel extends Object3d {
  PyramidModel() {
    mesh = new Mesh.Pyramid();
    material = new MaterialBase();
  }
}

class CubeModel extends Object3d {
  CubeModel() {
    mesh = new Mesh.Cube();
    material = new MaterialBase();
  }
}

class SphereModel extends Object3d {
  SphereModel({num radius: 1, int segmentV: 32, int segmentH: 32}) {
    mesh =
        new Mesh.Sphere(radius: radius, segmentV: segmentV, segmentH: segmentH);
    material = new MaterialBase();
  }
}

//Todo : create a CompoundObjectModel

class AxisModel extends Object3d {
  AxisModel() {
    mesh = new Mesh.Axis();
    material = new MaterialPoint();
  }
}

class AxisPointsModel extends Object3d {
  AxisPointsModel() {
    mesh = new Mesh.AxisPoints();
    material = new MaterialPoint(pointSize:5.0);
  }
}

class FrustrumGizmo implements IGizmo {
  Camera _camera;
  Matrix4 get _vpmatrix => _camera.vpMatrix;

  num frustrumPointSize = 3.0;
  Vector4 frustrumColor = new Vector4(0.0, 0.7, 1.0, 1.0);

  num positionPointSize = 6.0;
  Vector4 positionColor = new Vector4(0.0, 1.0, 1.0, 1.0);
  PointModel positionModel;
  PointModel targetPositionModel;

  final c0 = new Vector3.zero();
  final c1 = new Vector3.zero();
  final c2 = new Vector3.zero();
  final c3 = new Vector3.zero();
  final c4 = new Vector3.zero();
  final c5 = new Vector3.zero();
  final c6 = new Vector3.zero();
  final c7 = new Vector3.zero();
  List<Vector3> get _frustrumCornersVectors => [c0, c1, c2, c3, c4, c5, c6, c7];

  LineModel diretionLine;

  @override
  List<Object3d> gizmoMeshes = [];

  FrustrumGizmo(Camera camera) {
    _camera = camera;
    _createFrustrumModel(camera.vpMatrix);
  }

  _createFrustrumModel(Matrix4 cameraMatrix) {
    MaterialPoint frustrumPointMaterial =
        new MaterialPoint(pointSize:frustrumPointSize, color: frustrumColor);
    MaterialPoint frustrumPositionPointMaterial =
        new MaterialPoint(pointSize:positionPointSize, color: frustrumColor);
    MaterialBaseColor frustrumDirestionLineMaterial =
        new MaterialBaseColor(new Vector3(0.0, 1.0, 1.0));

    for (int i = 0; i < _frustrumCornersVectors.length; i++) {
      gizmoMeshes.add(new PointModel()..material = frustrumPointMaterial);
    }

    gizmoMeshes
        .add(positionModel = new PointModel()..material = frustrumPositionPointMaterial); //position
    gizmoMeshes
        .add(targetPositionModel = new PointModel()..material = frustrumPositionPointMaterial); //target

    gizmoMeshes.add(
        diretionLine = new LineModel(_camera.position, _camera.targetPosition)
          ..material = frustrumDirestionLineMaterial);

    updateGizmo();
  }

  @override
  void updateGizmo() {
    new Frustum.matrix(_vpmatrix)
      ..calculateCorners(c0, c1, c2, c3, c4, c5, c6, c7);

    for (int i = 0; i < _frustrumCornersVectors.length; i++) {
      gizmoMeshes[i].transform.setTranslation(_frustrumCornersVectors[i]);
    }

    positionModel.position = _camera.position;
    targetPositionModel.position = _camera.targetPosition;

    diretionLine.point1.setFrom(_camera.position);
    diretionLine.point2.setFrom(_camera.targetPosition);
  }
}
