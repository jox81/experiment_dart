import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/meshes.dart';
import 'dart:collection';
//import 'package:webgl/src/application.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'dart:async';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/models.dart';

abstract class Scene implements ISetupScene, IUpdatableScene, IUpdatableSceneFunction{

  Vector4 _backgroundColor;
  Vector4 get backgroundColor => _backgroundColor;
  set backgroundColor(Vector4 color) {
    _backgroundColor = color;
  }

  Light light;
  AmbientLight ambientLight = new AmbientLight();

  List<Material> materials = new List();
  List<Model> models = new List();
  List<Camera> get cameras => models.where((m)=> m is Camera).toList();

  Interaction interaction;

  Scene(){
    Context.mainCamera = new Camera(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = gl.drawingBufferWidth / gl.drawingBufferHeight
      ..targetPosition = new Vector3.zero();
  }

  bool _isSetuped = false;

  Future setup() async{

    Future future = new Future.value();

    interaction = new Interaction(this, gl);

    if(!_isSetuped){
      _isSetuped = true;
      setupUserInput();
      future = setupScene();
    }

    return future;
  }

  void updateUserInput() {
    updateUserInputFunction();
  }

  void update(num time) {
    updateFunction(time);
  }

  void render(){
    for (Model model in models) {
      model.render();
    }
  }
}