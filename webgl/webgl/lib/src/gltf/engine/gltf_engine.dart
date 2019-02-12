import 'dart:html';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/animation/animator.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/animation/gltf_animator.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';

class GLTFEngine extends Engine {
  static GLTFEngine get currentEngine => Engine.currentEngine as GLTFEngine;

  static GLTFProject get currentProject => currentEngine?.activeProject;
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
    await AssetLibrary.images.loadAll();
    await AssetLibrary.cubeMaps.load(CubeMapName.papermill_diffuse);
    await AssetLibrary.cubeMaps.load(CubeMapName.papermill_specular);
    await AssetLibrary.shaders.loadAll();

    await super.init(project);
  }

  @override
  void render() {
    super.render();
  }
}