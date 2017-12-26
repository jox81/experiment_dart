import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/node.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/geometry/mesh_primitive.dart';
import 'package:webgl/src/material/material.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/utils/utils_math.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
@MirrorsUsed(targets: const [
  ModelType,
  Mesh,
  CustomObject,
  JsonObject,
  PointModel,
  LineModel,
  MultiLineModel,
  TriangleModel,
  QuadModel,
  PyramidModel,
  CubeModel,
  SphereModel,
  AxisModel,
  AxisPointsModel,
  FrustrumGizmo,
  GridModel,
  TorusModel,
  SkyBoxModel,
  VectorModel,

], override: '*')
import 'dart:mirrors';

Vector4 _defaultModelColor = new Vector4(1.0, 0.5, 0.0, 1.0);

enum ModelType {
  point,
  line,
  triangle,
  quad,
  pyramid,
  cube,
  sphere,
  torus,
  axis,
  grid,
  custom,
  json,
  multiLine,
  vector,
  skyBox,
  axisPoints,
}

abstract class Mesh extends Node {

  ModelType modelType;

  MeshPrimitive _primitive = new MeshPrimitive();
  MeshPrimitive get primitive => _primitive;
  set primitive(MeshPrimitive value) => _primitive = value;

  /// This Material override all primitives Materials
  Material get material => _primitive.material;
  set material(Material value) => _primitive.material = value; //Animation

  IGizmo _gizmo;
  IGizmo get gizmo => _gizmo;
  set gizmo(IGizmo value) => _gizmo = value;

  UpdateFunction _updateFunction;
  UpdateFunction get updateFunction => _updateFunction;
  set updateFunction(UpdateFunction value) => _updateFunction = value;

  List<Triangle> _faces;
  List<Triangle> getFaces() {
    _faces = new List();
    for (Triangle triangle in primitive.getFaces()) {
      _faces.add(new Triangle.copy(triangle)..transform(matrix));
    }
    return _faces;
  }

  void update(){
    super.update();
    primitive.material.update(this);
  }

  void render() {
    if (primitive.material == null) {
      throw new Exception(
          "Can't render object : the material mustn't be null to render the mesh in ${this.runtimeType}");
    }

    if (!visible) return;

    primitive.material.render(this);
  }

  factory Mesh.createByType(ModelType modelType, {bool doInitMaterial: true}) {
    Mesh newModel;
    switch (modelType) {
      case ModelType.point:
        newModel = new PointModel(doInitMaterial: doInitMaterial);
        break;
      case ModelType.line:
        newModel = new LineModel(
            new Vector3(-1.0, 0.0, 0.0), new Vector3(1.0, 0.0, 0.0));
        break;
      case ModelType.triangle:
        newModel = new TriangleModel(doInitMaterial: doInitMaterial);
        break;
      case ModelType.quad:
        newModel = new QuadModel(doInitMaterial: doInitMaterial);
        break;
      case ModelType.pyramid:
        newModel = new PyramidModel(doInitMaterial: doInitMaterial);
        break;
      case ModelType.cube:
        newModel = new CubeModel(doInitMaterial: doInitMaterial);
        break;
      case ModelType.sphere:
        newModel = new SphereModel(doInitMaterial: doInitMaterial);
        break;
//      case ModelType.torus:
//        newModel = new TorusModel(doInitMaterial:doInitMaterial);
//        break;
      case ModelType.axis:
        newModel = new AxisModel(doInitMaterial: doInitMaterial);
        break;
      case ModelType.grid:
        newModel = new GridModel(doInitMaterial: doInitMaterial);
        break;
      default:
        break;
    }
    return newModel;
  }

  Mesh() {
//    throw new Exception("Don't use this CTOR");
  }

  // >> JSON

  factory Mesh.fromJson(Map json) {
    ModelType modelType = ModelType.values.firstWhere(
        (m) => m.toString() == json["type"],
        orElse: () => null);

    Mesh object3d = new Mesh.createByType(modelType, doInitMaterial: true)
      ..name = json["name"].toString();
//      ..rotation = new Matrix3.fromList(json["rotation"])
//      ..scale = ??;
    if(json["position"] != null) {
      object3d.translation = new Vector3.fromFloat32List(new Float32List.fromList(json["position"]as List<double>));
    }
    if(json["transform"] != null) {
      object3d.matrix = new Matrix4.fromFloat32List(new Float32List.fromList(json["transform"] as List<double>));
    }
    return object3d;
  }

  Map toJson() {
    Map json = new Map<String, dynamic>();
    json["type"] = modelType.toString();
    json["name"] = name;
//    json["position"] = position.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
//    json["rotation"] = rotation.storage;//.map((v)=>UtilsMath.roundPrecision(v)).toList();
//    json["scale"] = ??;
    json["transform"] = matrix.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
    return json;
  }
}

class CustomObject extends Mesh {
  ModelType get modelType => ModelType.custom;
  CustomObject();
}

