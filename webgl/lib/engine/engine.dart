import 'dart:html';

import 'package:webgl/src/gltf/renderer/renderer.dart';
import 'package:webgl/src/interaction/interaction.dart';

abstract class Engine{
  Renderer get renderer;
  Interaction get interaction;
}

class GLTFEngine implements Engine{
  @override
  final GLTFRenderer renderer;

  GLTFEngine(CanvasElement canvas):this.renderer = new GLTFRenderer(canvas);

  @override
  Interaction get interaction => null;

  
}