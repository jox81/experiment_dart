import 'dart:async';
import 'dart:html';
import 'package:meta/meta.dart';
import 'package:webgl/src/engine/engine_clock.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/renderer/renderer.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';

abstract class Engine {
  final EngineClock _engineClock = new EngineClock();

  Renderer get renderer;
  InteractionManager get interaction;

  StreamController<num> _onRenderStreamController = new StreamController<num>.broadcast();
  Stream<num> get onRender => _onRenderStreamController.stream;

  Engine();

  @mustCallSuper
  Future render(Project project) async {
    await renderer.init(project);
    _render();
  }

  void _render({num currentTime: 0.0}) {
    _engineClock.currentTime = currentTime;

    try {
      interaction.update(currentTime:currentTime);
      renderer.render(currentTime:currentTime);
    } catch (ex) {
      print("Error From Engine render method: $ex ${StackTrace.current}");
    }

    _onRenderStreamController.add(_engineClock.computeFps());

    window.requestAnimationFrame((num currentTime) {
      this._render(currentTime: currentTime);
    });
  }
}