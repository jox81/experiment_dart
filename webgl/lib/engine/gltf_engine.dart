import 'dart:html';
import 'package:webgl/engine/engine.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';
import 'package:webgl/src/interaction/custom_interactionable.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';

class GLTFEngine extends Engine{

  @override
  final GLTFRenderer renderer;

  @override
  final InteractionManager interaction;

  final CanvasElement canvas;

  GLTFEngine(this.canvas):
        this.interaction = new InteractionManager(canvas),
        this.renderer = new GLTFRenderer(canvas){
    interaction.addInteractable(new CustomInteractionable(() => Context.mainCamera?.cameraController?.cameraControllerInteraction));
  }
}