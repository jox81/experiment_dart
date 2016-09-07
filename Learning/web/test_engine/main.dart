import 'dart:async';
import 'dart:html';
import 'package:stagexl/stagexl.dart' hide Timeline;
import 'package:anime_engine/core/animation_manager.dart';
import 'package:anime_engine/core/animator.dart';
import 'package:anime_engine/core/timeline.dart';
import 'package:anime_engine/core/animation_property.dart';
import 'package:anime_engine/core/keyframe.dart';

main() {
  runZoned(_main, onError: (e, stackTrace) {
    String stack = '$stackTrace';
    stack = stack.split('\n').take(10).join('\n');

    String error = '$e $stack';

    print(error);
    window.alert(error);
  });
}

_main() async {
  CanvasElement canvas = new Element.tag('canvas');
  canvas.height = 300;
  canvas.width = 300;
  document.body.children.add(canvas);

  var stage = new Stage(canvas);
  var renderLoopXL = new RenderLoop();
  renderLoopXL.addStage(stage);
  renderLoopXL.juggler.add(new AnimeManagerXL());

  StageObject stageObject = new StageObject()
  ..x = 100
  ..y = 100;
  stage.addChild(stageObject);

  animate(stageObject);
}

void animate(StageObject stageObject) {
  Timeline timeline = new Timeline()
  ..addKeyframe(new Keyframe(time:0, value: 0))
  ..addKeyframe(new Keyframe(time:50, value: 20))
  ..addKeyframe(new Keyframe(time:200, value: 0));

  AnimationProperty animationPropertyX = new AnimationProperty(()=> stageObject.x, (num v)=> stageObject.x = v);

  Animator animator = new Animator(animationPropertyX, timeline);
  AnimeManager.manager.add(animator);
}

class StageObject extends DisplayObjectContainer{

  StageObject(){
    addChild(new Bitmap(new BitmapData(50, 50, Color.Blue)));
  }
}