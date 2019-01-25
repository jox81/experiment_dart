import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh/types/axis_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/axis_point_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/cube_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/grid_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/line_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/line_mesh_primitive2.dart';
import 'package:webgl/src/mesh/types/point_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/pyramid_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/quad_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/sphere_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/triangle_mesh_primitive.dart';
import 'package:webgl/src/mesh/types/vector_mesh_primitive.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@reflector
class MeshPrimitive {

  /// DrawMode mode
  int mode = DrawMode.TRIANGLES;

  List<double> vertices = [];

  List<int> _indices = new List();
  List<int> get indices => _indices;
  set indices(List<int> value) {
    _indices = value;
  }

  List<double> _uvs = new List();
  List<double> get uvs => _uvs;
  set uvs(List<double> value) {
    _uvs = value;
  }

  List<double> _normals = new List();
  List<double> get normals => _normals;
  set normals(List<double> value) {
    _normals = value;
  }

  List<double> _colors = new List();
  List<double> get colors => _colors;
  set colors(List<double> value) {
    _colors = value;
  }

  MeshPrimitive();

  factory MeshPrimitive.Point() {
    return new PointMeshPrimitive();
  }

  factory MeshPrimitive.Line(List<Vector3> points) {
    return new LineMeshPrimitive(points);
  }

  factory MeshPrimitive.Line2(List<Vector3> points) {
    return new LineMeshPrimitive2(points);
  }

  factory MeshPrimitive.Triangle() {
    return new TriangleMeshPrimitive();
  }

  factory MeshPrimitive.Quad() {
    return new QuadMeshPrimitive();
  }

  factory MeshPrimitive.Pyramid() {
    return new PyramidMeshPrimitive();
  }

  factory MeshPrimitive.Cube() {
    return new CubeMeshPrimitive();
  }

  factory MeshPrimitive.Sphere({double radius : 1.0, int segmentV: 32, int segmentH: 32}) {
    return new SphereMeshPrimitive(radius : radius, segmentV:segmentV, segmentH:segmentH);
  }

  factory MeshPrimitive.Axis() {
    return new AxisMeshPrimitive();
  }

  factory MeshPrimitive.AxisPoints() {
    return new AxisPointMeshPrimitive();
  }

  factory MeshPrimitive.Grid() {
    return new GridMeshPrimitive();
  }

  factory MeshPrimitive.Vector(Vector3 vector) {
    return new VectorMeshPrimitive(vector);
  }
}