import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/controller/node_controller.dart';
import 'package:webgl/src/gltf/node.dart';

class Ortho2dNodeController extends GLTFNodeController{
  void onKeyPressed(GLTFNode node, List<bool> currentlyPressedKeys) {
    num deltaPosition = 0.3;
    if(currentlyPressedKeys[KeyCode.UP]) node.translate(new Vector3(0.0,0.0,deltaPosition));
    if(currentlyPressedKeys[KeyCode.DOWN]) node.translate(new Vector3(0.0,0.0,-deltaPosition));

    if(currentlyPressedKeys[KeyCode.LEFT]) node.translate(new Vector3(deltaPosition,0.0,0.0));
    if(currentlyPressedKeys[KeyCode.RIGHT]) node.translate(new Vector3(-deltaPosition,0.0,0.0));
  }
}