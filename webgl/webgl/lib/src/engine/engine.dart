import 'dart:async';
import 'dart:html';
import 'package:meta/meta.dart';
import 'package:webgl/src/animation/animator.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/engine/engine_clock.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/renderer/renderer.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';

abstract class Engine {
  static Engine _currentEngine;
  static Engine get currentEngine => _currentEngine ?? (throw 'No engine Define in Engine');

  final EngineClock _engineClock = new EngineClock();
  final CanvasElement canvas;

  final StreamController<num> _onRenderStreamController = new StreamController<num>.broadcast();
  Stream<num> get onRender => _onRenderStreamController.stream;

  Project _currentProject;
  Project get currentProject => _currentProject;
  set currentProject(Project value) => _currentProject = value;

  InteractionManager _interaction;
  Animator get animator;
  Renderer get renderer;

  Engine(this.canvas){
    Engine._currentEngine = this;
    _interaction = new InteractionManager(this);
  }

  @mustCallSuper
  Future render(Project project) async {
    Context.glWrapper.resizeCanvas();
    _currentProject = project;

    _interaction.init(project);
    animator.init(project);
    await renderer.init(project);

    _render();
  }

  void _render({num currentTime: 0.0}) {
    _engineClock.currentTime = currentTime;

    try {
      _interaction.update(currentTime:currentTime);
      animator.update(currentTime:currentTime);
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