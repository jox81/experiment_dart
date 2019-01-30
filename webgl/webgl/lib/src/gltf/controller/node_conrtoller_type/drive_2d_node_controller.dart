import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/controller/node_controller.dart';
import 'package:webgl/src/gltf/node.dart';

class Drive2dNodeController extends GLTFNodeController{
  final num deltaPosition = 0.1;
  final num deltaRotation = 2.0;
  final Vector3 upAxis = new Vector3(0.0,1.0, 0.0);

  num _rotationR = 0;

  void onKeyPressed(GLTFNode node, List<bool> currentlyPressedKeys) {
    if(currentlyPressedKeys[KeyCode.UP]) node.translate(new Vector3(deltaPosition,0.0,0.0)..applyAxisAngle(upAxis, _rotationR));
    if(currentlyPressedKeys[KeyCode.DOWN]) node.translate(new Vector3(-deltaPosition,0.0,0.0)..applyAxisAngle(upAxis, _rotationR));

    if(currentlyPressedKeys[KeyCode.LEFT]) node.rotation = new Quaternion.axisAngle(upAxis, _rotationR += radians(deltaRotation));
    if(currentlyPressedKeys[KeyCode.RIGHT]) node.rotation = new Quaternion.axisAngle(upAxis, _rotationR -= radians(deltaRotation));
  }
}