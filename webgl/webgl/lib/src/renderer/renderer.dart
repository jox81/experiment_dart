import 'dart:html';

import 'package:webgl/src/context.dart';
import 'package:webgl/src/project/project.dart';

abstract class Renderer{
  final Context context = new Context();
  final CanvasElement _canvas;

  Renderer(this._canvas) {
    context.init(_canvas);
  }

  void render({num currentTime: 0.0});
  void init(Project project);
}