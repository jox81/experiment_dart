import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/controller/node_controller.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/materials/material.dart';

class ColorNodeController extends GLTFNodeController{
  @override
  void onKeyPressed(GLTFNode node, List<bool> currentlyPressedKeys) {
    if(currentlyPressedKeys[KeyCode.EIGHT]) {
      Material material = node.mesh.primitives[0].material;
      if(material is MaterialBaseColor){
        material.color = new Vector4(0.0,1.0,0.0,1.0);
      } else if(material is KronosPRBMaterial){
        material.baseColorFactor = new Float32List.fromList([0.0,1.0,0.0,1.0]);
      }
    }
    if(currentlyPressedKeys[KeyCode.SEVEN]) {
      Material material = node.mesh.primitives[0].material;
      if(material is MaterialBaseColor){
        material.color = new Vector4(1.0,1.0,0.0,1.0);
      } else if(material is KronosPRBMaterial){
        material.baseColorFactor = new Float32List.fromList([1.0,1.0,0.0,1.0]);
      }
    }
  }
}