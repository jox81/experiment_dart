import 'dart:html';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/gltf_renderer.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';

class GLTFEngine extends Engine{

  final CanvasElement canvas;

  @override
  final GLTFRenderer renderer;

  GLTFEngine(this.canvas):
        this.renderer = new GLTFRenderer(canvas),
        super(canvas);

  @override
  Future render(covariant GLTFProject project) async {
    await super.render(project);
  }
}