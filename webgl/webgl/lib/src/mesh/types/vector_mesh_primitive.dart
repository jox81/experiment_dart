import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

///use materialBase
class VectorMeshPrimitive extends MeshPrimitive{
  final Vector3 vector;

  VectorMeshPrimitive(this.vector){
    mode = DrawMode.LINES;
    vertices = []..addAll(new Vector3.all(0.0).storage)..addAll(vector.storage);
  }
}