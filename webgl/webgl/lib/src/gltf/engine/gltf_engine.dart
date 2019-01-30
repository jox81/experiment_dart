import 'dart:html';
import 'package:webgl/src/animation/animator.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/animation/gltf_animator.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/renderer/gltf_renderer.dart';

class GLTFEngine extends Engine {
  static GLTFEngine get currentEngine => Engine.currentEngine as GLTFEngine;
  static GLTFProject get activeProject =>
      currentEngine.currentProject as GLTFProject;

  @override
  GLTFRenderer renderer;

  @override
  Animator animator;

  GLTFEngine(CanvasElement canvas) : super(canvas) {
    this.animator = new GLTFAnimator();
    this.renderer = new GLTFRenderer(canvas);
  }

  @override
  Future render(covariant GLTFProject project) async {
    await super.render(project);
  }
}
