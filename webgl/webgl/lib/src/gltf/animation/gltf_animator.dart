import 'package:webgl/src/animation/animator.dart';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/animation/animation_channel.dart';
import 'package:webgl/src/gltf/animation/animation_channel_target_path_type.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/utils/utils_animation.dart';
import 'package:webgl/src/gltf/animation/animation.dart';

class GLTFAnimator extends Animator {
  GLTFAnimator();

  GLTFProject _project;

  void init(covariant GLTFProject project){
    _project = project;
  }

  // Todo (jpu) :
  // - where to use this ? not use for now
  // - do not pass Project ?
  void update({num currentTime: 0.0}) {

    for (int i = 0; i < _project.animations.length; i++) {
      GLTFAnimation animation = _project.animations[i];
      for (int j = 0; j < animation.channels.length; j++) {
        GLTFAnimationChannel channel = animation.channels[j];

        // Todo (jpu) : is it possible to refacto ByteBuffer outside switch ? see when doing weights
        switch (channel.target.path) {
          case AnimationChannelTargetPathType.translation:
            ByteBuffer byteBuffer =
                GLTFUtilsAnimation.getNextInterpolatedValues(
                    channel.sampler, channel.target.path, currentTime);
            Vector3 result = new Vector3.fromBuffer(byteBuffer, 0);
            channel.target.node.translation = result;
//            channel.target.node.translation += new Vector3(0.0, 0.0, 0.1);
//            print(channel.target.node.translation);
            break;
          case AnimationChannelTargetPathType.rotation:
            if (channel.target.node == null) break;
            ByteBuffer byteBuffer =
                GLTFUtilsAnimation.getNextInterpolatedValues(
                    channel.sampler, channel.target.path, currentTime);
            Quaternion result = new Quaternion.fromBuffer(byteBuffer, 0);
//            print(result);
            channel.target.node.rotation = result;
            break;
          case AnimationChannelTargetPathType.scale:
            ByteBuffer byteBuffer =
                GLTFUtilsAnimation.getNextInterpolatedValues(
                    channel.sampler, channel.target.path, currentTime);
            Vector3 result = new Vector3.fromBuffer(byteBuffer, 0);
//            print(result);
            channel.target.node.scale = result;
            break;
          case AnimationChannelTargetPathType.weights:
//            int weightsCount = channel.target.node.mesh.weights.length;
//            throw 'Renderer:update() : switch not implemented yet : ${channel.target.path}';
            // Todo (jpu) :
            break;
        }
      }
    }
  }
}
