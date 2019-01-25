import 'package:webgl/src/gltf/animation/animation_channel_target.dart';
import 'package:webgl/src/gltf/animation/animation_sampler.dart';
import 'package:webgl/src/introspection/introspection.dart';

///A channel can be imagined as connecting a "source" [sampler] of the animation data to a [target] node.
@reflector
class GLTFAnimationChannel {
  static int nextId = 0;
  final int channelId = nextId++;

  GLTFAnimationSampler sampler;
  GLTFAnimationChannelTarget target;

  GLTFAnimationChannel(this.target);

  @override
  String toString() {
    return 'GLTFAnimationChannel{channelId: $channelId, samplerId: ${sampler.samplerId}, target: $target}';
  }
}