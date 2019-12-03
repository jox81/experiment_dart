import 'dart:html';
import 'package:webgl/src/animation/animator.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/animation/gltf_animator.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';

class GLTFEngine extends Engine {
  static GLTFEngine get currentEngine => Engine.currentEngine as GLTFEngine;

  static GLTFProject get currentProject => currentEngine?.activeProject as GLTFProject;
  static set currentProject(GLTFProject value) => currentEngine.activeProject = value;

  @override
  GLTFRenderer renderer;

  @override
  Animator animator;

  GLTFEngine(CanvasElement canvas) : super(canvas) {
    renderer = new GLTFRenderer(canvas);
    animator = new GLTFAnimator();
    activeProject = new GLTFProject();
  }

  @override
  Future init(covariant GLTFProject project) async {
    await super.init(project);
  }

  @override
  void render() {
    super.render();
  }
}