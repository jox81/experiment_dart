import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/engine/engine_type.dart';

class EngineFactory{
  Engine create(CanvasElement canvas, EngineType engineType){
    Engine engine;

    if(engineType == EngineType.GLTF){
      engine = new GLTFEngine(canvas);
    }

    return engine;
  }
}