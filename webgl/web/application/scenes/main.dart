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

main() async {
  CanvasElement canvas = querySelector('#glCanvas');
  Application application = new Application(canvas);

  Scene scene;

//  scene = new SceneViewBase(application.viewAspectRatio);
//  scene = new SceneViewFrameBuffer(application.viewAspectRatio);
//  scene = new SceneViewParticle(application.viewAspectRatio);
//  scene = new SceneViewPBR(application.viewAspectRatio);
//  scene = new SceneViewPerformanceTest(application.viewAspectRatio);
//  scene = new SceneViewPrimitives(application.viewAspectRatio);
  scene = new SceneViewExperiment(application.viewAspectRatio);

  await scene.setupScene();
  application.render(scene);
}
