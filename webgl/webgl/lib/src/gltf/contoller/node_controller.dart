import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/interaction/controller/controller.dart';

abstract class GLTFNodeController extends Controller{
  void onKeyPressed(GLTFNode node, List<bool> currentlyPressedKeys);
}