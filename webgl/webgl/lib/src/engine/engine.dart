import 'dart:async';
import 'dart:html';
import 'package:meta/meta.dart';
import 'package:webgl/src/animation/animation_player.dart';
import 'package:webgl/src/animation/animator.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/gltf/camera/camera.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
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

  static Camera get mainCamera => currentProject.mainCamera;
  static set mainCamera(GLTFCamera value) {
    currentProject.mainCamera = value;
  }

  final StreamController<num> _onRenderStreamController =
      new StreamController<num>.broadcast();
  Stream<num> get onRender => _onRenderStreamController.stream;

  final EngineClock _engineClock;
  final CanvasElement canvas;
  final AssetManager _assetManager;
  AssetManager get assetsManager => _assetManager;

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
    _renderLoop();
  }

  void _renderLoop({num currentTime: 0.0}) {
    window.requestAnimationFrame((num currentTime) {
      _render(currentTime);
      _renderLoop(currentTime: currentTime);
    });
  }

  void _render(num currentTime) {
    _engineClock.currentTime = currentTime;

    try {
      _interaction.update(currentTime: currentTime);
      _activeProject.update(currentTime: currentTime);//should this be placed in this order ? later/sooner ?
      animator.update(currentTime: currentTime);
      animationPlayer.play(currentTime : currentTime);
      renderer.render(currentTime: currentTime);
    } catch (ex) {
      print("Error From Engine render method: $ex ${StackTrace.current}");
    }

    _onRenderStreamController.add(_engineClock.computeFps());
  }
}