class JsonObject extends Mesh {
  ModelType get modelType => ModelType.json;
  JsonObject(Map jsonFile, {bool doInitMaterial: true}) {
    primitive
      ..vertices = jsonFile['meshes'][0]['vertices'] as List<double>
      ..indices = (jsonFile['meshes'][0]['faces']).expand((List<int> i) => i).toList() as List<int>
      ..textureCoords = jsonFile['meshes'][0]['texturecoords'][0] as List<double>
      ..vertexNormals = jsonFile['meshes'][0]['normals'] as List<double>
      ..material = new MaterialBase();
  }
}

class PointModel extends Mesh {
  ModelType get modelType => ModelType.point;
  PointModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Point()
    ..material = doInitMaterial
        ? new MaterialPoint(pointSize: 5.0, color: _defaultModelColor)
        : null;
  }
}

class LineModel extends Mesh {
  ModelType get modelType => ModelType.line;

  final Vector3 point1, point2;

  LineModel(this.point1, this.point2, {bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Line([point1, point2])
    ..material = doInitMaterial ? new MaterialBase() : null;
  }

  @override
  void render() {
    _update();
    super.render();
  }

  void _update() {
    primitive.vertices = [];
    primitive.vertices..addAll(point1.storage)..addAll(point2.storage);
  }
}

class MultiLineModel extends Mesh {
  ModelType get modelType => ModelType.multiLine;
  MultiLineModel(List<Vector3> points, {bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Line(points)
    ..material = doInitMaterial ? new MaterialBase() : null;
  }
}

class TriangleModel extends Mesh {
  ModelType get modelType => ModelType.triangle;
  TriangleModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Triangle()
    ..material = doInitMaterial ? new MaterialBase() : null;
  }
}

class QuadModel extends Mesh {
  ModelType get modelType => ModelType.quad;
  QuadModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Rectangle()
    ..material = doInitMaterial ? new MaterialBase() : null;
  }
}

class PyramidModel extends Mesh {
  ModelType get modelType => ModelType.pyramid;
  PyramidModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Pyramid()
    ..material = doInitMaterial ? new MaterialBase() : null;
  }
}

class CubeModel extends Mesh {
  ModelType get modelType => ModelType.cube;
  CubeModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Cube()
    ..material = doInitMaterial ? new MaterialBase() : null;
  }
}

class SphereModel extends Mesh {
  ModelType get modelType => ModelType.sphere;
  SphereModel(
      {double radius: 1.0,
      int segmentV: 16,
      int segmentH: 16,
      bool doInitMaterial: true}) {
    primitive =
        new MeshPrimitive.Sphere(radius: radius, segmentV: segmentV, segmentH: segmentH)
    ..material = doInitMaterial ? new MaterialBase() : null;
  }
}

//Todo : create a CompoundObjectModel

class AxisModel extends Mesh {
  ModelType get modelType => ModelType.axis;
  AxisModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Axis()
    ..material = doInitMaterial ? new MaterialPoint() : null;
  }
}

class AxisPointsModel extends Mesh {
  ModelType get modelType => ModelType.axisPoints;
  AxisPointsModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.AxisPoints()
    ..material = doInitMaterial ? new MaterialPoint(pointSize: 5.0) : null;
  }
}

class FrustrumGizmo extends Mesh implements IGizmo {
  @override
  bool visible = false;

  final CameraPerspective _camera;
  Matrix4 get _vpmatrix => _camera.viewProjectionMatrix;

  Vector4 _positionColor = new Vector4(0.0, 1.0, 1.0, 1.0);
  Vector4 _frustrumColor = new Vector4(0.0, 0.7, 1.0, 1.0);

  num _positionPointSize = 6.0;

  //camera
  final Vector3 cameraPosition = new Vector3.zero();
  final Vector3 cameraTargetPosition = new Vector3.zero();
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

  final PointModel cameraPositionPoint = new PointModel();
  final PointModel cameraTargetPositionPoint = new PointModel();

  @override
  List<Mesh> gizmoModels = [];

  FrustrumGizmo(CameraPerspective camera) : _camera = camera {
    _createFrustrumModel(_camera.viewProjectionMatrix);
  }

