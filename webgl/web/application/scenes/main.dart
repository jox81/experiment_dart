import 'dart:html';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';
import 'scene_views/scene_view_base.dart';
import 'scene_views/scene_view_framebuffer.dart';
import 'scene_views/scene_view_particle.dart';
import 'scene_views/scene_view_pbr.dart';
import 'scene_views/scene_view_performance_test.dart';
import 'scene_views/scene_view_primitives.dart';
import 'scene_views/scene_view_experiment/scene_view_experiment.dart';
import 'dart:async';
import 'package:vector_math/vector_math.dart';

Application application;

main() async {

  DivElement divTools = new DivElement();
  DivElement divDebugInfos = new DivElement()..id = 'debugInfos';
  divTools.children.add(divDebugInfos);
  ParagraphElement pFps = new ParagraphElement()..id = 'fps';
  divDebugInfos.children.add(pFps);
  ParagraphElement pDebugInfosText = new ParagraphElement()..id = 'debugInfosText';
  divDebugInfos.children.add(pDebugInfosText);
  document.body.children.add(divTools);

  ButtonElement buttonSwitch = new ButtonElement()..text = 'swicth scene';
  divTools.children.add(buttonSwitch);

  DivElement divCanvas = new DivElement();
  CanvasElement canvas = new CanvasElement()..id = 'glCanvas';
  divCanvas.children.add(canvas);
  document.body.children.add(divCanvas);

  application = new Application(canvas);

  List<Scene> scenes = [
    new SceneViewBase(application.viewAspectRatio),
    new SceneViewPrimitives(application.viewAspectRatio),
    new SceneViewPBR(application.viewAspectRatio),
    new SceneViewFrameBuffer(application.viewAspectRatio),
    new SceneViewExperiment(application.viewAspectRatio),
    new SceneViewParticle(application.viewAspectRatio),
    new SceneViewPerformanceTest(application.viewAspectRatio),
  ];

  int sceneId = 0;

  buttonSwitch.onClick.listen((e){
    sceneId++;
    sceneId %= scenes.length;
    switchScene(scenes[sceneId]);
  });

  switchScene(scenes[sceneId]);
}

Future switchScene (Scene scene)async {
  await scene.setup();
  application.render(scene);
}
