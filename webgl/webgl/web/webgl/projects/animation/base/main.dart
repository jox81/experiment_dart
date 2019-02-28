import 'dart:async';
import 'dart:html' hide Animation;

import 'package:webgl/src/animation/animation.dart';
import 'package:webgl/src/animation/animation_player.dart';
import 'package:webgl/src/utils/utils_time.dart';


Future main() async {
  AnimationTest project = new AnimationTest();
  project.play();

  Animation animation2 = new Animation(5.0)
  ..onUpdate.listen((num value){
    print('### Animation2 value : $value');
  });

  animationPlayer.add(animation2);
}

class AnimationTest {

  num currentTime;

  StreamController<num> loopStreamController = new StreamController<num>.broadcast();
  Stream<num> get loopStream => loopStreamController.stream;

  AnimationTest(){
    loopStream.listen((num event){
      _playStream(time: event);
    });
    loopStream.listen((num event){
      _playStream2();
    });
    loopStream.listen((num event){
      _playStream4();
    });
  }

  void play(){
    _loop();
  }

  void _loop({num time}){
    window.requestAnimationFrame((num time){
      currentTime = time;
      loopStreamController.add(time);
      _play(time: time);
      _loop(time:time);
    });
  }

  void _play({num time}){
    print('_play time : $time');
  }

  void _playStream({num time}) async{
    print('_playStream time : $time');
  }

  bool isPlaying = false;
  void _playStream2() async{
    if(!isPlaying) {
      isPlaying = true;
      print('_playStream2 time : $currentTime');
      await delayedFuture(2.0);
      print('#_playStream2 time : $currentTime');
      Animation animation3 = new Animation(3.0)
      ..onUpdate.listen((num value){
        print('### Animation3 value : $value');
      });

      await animation3.play(time: currentTime);

      print('##_playStream2 time : $currentTime');
    }
  }

  void _playStream4() async{
    animationPlayer.play(currentTime:currentTime);
  }
}





