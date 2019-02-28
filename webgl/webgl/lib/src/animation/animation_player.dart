import 'package:webgl/src/animation/animation.dart';

final AnimationPLayer animationPlayer = new AnimationPLayer();

class AnimationPLayer {
  final List<Animation> _animations = new List<Animation>();

  void play({num currentTime}) {
    for (int i = 0; i < _animations.length; ++i) {
      Animation animation = _animations[i];
      animation.play(time: currentTime);

      if(!animation.isPlaying){
        _animations.remove(animation);
      }
    }
  }

  void add(Animation value) {
    _animations.add(value);
  }
}


