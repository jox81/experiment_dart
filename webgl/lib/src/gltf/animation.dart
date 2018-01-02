import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';

class GLTFAnimation {
  static int nextId = 0;
  final int animationId = nextId++;

  List<GLTFAnimationSampler> samplers;
  List<GLTFAnimationChannel> channels;

  GLTFAnimation({String name : ''}){
    GLTFProject.instance.animations.add(this);
  }

  @override
  String toString() {
    return 'GLTFAnimation{animationId: $animationId, channels: $channels, samplers: $samplers}';
  }
}

///A channel can be imagined as connecting a "source" [sampler] of the animation data to a [target] node.
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

/// The Target of the animation
/// [path] defines the property to animate on the [node]
class GLTFAnimationChannelTarget {
  final String path;

  GLTFNode _node;
  GLTFNode get node => _node;
  set node(GLTFNode value) {
    _node = value;
  }

  GLTFAnimationChannelTarget(this.path);

  @override
  String toString() {
    return 'GLTFAnimationChannelTarget{path: $path, nodeId: ${_node.nodeId}';
  }
}

/// The samplers describe the sources of animation data
/// [input] accessor defines the timing
/// [output] accessor defines the values corresponding to the timings
/// [interpolation] type of easer to use. // Todo (jpu) : Should this be replaced by an enum ?
class GLTFAnimationSampler {
  static int nextId = 0;
  final int samplerId = nextId++;

  String interpolation;

  GLTFAccessor _accessorInput;
  GLTFAccessor get input => _accessorInput;
  set input(GLTFAccessor value) {
    _accessorInput = value;
  }

  GLTFAccessor _accessorOutput;
  GLTFAccessor get output => _accessorOutput;
  set output(GLTFAccessor value) {
    _accessorOutput = value;
  }

  GLTFAnimationSampler(this.interpolation);

  @override
  String toString() {
    return 'GLTFAnimationSampler{interpolation: $interpolation, _accessorInputId: ${_accessorInput.accessorId}, _accessorOutputId: ${_accessorOutput.accessorId}}';
  }
}
