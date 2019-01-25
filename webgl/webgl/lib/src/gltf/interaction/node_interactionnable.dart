
import 'package:webgl/src/gltf/contoller/node_controller.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/interaction/interactionnable.dart';

class NodeInteractionnable extends Interactionable{
  GLTFNode node;
  GLTFNodeController controller;

  NodeInteractionnable();

  @override
  void onKeyPressed(List<bool> currentlyPressedKeys) {
    if (node != null && controller != null){
      controller.onKeyPressed(node, currentlyPressedKeys);
    }
  }

  @override
  void onMouseDown(int screenX, int screenY) {
    // TODO: implement onMouseDown
  }

  @override
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton) {
    // TODO: implement onMouseMove
  }

  @override
  void onMouseUp(int screenX, int screenY) {
    // TODO: implement onMouseUp
  }

  @override
  void onMouseWheel(num deltaY) {
    // TODO: implement onMouseWheel
  }

  @override
  void onTouchEnd(int screenX, int screenY) {
    // TODO: implement onTouchEnd
  }

  @override
  void onTouchMove(double deltaX, double deltaY, {num scaleChange}) {
    // TODO: implement onTouchMove
  }

  @override
  void onTouchStart(int screenX, int screenY) {
    // TODO: implement onTouchStart
  }
}