import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/scene.dart';
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
    CameraPerspective camera = new CameraPerspective(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3(0.0, 0.0, 0.0)
      ..translation = new Vector3(0.0, 2.0, -1.0);
    Context.mainCamera = camera;

    print('Context.mainCamera.position : \n${Context.mainCamera.translation}');
    print('Context.mainCamera.targetPosition : \n${Context.mainCamera.targetPosition}');
    print('Context.mainCamera.lookAtMatrix : \n${Context.mainCamera.viewMatrix}');
    print('Context.mainCamera.perspectiveMatrix : \n${Context.mainCamera.projectionMatrix}');

    //idems
//    print('Context.mainCamera.viewProjectionMatrix : \n${Context.mainCamera.viewProjectionMatrix}');
    print('Context.mainCamera.viewProjectionMatrix calc: \n${Context.mainCamera.projectionMatrix * Context.mainCamera.viewMatrix}');

    PointModel model = new PointModel()
      ..translation = new Vector3(1.0,0.0,0.0);
    models.add(model);

    print('model.transform : \n${model.matrix}');
    print('Context.modelMatrix : \n${Context.modelMatrix}');
    print('Context.modelMatrix m : \n${Context.modelMatrix * model.matrix}');


    /// from refelctions.vs.glsl
    Vector3 aVertexPosition;
//    Vector3 aNormal;

    Matrix4 uModelViewMatrix;
    Matrix4 uProjectionMatrix;
    Matrix4 uViewMatrix;
    Matrix4 uModelMatrix;
    Matrix3 uNormalMatrix;

    //
    aVertexPosition = new Vector3(0.0,0.0,0.0);

    uModelMatrix = model.matrix;
    uViewMatrix = Context.mainCamera.viewMatrix;
    uModelViewMatrix = (Context.mainCamera.viewMatrix * uModelMatrix) as Matrix4;
    uProjectionMatrix = Context.mainCamera.projectionMatrix;
    uNormalMatrix;

    print("${uProjectionMatrix * uViewMatrix * uModelMatrix * aVertexPosition}");
    print("${uProjectionMatrix * uModelViewMatrix * aVertexPosition}");

    updateSceneFunction = () {
      print('##');
      print('model.transform : \n${model.matrix}');
      print('Context.modelMatrix : \n${Context.modelMatrix}');
      print('Context.modelMatrix m : \n${Context.modelMatrix * model.matrix}');
    };
  }
}
