import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:collection';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'dart:async';
import 'package:webgl/src/interaction.dart';

abstract class Scene implements ISetupScene, IUpdatableScene, IUpdatableSceneFunction{

  Vector4 _backgroundColor;
  Vector4 get backgroundColor => _backgroundColor;
  set backgroundColor(Vector4 color) {
    _backgroundColor = color;
  }

  Camera mainCamera;
  Light light;
  AmbientLight ambientLight = new AmbientLight();

  List<Material> materials = new List();
  List<Mesh> meshes = new List();

  Matrix4 mvMatrix = new Matrix4.identity();

  Interaction interaction;

  final Application application;

  Scene(this.application){
    mainCamera = new Camera(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = application.viewAspectRatio
      ..targetPosition = new Vector3.zero();
  }

  bool _isSetuped = false;

  MaterialBaseColor debugMaterialBaseColor;

  Future setup() async{
    debugMaterialBaseColor = await MaterialBaseColor.create(
        new Vector3(1.0, 1.0, 0.0));
    materials.add(debugMaterialBaseColor);

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
    for (Mesh model in meshes) {
      _mvPushMatrix();

      mvMatrix.multiply(model.transform);

      model.render();

      _mvPopMatrix();
    }
  }

  //Animation
  Queue<Matrix4> _mvMatrixStack = new Queue();

  void _mvPushMatrix() {
    _mvMatrixStack.addFirst(mvMatrix.clone());
  }

  void _mvPopMatrix() {
    if (0 == _mvMatrixStack.length) {
      throw new Exception("Invalid popMatrix!");
    }
    mvMatrix = _mvMatrixStack.removeFirst();
  }

  void createLine(Vector3 point1, Vector3 point2) {
    Mesh debugLine = new Mesh.Line([point1, point2])
        ..material = debugMaterialBaseColor;
    meshes.add(debugLine);
  }
}