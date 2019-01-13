import 'dart:html';

import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';
import 'package:webgl/src/interaction/custom_interactionable.dart';
import 'package:webgl/src/interaction/interaction.dart';
import 'package:webgl/src/time/time.dart';

abstract class Engine {
  Renderer get renderer;
  Interaction get interaction;

  void render({num time: 0.0}) {
    Time.currentTime = time;

    try {
      interaction.update();
      renderer.render();
    } catch (ex) {
      print("Error From Engine render method: $ex ${StackTrace.current}");
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }
}

class GLTFEngine extends Engine{

  @override
  final GLTFRenderer renderer;

  @override
  final Interaction interaction;

  final CanvasElement canvas;

  GLTFEngine(this.canvas):
        this.interaction = new Interaction(canvas),
        this.renderer = new GLTFRenderer(canvas){
    interaction.addInteractable(new CustomInteractionable(() => Context.mainCamera?.cameraController?.cameraControllerInteraction));
  }
}