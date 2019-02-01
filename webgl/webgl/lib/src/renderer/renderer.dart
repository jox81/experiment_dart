import 'dart:html';

import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/project/project.dart';

abstract class Renderer{
  final Context context = new Context();

  final CanvasElement _canvas;
  CanvasElement get canvas => _canvas;

  Renderer(this._canvas) {
    context.init(_canvas);
  }

  void init(Project project);
  void render({num currentTime: 0.0});
}