  void _createFrustrumModel(Matrix4 cameraMatrix) {
    MaterialPoint frustrumPositionPointMaterial =
        new MaterialPoint(pointSize: _positionPointSize, color: _positionColor);

    MaterialBaseColor frustrumDirectionLineMaterial =
        new MaterialBaseColor(_frustrumColor);

    //near plane
    gizmoModels
        .add(new LineModel(c0, c1)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c1, c2)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c2, c3)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c3, c0)..primitive.material = frustrumDirectionLineMaterial);

    //far plane
    gizmoModels
        .add(new LineModel(c4, c5)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c5, c6)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c6, c7)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c7, c4)..primitive.material = frustrumDirectionLineMaterial);

    //sides
    gizmoModels
        .add(new LineModel(c0, c4)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c1, c5)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c2, c6)..primitive.material = frustrumDirectionLineMaterial);
    gizmoModels
        .add(new LineModel(c3, c7)..primitive.material = frustrumDirectionLineMaterial);

    gizmoModels.add(new LineModel(cameraPosition, cameraTargetPosition)
      ..primitive.material = frustrumDirectionLineMaterial);

    gizmoModels.add(cameraPositionPoint
      ..primitive.material = frustrumPositionPointMaterial); //position
    gizmoModels.add(cameraTargetPositionPoint
      ..primitive.material = frustrumPositionPointMaterial); //target

    updateGizmo();
  }

  @override
  void updateGizmo() {
    //Update only final positions
    new Frustum.matrix(_vpmatrix)
      ..calculateCorners(c5, c4, c0, c1, c6, c7, c3, c2);

    cameraPosition.setFrom(_camera.translation);
    cameraTargetPosition.setFrom(_camera.targetPosition);

    cameraPositionPoint..translation = _camera.translation;
    cameraTargetPositionPoint..translation = _camera.targetPosition;
  }

  @override
  void render() {
    if (!visible) return;
    for (Mesh model in gizmoModels) {
      model.render();
    }
  }
}

class GridModel extends Mesh {
  ModelType get modelType => ModelType.grid;
  GridModel({bool doInitMaterial: true}) {
    int gridHalfWidthCount = 5;
    constructGrid(gridHalfWidthCount);

    primitive.material = doInitMaterial
        ? new MaterialBaseColor(new Vector4(0.5, 0.5, 0.5, 1.0))
        : null;
  }

  void constructGrid(int gridHalfWidthCount) {
    List<Vector3> points = [];
    for (int i = -gridHalfWidthCount; i <= gridHalfWidthCount; i++) {
      Vector3 p1 =
          new Vector3(i.toDouble(), 0.0, gridHalfWidthCount.toDouble());
      Vector3 p2 =
          new Vector3(i.toDouble(), 0.0, -gridHalfWidthCount.toDouble());
      points.add(p1);
      points.add(p2);
    }
    for (int i = -gridHalfWidthCount; i <= gridHalfWidthCount; i++) {
      Vector3 p1 =
          new Vector3(-gridHalfWidthCount.toDouble(), 0.0, i.toDouble());
      Vector3 p2 =
          new Vector3(gridHalfWidthCount.toDouble(), 0.0, i.toDouble());
      points.add(p1);
      points.add(p2);
    }

    primitive = new MeshPrimitive.Line(points)..mode = DrawMode.LINES;
  }
}

//Todo : convert from javascript
class TorusModel extends Mesh {
  /*
  // Creates a 3D torus in the XY plane, returns the data in a new object composed of
//   several Float32Array objects named 'vertices' and 'colors', according to
//   the following parameters:
// r:  big radius
// sr: section radius
// n:  number of faces
// sn: number of faces on section
// k:  factor between 0 and 1 defining the space between strips of the torus
function makeTorus(r, sr, n, sn, k)
{
  // Temporary arrays for the vertices, normals and colors
  var tv = new Array();
  var tc = new Array();

  // Iterates along the big circle and then around a section
  for(var i=0;i<n;i++)               // Iterates over all strip rounds
    for(var j=0;j<sn+1*(i==n-1);j++) // Iterates along the torus section
      for(var v=0;v<2;v++)           // Creates zigzag pattern (v equals 0 or 1)
      {
        // Pre-calculation of angles
        var a =  2*Math.PI*(i+j/sn+k*v)/n;
        var sa = 2*Math.PI*j/sn;
        var x, y, z;

        // Coordinates on the surface of the torus
        tv.push(x = (r+sr*Math.cos(sa))*Math.cos(a)); // X
        tv.push(y = (r+sr*Math.cos(sa))*Math.sin(a)); // Y
        tv.push(z = sr*Math.sin(sa));                 // Z

        // Colors
        tc.push(0.5+0.5*x);  // R
        tc.push(0.5+0.5*y);  // G
        tc.push(0.5+0.5*z);  // B
        tc.push(1.0);  // Alpha
      }

  // Converts and returns array
  var res = new Object();
  res.vertices = new Float32Array(tv);
  res.colors = new Float32Array(tc);
  return res;
}
   */
}

class SkyBoxModel extends CubeModel {
  ModelType get modelType => ModelType.skyBox;
  SkyBoxModel({bool doInitMaterial: true}) {
    primitive = new MeshPrimitive.Cube()
    ..material = doInitMaterial ? new MaterialPoint() : null;
  }
}

class VectorModel extends Mesh {
  ModelType get modelType => ModelType.vector;
  final Vector3 vec;
  VectorModel(this.vec, {bool doInitMaterial: true}) {
    List<Vector3> points = new List();

    points..add(new Vector3.all(0.0))..add(vec);

    primitive = new MeshPrimitive.Line(points)
      ..mode = DrawMode.LINES
    ..material = doInitMaterial ? new MaterialBase() : null;
  }
}
