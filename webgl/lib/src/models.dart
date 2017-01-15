import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Vector4 _defaultModelColor = new Vector4(1.0,0.5,0.0,1.0);

enum ModelType{
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
}

abstract class Model extends IEditElement {

  String name; //Todo : S'assurer que les noms soient uniques ?!
  Mesh mesh = new Mesh();
  IGizmo gizmo;

  bool visible = true;

  //Transform : position, rotation, scale
  final Matrix4 _transform = new Matrix4.identity();
  Matrix4 get transform => _transform;
  set transform(Matrix4 value) => _transform.setFrom(value);

  Vector3 get position => transform.getTranslation();
  set position(Vector3 value) => transform.setTranslation(value);

  Matrix3 get rotation => transform.getRotation();
  set rotation(Matrix3 value) => transform.setRotation(value);

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

  static Model createByType(ModelType modelType) {
    Model newModel;
    switch(modelType){
      case ModelType.point:
        newModel = new PointModel();
        break;
      case ModelType.line:
        newModel = new LineModel(new Vector3(-1.0,0.0,0.0), new Vector3(1.0,0.0,0.0));
        break;
      case ModelType.triangle:
        newModel = new TriangleModel();
        break;
      case ModelType.quad:
        newModel = new QuadModel();
        break;
      case ModelType.pyramid:
        newModel = new PyramidModel();
        break;
      case ModelType.cube:
        newModel = new CubeModel();
        break;
      case ModelType.sphere:
        newModel = new SphereModel();
        break;
      case ModelType.torus:
        newModel = new TorusModel ();
        break;
      case ModelType.axis:
        newModel = new AxisModel();
        break;
      case ModelType.grid:
        newModel = new GridModel();
        break;
      default:
        break;
    }
    return newModel;
  }

  void translate(Vector3 vector3) {
    this.position += vector3;
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
  List<Model> gizmoModels = [];

  FrustrumGizmo(Camera camera): _camera = camera{
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

    gizmoModels.add(new LineModel(cameraPosition, cameraTargetPosition)
          ..material = frustrumDirectionLineMaterial);

    gizmoModels
        .add(cameraPositionPoint
          ..material = frustrumPositionPointMaterial); //position
    gizmoModels
        .add(cameraTargetPositionPoint
          ..material = frustrumPositionPointMaterial); //target

    updateGizmo();
  }

  @override
  void updateGizmo() {
    //Update only final positions
    new Frustum.matrix(_vpmatrix)
      ..calculateCorners(c5, c4, c0, c1, c6, c7, c3, c2);

    cameraPosition.setFrom(_camera.position);
    cameraTargetPosition.setFrom(_camera.targetPosition);

    cameraPositionPoint
      ..position = _camera.position;
    cameraTargetPositionPoint
      ..position = _camera.targetPosition;
  }

  @override
  void render(){
    if(!visible)return;
    for(Model model in gizmoModels){
      model.render();
    }
  }
}

class GridModel extends Model {
  GridModel() {
    int gridHalfWidthCount = 5;
    List<Vector3> points = [];
    for(int i = -gridHalfWidthCount; i <= gridHalfWidthCount; i++){
      Vector3 p1 = new Vector3(i.toDouble(), 0.0, gridHalfWidthCount.toDouble());
      Vector3 p2 = new Vector3(i.toDouble(), 0.0, -gridHalfWidthCount.toDouble());
      points.add(p1);
      points.add(p2);
    }
    for(int i = -gridHalfWidthCount; i <= gridHalfWidthCount; i++){
      Vector3 p1 = new Vector3(-gridHalfWidthCount.toDouble(), 0.0, i.toDouble());
      Vector3 p2 = new Vector3(gridHalfWidthCount.toDouble(), 0.0, i.toDouble());
      points.add(p1);
      points.add(p2);
    }

    mesh = new Mesh.Line(points)
    ..mode = DrawMode.LINES;

    material = new MaterialBaseColor(new Vector4(0.5,0.5,0.5,1.0));
  }
}

//Todo : convert from javascript
class TorusModel extends Model {
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

class SkyBoxModel extends CubeModel{
  SkyBoxModel() {
    mesh = new Mesh.Cube();
    material = new MaterialPoint();
  }
}


class VectorModel extends Model {
  final Vector3 vec;
  VectorModel(this.vec) {
    List<Vector3> points = new List();

    points
      ..add(new Vector3.all(0.0))
      ..add(vec);

    mesh = new Mesh.Line(points)
      ..mode = DrawMode.LINES;

    material = new MaterialBase();
  }
}