import 'dart:html';
import 'package:webgl/engine.dart';

class EngineFactory{
  Engine create(CanvasElement canvas, String projectPath){
    Engine engine;

    if(projectPath.endsWith('.gltf')){
      engine = new GLTFEngine(canvas);
    }

    return engine;
  }
}