import 'package:webgl/scene_views/scene_view_cubemap.dart';
import 'package:webgl/scene_views/scene_view_shader_learning_glsl.dart';
import 'package:webgl/scene_views/scene_view_start.dart';
import 'package:webgl/scene_views/scene_view_texturing.dart';
import 'package:webgl/scene_views/scene_view_vectors.dart';
import 'package:webgl/scene_views/scene_view_webgl_edit.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/scene_views/scene_view_base.dart';
import 'package:webgl/scene_views/scene_view_experiment/scene_view_experiment.dart';
import 'package:webgl/scene_views/scene_view_framebuffer.dart';
import 'package:webgl/scene_views/scene_view_particle.dart';
import 'package:webgl/scene_views/scene_view_particle_simple.dart';
import 'package:webgl/scene_views/scene_view_pbr.dart';
import 'package:webgl/scene_views/scene_view_performance_test.dart';
import 'package:webgl/scene_views/scene_view_primitives.dart';

//Todo :
// - créer un vrai service angular ?
// - charger  /décharger une scene proprement
class ServiceScene {
 static  List<Scene> getSceneViews() => [
//   new SceneViewStart(),
//   new SceneViewBase(),
//   new SceneViewTexturing(),
//    new SceneViewWebGLEdit(),
//    new SceneViewVectors(),
//    new SceneViewCubeMap(),
//    new SceneViewFrameBuffer(),
//    new SceneViewParticle(),
//    new SceneViewParticleSimple(),
//    new SceneViewPBR(),
//    new SceneViewPerformanceTest(),
    new SceneViewPrimitives(),
//    new SceneViewShaderLearning01(),
//    new SceneViewExperiment(),
 ];
}