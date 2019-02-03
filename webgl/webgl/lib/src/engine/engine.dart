import 'dart:async';
import 'dart:html';
import 'package:meta/meta.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/animation/animator.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/engine/engine_clock.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/renderer/renderer.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';

abstract class Engine {
  static Engine _currentEngine;
  static Engine get currentEngine =>
      _currentEngine ?? (throw 'No engine Define in Engine');

  static Project get currentProject =>
      _currentEngine.activeProject ?? (throw 'No Project Define in Engine');
  static set currentProject(Project value) =>
      currentEngine.activeProject = value;

  static Camera _mainCamera;
  static Camera get mainCamera =>
      _mainCamera ??= new CameraPerspective(radians(37.0), 0.1, 1000.0)
        ..targetPosition = new Vector3.zero()
        ..translation = new Vector3(20.0, 20.0, 20.0);
  static set mainCamera(Camera value) {
    _mainCamera?.isActive = false;
    _mainCamera = value;
    _mainCamera.isActive = true;
    _mainCamera?.update();
  }

  static AssetsManager get assetsManager => _currentEngine._assetsManager;

  final EngineClock _engineClock;
  final CanvasElement canvas;
  final AssetsManager _assetsManager;


  final StreamController<num> _onRenderStreamController =
      new StreamController<num>.broadcast();
  Stream<num> get onRender => _onRenderStreamController.stream;

  Project _activeProject;
  Project get activeProject => _activeProject;
  set activeProject(Project value) => _activeProject = value;

  InteractionManager _interaction;
  InteractionManager get interaction => _interaction;

  Animator get animator;
  Renderer get renderer;

  Engine(this.canvas)
      : _assetsManager = new AssetsManager(),
        _engineClock = new EngineClock() {
    Engine._currentEngine = this;
    _interaction = new InteractionManager(this);
  }

  @mustCallSuper
  Future render(Project project) async {
    GL.resizeCanvas();
    _activeProject = project;

    _interaction.init(project);
    animator.init(project);
    await renderer.init(project);

    _render();
  }

  void _render({num currentTime: 0.0}) {
    _engineClock.currentTime = currentTime;

    try {
      _interaction.update(currentTime: currentTime);
      animator.update(currentTime: currentTime);
      renderer.render(currentTime: currentTime);
    } catch (ex) {
      print("Error From Engine render method: $ex ${StackTrace.current}");
    }

    _onRenderStreamController.add(_engineClock.computeFps());

    window.requestAnimationFrame((num currentTime) {
      this._render(currentTime: currentTime);
    });
  }
}
