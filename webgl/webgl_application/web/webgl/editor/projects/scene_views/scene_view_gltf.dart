import 'dart:async';
import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:vector_math/vector_math.dart';

Future<GLTFProject> projectSceneViewGltf() async {

  final List<String> gltfSamplesPaths = [
    './projects/archi/model_01/model_01.gltf',
  ];

  GLTFProject project = await GLTFCreation.loadGLTFProject(gltfSamplesPaths.first, useWebPath : false);

  Engine.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  return project;
}
