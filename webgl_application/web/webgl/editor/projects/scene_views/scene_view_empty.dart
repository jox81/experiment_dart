import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';

GLTFProject projectSceneViewEmpty() {

  GLTFProject project = new GLTFProject.create();
  GLTFScene scene = new GLTFScene()
      ..backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
  project.scene = scene;


  // Todo (jpu) :
  //Cameras
  // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
//  Context.mainCamera = new
//  CameraPerspective(radians(37.0), 0.1, 1000.0)
//    ..targetPosition = new Vector3.zero()
//    ..translation = new Vector3(20.0, 20.0, 20.0);

  return project;
}
