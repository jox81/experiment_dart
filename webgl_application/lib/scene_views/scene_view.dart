import 'dart:async';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl_application/scene_views/scene_view_base.dart';
import 'package:webgl_application/scene_views/scene_view_primitives.dart';
//import 'package:webgl_application/scene_views/scene_view_cubemap.dart';
//import 'package:webgl_application/scene_views/scene_view_performance.dart';
//import 'package:webgl_application/scene_views/scene_view_shader_learning_glsl.dart';
//import 'package:webgl_application/scene_views/scene_view_test_matrices.dart';
//import 'package:webgl_application/scene_views/scene_view_texturing.dart';
//import 'package:webgl_application/scene_views/scene_view_vectors.dart';
//import 'package:webgl_application/scene_views/scene_view_webgl_edit.dart';
//import 'package:webgl_application/scene_views/scene_view_base.dart';
//import 'package:webgl_application/scene_views/scene_view_experiment/scene_view_experiment.dart';
//import 'package:webgl_application/scene_views/scene_view_framebuffer.dart';
//import 'package:webgl_application/scene_views/scene_view_particle.dart';
//import 'package:webgl_application/scene_views/scene_view_particle_simple.dart';
//import 'package:webgl_application/scene_views/scene_view_pbr.dart';
//import 'package:webgl_application/scene_views/scene_view_primitives.dart';

//Todo :
// - créer un vrai service angular ?
// - charger  /décharger une scene proprement
class ServiceProject {
 static  Future<List<GLTFProject>> getProjects() async => [
//    projectPrimitives(),
    projectSceneViewBase(),
 ];
}


/*
[
// new Scene(),
// getPrimitivesProject(),
// new SceneViewTexturing(),
// new SceneViewPBR(),
// new SceneViewCubeMap(),
// new SceneViewTestMatrices(),
// new SceneViewWebGLEdit(),
// new SceneViewVectors(),
// new SceneViewFrameBuffer(),// Todo (jpu) : soucis
// new SceneViewParticle(),
// new SceneViewParticleSimple(),
// new SceneViewPerformance(),
// new SceneViewShaderLearning01(),
// new SceneViewExperiment(),
// await Scene.fromJsonFilePath('./objects/scene_texturing.json'),
]
*/