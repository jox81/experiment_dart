import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:collection';
import 'package:webgl/src/application.dart';

class Scene{

  Vector4 _backgroundColor;
  Vector4 get backgroundColor => _backgroundColor;
  set backgroundColor(Vector4 color) {
    _backgroundColor = color;
  }

  Camera mainCamera; //mainCamera.matrix.storage ==> projection Matrix
  Light light;
  AmbientLight ambientLight = new AmbientLight();

  List<Material> materials = new List();
  List<Mesh> meshes = new List();

  Matrix4 mvMatrix = new Matrix4.identity();

  void render(){
    for (Mesh model in meshes) {
      mvPushMatrix();

      mvMatrix.multiply(model.transform);

      model.render();

      mvPopMatrix();
    }
  }

  UpdateFunction updateFunction;
  void update(num time) {
    updateFunction(time);
  }

  //Animation
  Queue<Matrix4> _mvMatrixStack = new Queue();

  void mvPushMatrix() {
    _mvMatrixStack.addFirst(mvMatrix.clone());
  }

  void mvPopMatrix() {
    if (0 == _mvMatrixStack.length) {
      throw new Exception("Invalid popMatrix!");
    }
    mvMatrix = _mvMatrixStack.removeFirst();
  }
}