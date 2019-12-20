import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/materials/types/point_material.dart';

class PointGLTFNode extends GLTFNode{
  PointGLTFNode({String name: ''}): super(
      mesh: new GLTFMesh.point(),
      name: name){
    material =  new MaterialPoint(pointSize:10.0, color:new Vector4(1.0, 1.0, 0.0, 1.0));
  }
}