import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/material.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      SceneViewTestMatrices,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewTestMatrices extends Scene{

  SceneViewTestMatrices();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    Camera camera = new Camera(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3(0.0, 0.0, 0.0)
      ..position = new Vector3(0.0, 2.0, -1.0);
    Context.mainCamera = camera;

    print('Context.mainCamera.position : \n${Context.mainCamera.position}');
    print('Context.mainCamera.targetPosition : \n${Context.mainCamera.targetPosition}');
    print('Context.mainCamera.lookAtMatrix : \n${Context.mainCamera.lookAtMatrix}');
    print('Context.mainCamera.perspectiveMatrix : \n${Context.mainCamera.perspectiveMatrix}');

    //idems
//    print('Context.mainCamera.viewProjectionMatrix : \n${Context.mainCamera.viewProjectionMatrix}');
    print('Context.mainCamera.viewProjectionMatrix calc: \n${Context.mainCamera.perspectiveMatrix * Context.mainCamera.lookAtMatrix}');

    PointModel model = new PointModel()
      ..position = new Vector3(1.0,0.0,0.0);
    models.add(model);

    print('model.transform : \n${model.transform}');
    print('Context.modelMatrix : \n${Context.modelMatrix}');
    print('Context.modelMatrix m : \n${Context.modelMatrix * model.transform}');


    /// from refelctions.vs.glsl
    Vector3 aVertexPosition;
    Vector3 aNormal;

    Matrix4 uModelViewMatrix;
    Matrix4 uProjectionMatrix;
    Matrix4 uViewMatrix;
    Matrix4 uModelMatrix;
    Matrix3 uNormalMatrix;

    //
    aVertexPosition = new Vector3(0.0,0.0,0.0);

    uModelMatrix = model.transform;
    uViewMatrix = Context.mainCamera.lookAtMatrix;
    uModelViewMatrix = Context.mainCamera.lookAtMatrix * uModelMatrix;
    uProjectionMatrix = Context.mainCamera.perspectiveMatrix;
    uNormalMatrix;

    print("${uProjectionMatrix * uViewMatrix * uModelMatrix * aVertexPosition}");
    print("${uProjectionMatrix * uModelViewMatrix * aVertexPosition}");

    updateSceneFunction = () {
      print('##');
      print('model.transform : \n${model.transform}');
      print('Context.modelMatrix : \n${Context.modelMatrix}');
      print('Context.modelMatrix m : \n${Context.modelMatrix * model.transform}');
    };
  }
}