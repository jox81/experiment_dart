import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/materials.dart';

Vector4 _defaultModelColor = new Vector4(1.0,0.5,0.0,1.0);

abstract class Model extends IEditElement {

  String name; //Todo : S'assurer que les noms soient uniques ?!
  Mesh mesh = new Mesh();
  IGizmo gizmo;

  bool visible = true;

  //Transform : position, rotation, scale
  Matrix4 transform = new Matrix4.identity();

  Vector3 get position => transform.getTranslation();
  set position(Vector3 value) => transform.setTranslation(value);

  Material material;

  //Animation
  UpdateFunction updateFunction;

  void render() {

    if (material == null) {
      throw new Exception(
          "Can't render object : the material mustn't be null to render the mesh in ${this.runtimeType}");
    }

    if(!visible)return;

    material.render(this);
  }

  List<Triangle> get faces {
    List<Triangle> _faces = [];
    for(Triangle triangle in mesh.faces){
      _faces.add(new Triangle.points(transform * triangle.point0, transform * triangle.point1, transform * triangle.point2));
    }
    return _faces;
  }

}

class CustomObject extends Model {
  CustomObject();
}

class JsonObject extends Model {
  JsonObject(Map jsonFile){
    mesh
      ..vertices = jsonFile['meshes'][0]['vertices']
      ..indices = jsonFile['meshes'][0]['faces']
          .expand((i) => i)
          .toList()
      ..textureCoords = jsonFile['meshes'][0]['texturecoords'][0]
      ..vertexNormals = jsonFile['meshes'][0]['normals'];
    material = new MaterialBase();
  }
}

class PointModel extends Model {
  PointModel() {
    mesh = new Mesh.Point();
    material = new MaterialPoint(pointSize:5.0 ,color:_defaultModelColor);
  }
}

class LineModel extends Model {
  final Vector3 point1, point2;

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

class MultiLineModel extends Model {
  MultiLineModel(List<Vector3> points) {
    mesh = new Mesh.Line(points);
    material = new MaterialBase();
  }
}

class TriangleModel extends Model {
  TriangleModel() {
    mesh = new Mesh.Triangle();
    material = new MaterialBase();
  }
}

class QuadModel extends Model {
  QuadModel() {
    mesh = new Mesh.Rectangle();
    material = new MaterialBase();
  }
}

class PyramidModel extends Model {
  PyramidModel() {
    mesh = new Mesh.Pyramid();
    material = new MaterialBase();
  }
}

class CubeModel extends Model {
  CubeModel() {
    mesh = new Mesh.Cube();
    material = new MaterialBase();
  }
}

class SphereModel extends Model {
  SphereModel({num radius: 1, int segmentV: 32, int segmentH: 32}) {
    mesh =
        new Mesh.Sphere(radius: radius, segmentV: segmentV, segmentH: segmentH);
    material = new MaterialBase();
  }
}

//Todo : create a CompoundObjectModel

class AxisModel extends Model {
  AxisModel() {
    mesh = new Mesh.Axis();
    material = new MaterialPoint();
  }
}

class AxisPointsModel extends Model {
  AxisPointsModel() {
    mesh = new Mesh.AxisPoints();
    material = new MaterialPoint(pointSize:5.0);
  }
}

class FrustrumGizmo extends Model implements IGizmo {

  @override
  bool visible = false;

  final Camera _camera;
  Matrix4 get _vpmatrix => _camera.vpMatrix;

  Vector4 _positionColor = new Vector4(0.0, 1.0, 1.0, 1.0);
  Vector4 _frustrumColor = new Vector4(0.0, 0.7, 1.0, 1.0);

  num _positionPointSize = 6.0;


  //near
  final Vector3 c0 = new Vector3.zero();
  final Vector3 c1 = new Vector3.zero();
  final Vector3 c2 = new Vector3.zero();
  final Vector3 c3 = new Vector3.zero();
  //far
  final Vector3 c4 = new Vector3.zero();
  final Vector3 c5 = new Vector3.zero();
  final Vector3 c6 = new Vector3.zero();
  final Vector3 c7 = new Vector3.zero();

  @override
  List<Model> gizmoModels = [];

  FrustrumGizmo(Camera camera):
        _camera = camera{;
    _createFrustrumModel(_camera.vpMatrix);
  }

  _createFrustrumModel(Matrix4 cameraMatrix) {
    MaterialPoint frustrumPositionPointMaterial =
        new MaterialPoint(pointSize:_positionPointSize, color: _positionColor);

    MaterialBaseColor frustrumDirectionLineMaterial =
        new MaterialBaseColor(_frustrumColor);

    //near plane
    gizmoModels.add(new LineModel(c0, c1)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c1, c2)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c2, c3)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c3, c0)
      ..material = frustrumDirectionLineMaterial);

    //far plane
    gizmoModels.add(new LineModel(c4, c5)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c5, c6)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c6, c7)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c7, c4)
      ..material = frustrumDirectionLineMaterial);

    //sides
    gizmoModels.add(new LineModel(c0, c4)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c1, c5)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c2, c6)
      ..material = frustrumDirectionLineMaterial);
    gizmoModels.add(new LineModel(c3, c7)
      ..material = frustrumDirectionLineMaterial);

    gizmoModels.add(new LineModel(_camera.position, _camera.targetPosition)
          ..material = frustrumDirectionLineMaterial);

    gizmoModels
        .add(new PointModel()
        ..position = _camera.position
        ..material = frustrumPositionPointMaterial); //position
    gizmoModels
        .add(new PointModel()
          ..position = _camera.targetPosition
          ..material = frustrumPositionPointMaterial); //target

    updateGizmo();
  }

  @override
  void updateGizmo() {
    //Update only final positions
    new Frustum.matrix(_vpmatrix)
      ..calculateCorners(c5, c4, c0, c1, c6, c7, c3, c2);
  }

  @override
  void render(){
    if(!visible)return;
    for(Model model in gizmoModels){
      model.render();
    }
  }

}
