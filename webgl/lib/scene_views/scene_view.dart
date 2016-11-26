import 'package:webgl/scene_views/scene_view_shader_learning_glsl.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/scene_views/scene_view_base.dart';
import 'package:webgl/scene_views/scene_view_experiment/scene_view_experiment.dart';
import 'package:webgl/scene_views/scene_view_framebuffer.dart';
import 'package:webgl/scene_views/scene_view_particle.dart';
import 'package:webgl/scene_views/scene_view_particle_simple.dart';
import 'package:webgl/scene_views/scene_view_pbr.dart';
import 'package:webgl/scene_views/scene_view_performance_test.dart';
import 'package:webgl/scene_views/scene_view_primitives.dart';

//Todo : créer un vrai service angular
class ServiceScene {
 static  List<Scene> getSceneViews() => [
    new SceneViewBase(),
    new SceneViewPrimitives(),
    new SceneViewPBR(),
    new SceneViewFrameBuffer(),
    new SceneViewExperiment(),
    new SceneViewParticleSimple(),
    new SceneViewParticle(),
    new SceneViewPerformanceTest(),
    new SceneViewShaderLearning01(),
  ];

}