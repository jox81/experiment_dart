import 'package:webgl/src/animation/animator.dart';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/base/project/project.dart';
import 'package:webgl/src/gltf/animation/animation_channel.dart';
import 'package:webgl/src/gltf/animation/animation_channel_target_path_type.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/utils/utils_animation.dart';
import 'package:webgl/src/gltf/animation/animation.dart';
import 'package:webgl/src/project/project.dart';

class BaseAnimator extends Animator {
  BaseAnimator();

  BaseProject _project;

  void init(covariant BaseProject project){
    _project = project;
  }

  void update({num currentTime: 0.0}) {
    // Todo (jpu) :
  }
}
