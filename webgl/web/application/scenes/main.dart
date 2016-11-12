import 'dart:html';
import 'package:webgl/scene_views/scene_view_base.dart';
import 'package:webgl/scene_views/scene_view_base.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/scene_views/scene_view_framebuffer.dart';
import 'package:webgl/scene_views/scene_view_particle.dart';
import 'package:webgl/scene_views/scene_view_particle_simple.dart';
import 'package:webgl/scene_views/scene_view_pbr.dart';
import 'package:webgl/scene_views/scene_view_performance_test.dart';
import 'package:webgl/scene_views/scene_view_primitives.dart';
import 'package:webgl/scene_views/scene_view_experiment/scene_view_experiment.dart';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/scene_views/scene_view_shader_learning_glsl.dart';

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
    new SceneViewBase(application),
//    new SceneViewPrimitives(application),
//    new SceneViewPBR(application),
//    new SceneViewFrameBuffer(application),
//    new SceneViewExperiment(application),
//    new SceneViewParticleSimple(application),
//    new SceneViewParticle(application),
//    new SceneViewPerformanceTest(application),
//    new SceneViewShaderLearning01(application),
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
