import 'dart:html';
import 'package:webgl/src/base/project/project.dart';
import 'package:webgl/src/renderer/renderer.dart';

class BaseRenderer extends Renderer{
  BaseRenderer(CanvasElement canvas) : super(canvas);

//  BaseProject _project;

  @override
  void init(covariant BaseProject project) {
//    _project = project;
  }

  @override
  void render({num currentTime = 0.0}) {
    // TODO: implement render
  }
}