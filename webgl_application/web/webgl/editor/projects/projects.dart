import 'dart:async';
import 'package:webgl/src/gltf/project.dart';
import 'scene_views/scene_view_gltf.dart';
import 'scene_views/scene_view_empty.dart';
import 'scene_views/scene_view_base.dart';
import 'scene_views/scene_view_cubemap.dart';
import 'scene_views/scene_view_framebuffer.dart';
import 'scene_views/scene_view_gltf.dart';
import 'scene_views/scene_view_primitives.dart';
import 'scene_views/scene_view_texturing.dart';
import 'scene_views/scene_view_cubemap.dart';
import 'scene_views/scene_view_performance.dart';
import 'scene_views/scene_view_shader_learning_glsl.dart';
import 'scene_views/scene_view_test_matrices.dart';
import 'scene_views/scene_view_texturing.dart';
import 'scene_views/scene_view_vectors.dart';
import 'scene_views/scene_view_webgl_edit.dart';
import 'scene_views/scene_view_base.dart';
import 'scene_views/scene_view_experiment/scene_view_experiment.dart';
import 'scene_views/scene_view_framebuffer.dart';
import 'scene_views/scene_view_particle.dart';
import 'scene_views/scene_view_particle_simple.dart';
import 'scene_views/scene_view_pbr.dart';
import 'scene_views/scene_view_primitives.dart';

Future<List<GLTFProject>> loadBaseProjects() async => [
//  projectSceneViewEmpty(),
//  await projectSceneViewBase(),
//  await projectPrimitives(),
//  await projectPrimitivesTextured(),
  await projectSceneViewVector(),
//  await projectSceneViewGltf(),// Todo (jpu) : bug
//  await projectCubeMap(),
//  projectSceneViewPerformance(),
];

var exp = [
// new SceneViewPBR(),
// new SceneViewTestMatrices(),
// new SceneViewWebGLEdit(),
// new SceneViewFrameBuffer(),// Todo (jpu) : soucis
// new SceneViewParticle(),
// new SceneViewParticleSimple(),
// new SceneViewShaderLearning01(),
// new SceneViewExperiment(),
// await Scene.fromJsonFilePath('./objects/scene_texturing.json'),
];