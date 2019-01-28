import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

GLTFProject projectSceneViewEmpty() {

  GLTFProject project = new GLTFProject.create();
  GLTFScene scene = new GLTFScene()
      ..backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
  project.scene = scene;

  Context.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  return project;
}