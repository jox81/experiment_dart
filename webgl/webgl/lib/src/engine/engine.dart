import 'dart:async';
import 'dart:html';
import 'package:meta/meta.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/animation/animator.dart';
import 'package:webgl/src/assets_manager/loaders/shader_source_loader.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/engine/engine_clock.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/renderer/renderer.dart';
import 'package:webgl/src/interaction/interaction_manager.dart';

class NoEngineException implements Exception{
  final String message = 'No engine Define in Engine';
}
class NoProjectException implements Exception{
  final String message = 'No Project Define in Engine';
}

abstract class Engine {
  static Engine _currentEngine;
  static Engine get currentEngine =>
      _currentEngine ?? (throw new NoEngineException());

  static Project get currentProject =>
      _currentEngine.activeProject ?? (throw new NoProjectException());
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

  AssetManager get assetsManager => _assetManager;

  final EngineClock _engineClock;
  final CanvasElement canvas;
  final AssetManager _assetManager;

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
      : _assetManager = new AssetManager(),
        _engineClock = new EngineClock() {
    Engine._currentEngine = this;
    _interaction = new InteractionManager(this);
  }

  bool _isInitialized = false;
  @mustCallSuper
  Future init(Project project) async {
    if(!_isInitialized) {
      _activeProject = project;
      _interaction.init(project);
      animator.init(project);
      renderer.init(project);
    }
    _isInitialized = true;
  }

  @mustCallSuper
  void render() {
    if(!_isInitialized) throw new Exception('engine must be init before render');
    GL.resizeCanvas();
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
