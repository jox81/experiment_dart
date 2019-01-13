import 'dart:html';
import 'package:webgl/src/gltf/renderer/renderer.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';
import 'package:webgl/src/time/time.dart';

abstract class Engine {
  Renderer get renderer;
  InteractionManager get interaction;

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