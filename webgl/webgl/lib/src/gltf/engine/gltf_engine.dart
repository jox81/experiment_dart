import 'dart:html';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/gltf_renderer.dart';

class GLTFEngine extends Engine {
  static GLTFEngine get currentEngine => Engine.currentEngine as GLTFEngine;
  static GLTFProject get activeProject =>
      currentEngine.currentProject as GLTFProject;

  @override
  GLTFRenderer renderer;

  GLTFEngine(CanvasElement canvas) : super(canvas) {
    this.renderer = new GLTFRenderer(canvas);
  }

  @override
  Future render(covariant GLTFProject project) async {
    await super.render(project);
  }
}
