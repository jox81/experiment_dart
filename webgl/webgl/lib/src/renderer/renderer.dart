import 'dart:html';

import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/project/project.dart';

abstract class Renderer{
  Context _context;
  CanvasElement get canvas => _context.canvas;

  Renderer(CanvasElement canvas) {
    _context = new Context(canvas);
  }

  void init(Project project);
  void render({num currentTime: 0.0});
}