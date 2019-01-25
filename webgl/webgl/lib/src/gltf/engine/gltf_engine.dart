import 'dart:html';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/gltf_renderer.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';

class GLTFEngine extends Engine{

  final CanvasElement canvas;

  @override
  final GLTFRenderer renderer;

  @override
  final InteractionManager interaction;

  GLTFEngine(this.canvas):
        this.interaction = new InteractionManager(canvas),
        this.renderer = new GLTFRenderer(canvas);

  @override
  Future render(covariant GLTFProject project) async {
    await super.render(project);
  }
}