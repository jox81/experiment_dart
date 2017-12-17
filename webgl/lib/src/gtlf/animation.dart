import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';

class GLTFAnimation {
  static int nextId = 0;

  glTF.Animation _gltfSource;
  glTF.Animation get gltfSource => _gltfSource;

  final int animationId = nextId++;
  List<GLTFAnimationSampler> samplers;
  List<GLTFAnimationChannel> channels;

  GLTFAnimation._(this._gltfSource);

  factory GLTFAnimation.fromGltf(glTF.Animation gltfSource) {
    if (gltfSource == null) return null;

    //>
    List<GLTFAnimationSampler> samplers = new List();
    for (int i = 0; i < gltfSource.samplers.length; i++) {
      GLTFAnimationSampler sampler = new GLTFAnimationSampler.fromGltf(gltfSource.samplers[i])
      ..samplerId = i;
      samplers.add(sampler);
    }

    //>
    List<GLTFAnimationChannel> channels = new List();
    for (int i = 0; i < gltfSource.channels.length; i++) {
      GLTFAnimationChannel channel = new GLTFAnimationChannel.fromGltf(gltfSource.channels[i]);
      channel
        ..channelId = i
        ..sampler = samplers.firstWhere((s)=> s.gltfSource == gltfSource.channels[i].sampler, orElse: () => throw new Exception('san get a corresponding sampler'));
      channels.add(channel);
    }

    GLTFAnimation animation = new GLTFAnimation._(gltfSource)
    ..samplers = samplers
    ..channels = channels;

    return animation;
  }

  @override
  String toString() {
    return 'GLTFAnimation{animationId: $animationId, channels: $channels, samplers: $samplers}';
  }
}

///A channel can be imagined as connecting a "source" [sampler] of the animation data to a [target] node.
class GLTFAnimationChannel {
  glTF.AnimationChannel _gltfSource;

  int channelId;
  glTF.AnimationChannel get gltfSource => _gltfSource;

  GLTFAnimationSampler sampler;
  GLTFAnimationChannelTarget target;

  GLTFAnimationChannel._(this._gltfSource)
      : this.target =
            new GLTFAnimationChannelTarget.fromGltf(_gltfSource.target);

  factory GLTFAnimationChannel.fromGltf(glTF.AnimationChannel gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationChannel channel = new GLTFAnimationChannel._(gltfSource);
    return channel;
  }

  @override
  String toString() {
    return 'GLTFAnimationChannel{channelId: $channelId, samplerId: ${sampler.samplerId}, target: $target}';
  }
}

/// The Target of the animation
/// [path] defines the property to animate on the [node]
class GLTFAnimationChannelTarget {
  glTF.AnimationChannelTarget _gltfSource;
  glTF.AnimationChannelTarget get gltfSource => _gltfSource;

  final String path;

  int _nodeId;
  GLTFNode get node => _nodeId != null ? gltfProject.nodes[_nodeId] : null;

  GLTFAnimationChannelTarget._(this._gltfSource) : this.path = _gltfSource.path;

  factory GLTFAnimationChannelTarget.fromGltf(
      glTF.AnimationChannelTarget gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationChannelTarget channelTarget =
        new GLTFAnimationChannelTarget._(gltfSource);
    GLTFNode projectNode =
        gltfProject.nodes.firstWhere((n) => n.gltfSource == gltfSource.node);
    channelTarget._nodeId = projectNode.nodeId;
    return channelTarget;
  }

  @override
  String toString() {
    return 'GLTFAnimationChannelTarget{path: $path, nodeId: $_nodeId}';
  }
}

/// The samplers describe the sources of animation data
/// [input] accessor defines the timing
/// [output] accessor defines the values corresponding to the timings
/// [interpolation] type of easer to use. // Todo (jpu) : Should this be replaced by an enum ?
class GLTFAnimationSampler {
  glTF.AnimationSampler _gltfSource;
  glTF.AnimationSampler get gltfSource => _gltfSource;

  int samplerId;

  String interpolation;

  int _accessorInputId;
  GLTFAccessor get input =>
      _accessorInputId != null ? gltfProject.accessors[_accessorInputId] : null;

  int _accessorOutputId;
  GLTFAccessor get output => _accessorOutputId != null
      ? gltfProject.accessors[_accessorOutputId]
      : null;

  GLTFAnimationSampler._(this._gltfSource)
      : this.interpolation = _gltfSource.interpolation;

  factory GLTFAnimationSampler.fromGltf(glTF.AnimationSampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationSampler sampler = new GLTFAnimationSampler._(gltfSource);

    GLTFAccessor projectAccessorInput = gltfProject.accessors
        .firstWhere((a) => a.gltfSource == gltfSource.input);
    sampler._accessorInputId = projectAccessorInput.accessorId;

    GLTFAccessor projectAccessorOutput = gltfProject.accessors
        .firstWhere((a) => a.gltfSource == gltfSource.output);
    sampler._accessorOutputId = projectAccessorOutput.accessorId;

    return sampler;
  }

  @override
  String toString() {
    return 'GLTFAnimationSampler{interpolation: $interpolation, _accessorInputId: $_accessorInputId, _accessorOutputId: $_accessorOutputId}';
  }
}
