import 'dart:async';
import 'projects/scene_views/scene_view_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'projects/scene_views/scene_view_empty.dart';
import 'projects/scene_views/scene_view_base.dart';
import 'projects/scene_views/scene_view_cubemap.dart';
import 'projects/scene_views/scene_view_framebuffer.dart';
import 'projects/scene_views/scene_view_gltf.dart';
import 'projects/scene_views/scene_view_primitives.dart';
import 'projects/scene_views/scene_view_texturing.dart';
import 'projects/scene_views/scene_view_cubemap.dart';
import 'projects/scene_views/scene_view_performance.dart';
import 'projects/scene_views/scene_view_shader_learning_glsl.dart';
import 'projects/scene_views/scene_view_test_matrices.dart';
import 'projects/scene_views/scene_view_texturing.dart';
import 'projects/scene_views/scene_view_vectors.dart';
import 'projects/scene_views/scene_view_webgl_edit.dart';
import 'projects/scene_views/scene_view_base.dart';
import 'projects/scene_views/scene_view_experiment/scene_view_experiment.dart';
import 'projects/scene_views/scene_view_framebuffer.dart';
import 'projects/scene_views/scene_view_particle.dart';
import 'projects/scene_views/scene_view_particle_simple.dart';
import 'projects/scene_views/scene_view_pbr.dart';
import 'projects/scene_views/scene_view_primitives.dart';

Future<List<GLTFProject>> loadBaseProjects() async => [
//  projectSceneViewEmpty(),
  await projectSceneViewBase(),
//  projectPrimitives(),
  await projectPrimitivesTextured(),
//  await projectSceneViewGltf(),// Todo (jpu) : bug on getFace()
//  projectSceneViewPerformance(),
//  projectSceneViewVector(),
];

/*
[
//  await projectCubeMap(),
// new SceneViewPBR(),
// new SceneViewCubeMap(),
// new SceneViewTestMatrices(),
// new SceneViewWebGLEdit(),
// new SceneViewFrameBuffer(),// Todo (jpu) : soucis
// new SceneViewParticle(),
// new SceneViewParticleSimple(),
// new SceneViewShaderLearning01(),
// new SceneViewExperiment(),
// await Scene.fromJsonFilePath('./objects/scene_texturing.json'),
]
*/