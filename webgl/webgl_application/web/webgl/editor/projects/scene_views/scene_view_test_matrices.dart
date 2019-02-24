//import 'dart:async';
//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/gltf/camera/camera.dart';
//import 'package:webgl/src/webgl_objects/context.dart';
//
//
//@MirrorsUsed(
//    targets: const [
//      SceneViewTestMatrices,
//    ],
//    override: '*')
//import 'dart:mirrors';
//
//class SceneViewTestMatrices extends SceneJox{
//
//  SceneViewTestMatrices();
//
//  @override
//  Future setupScene() async {
//
//    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
//
//    //Cameras
//    CameraPerspective camera = new CameraPerspective(radians(37.0), 0.1, 100.0)
//      ..targetPosition = new Vector3(0.0, 0.0, 0.0)
//      ..translation = new Vector3(0.0, 2.0, -1.0);
//    Engine.mainCamera = camera;
//
//    print('Engine.mainCamera.position : \n${Engine.mainCamera.translation}');
//    print('Engine.mainCamera.targetPosition : \n${Engine.mainCamera.targetPosition}');
//    print('Engine.mainCamera.lookAtMatrix : \n${Engine.mainCamera.viewMatrix}');
//    print('Engine.mainCamera.perspectiveMatrix : \n${Engine.mainCamera.projectionMatrix}');
//
//    //idems
////    print('Engine.mainCamera.viewProjectionMatrix : \n${Engine.mainCamera.viewProjectionMatrix}');
//    print('Engine.mainCamera.viewProjectionMatrix calc: \n${Engine.mainCamera.projectionMatrix * Engine.mainCamera.viewMatrix}');
//
//    PointMesh model = new PointMesh()
//      ..translation = new Vector3(1.0,0.0,0.0);
//    meshes.add(model);
//
//    print('model.transform : \n${model.matrix}');
//    print('Context.modelMatrix : \n${Context.modelMatrix}');
//    print('Context.modelMatrix m : \n${Context.modelMatrix * model.matrix}');
//
//
//    /// from refelctions.vs.glsl
//    Vector3 aVertexPosition;
////    Vector3 aNormal;
//
//    Matrix4 uModelViewMatrix;
//    Matrix4 uProjectionMatrix;
//    Matrix4 uViewMatrix;
//    Matrix4 uModelMatrix;
//    Matrix3 uNormalMatrix;
//
//    //
//    aVertexPosition = new Vector3(0.0,0.0,0.0);
//
//    uModelMatrix = model.matrix;
//    uViewMatrix = Engine.mainCamera.viewMatrix;
//    uModelViewMatrix = (Engine.mainCamera.viewMatrix * uModelMatrix) as Matrix4;
//    uProjectionMatrix = Engine.mainCamera.projectionMatrix;
//    uNormalMatrix;
//
//    print("${uProjectionMatrix * uViewMatrix * uModelMatrix * aVertexPosition}");
//    print("${uProjectionMatrix * uModelViewMatrix * aVertexPosition}");
//
//    updateSceneFunction = () {
//      print('##');
//      print('model.transform : \n${model.matrix}');
//      print('Context.modelMatrix : \n${Context.modelMatrix}');
//      print('Context.modelMatrix m : \n${Context.modelMatrix * model.matrix}');
//    };
//  }
//}
