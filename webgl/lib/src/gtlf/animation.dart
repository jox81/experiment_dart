import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';

class GLTFAnimation {
  glTF.Animation _gltfSource;
  glTF.Animation get gltfSource => _gltfSource;

  int animationId;
  List<GLTFAnimationSampler> samplers;
  List<GLTFAnimationChannel> channels;

  GLTFAnimation._(this._gltfSource)
      : this.samplers = _gltfSource.samplers
            .map((s) => new GLTFAnimationSampler.fromGltf(s))
            .toList(),
        this.channels = _gltfSource.channels
            .map((c) => new GLTFAnimationChannel.fromGltf(c))
            .toList();

  factory GLTFAnimation.fromGltf(glTF.Animation gltfAnimation) {
    if (gltfAnimation == null) return null;
    GLTFAnimation animation = new GLTFAnimation._(gltfAnimation);
    return animation;
  }

  @override
  String toString() {
    return 'GLTFAnimation{animationId: $animationId, channels: $channels, samplers: $samplers}';
  }
}

class GLTFAnimationChannel {
  glTF.AnimationChannel _gltfSource;
  glTF.AnimationChannel get gltfSource => _gltfSource;

  int _samplerId;
  GLTFAnimationSampler get sampler => null;
  GLTFAnimationChannelTarget target;

  GLTFAnimationChannel._(this._gltfSource)
      : this.target =
  new GLTFAnimationChannelTarget.fromGltf(_gltfSource.target);

  factory GLTFAnimationChannel.fromGltf(glTF.AnimationChannel gltfSource){
    if(gltfSource == null) return null;
    GLTFAnimationChannel channel = new GLTFAnimationChannel._(gltfSource);
    return channel;
  }

  @override
  String toString() {
    return 'GLTFAnimationChannel{samplerId: $_samplerId, target: $target}';
  }
}

class GLTFAnimationChannelTarget {
  glTF.AnimationChannelTarget _gltfSource;
  glTF.AnimationChannelTarget get gltfSource => _gltfSource;

  final String path;

  int _nodeId;
  GLTFNode get node => null;

  GLTFAnimationChannelTarget._(this._gltfSource)
      : this.path = _gltfSource.path;

  factory GLTFAnimationChannelTarget.fromGltf(glTF.AnimationChannelTarget gltfSource){
    if(gltfSource == null) return null;
    GLTFAnimationChannelTarget sampler = new GLTFAnimationChannelTarget._(gltfSource);
    return sampler;
  }

  @override
  String toString() {
    return 'GLTFAnimationChannelTarget{path: $path, nodeId: $_nodeId}';
  }
}

class GLTFAnimationSampler {
  glTF.AnimationSampler _gltfSource;
  glTF.AnimationSampler get gltfSource => _gltfSource;

  String interpolation;

  int _accessorInputId;
  GLTFAccessor get input => _accessorInputId != null ? gltfProject.accessors[_accessorInputId] : null;

  int _accessorOutputId;
  GLTFAccessor get output => _accessorOutputId != null ? gltfProject.accessors[_accessorOutputId] : null;

  GLTFAnimationSampler._(this._gltfSource)
      : this.interpolation = _gltfSource.interpolation;

  factory GLTFAnimationSampler.fromGltf(glTF.AnimationSampler gltfSource){
    if(gltfSource == null) return null;
    GLTFAnimationSampler sampler = new GLTFAnimationSampler._(gltfSource);
    return sampler;
  }

  @override
  String toString() {
    return 'GLTFAnimationSampler{interpolation: $interpolation, _accessorInputId: $_accessorInputId, _accessorOutputId: $_accessorOutputId}';
  }
}
