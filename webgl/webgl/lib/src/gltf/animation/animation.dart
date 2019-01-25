import 'package:webgl/src/gltf/animation/animation_channel.dart';
import 'package:webgl/src/gltf/animation/animation_sampler.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/introspection/introspection.dart';

@reflector
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
    return 'GLTFAnimation{animationId: $animationId, \nchannels: $channels, \nsamplers: $samplers}';
  }
}








