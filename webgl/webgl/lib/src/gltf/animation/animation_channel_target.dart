import 'package:webgl/src/gltf/animation/animation_channel_target_path_type.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/introspection/introspection.dart';

/// The Target of the animation
/// [path] defines the property to animate on the [node]
//@reflector
class GLTFAnimationChannelTarget {

  final AnimationChannelTargetPathType path;

  GLTFNode _node;
  GLTFNode get node => _node;
  set node(GLTFNode value) {
    _node = value;
  }

  GLTFAnimationChannelTarget(String path):this.path = AnimationChannelTargetPathType.getByValue(path);

  @override
  String toString() {
    return 'GLTFAnimationChannelTarget{path: $path, nodeId: ${_node.nodeId}';
  }
}