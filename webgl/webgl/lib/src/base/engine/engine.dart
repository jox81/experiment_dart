import 'dart:html';
import 'package:webgl/src/base/animator/animator.dart';
import 'package:webgl/src/base/project/project.dart';
import 'package:webgl/src/base/renderer/renderer.dart';
import 'package:webgl/src/engine/engine.dart';

class BaseEngine extends Engine {
  static BaseEngine get currentEngine => Engine.currentEngine as BaseEngine;

  static BaseProject get currentProject => currentEngine?.activeProject;
  static set currentProject(BaseProject value) => currentEngine.activeProject = value;

  @override
  BaseRenderer renderer;

  @override
  BaseAnimator animator;

  BaseEngine(CanvasElement canvas) : super(canvas) {
    this.animator = new BaseAnimator();
    this.renderer = new BaseRenderer(canvas);
  }
}