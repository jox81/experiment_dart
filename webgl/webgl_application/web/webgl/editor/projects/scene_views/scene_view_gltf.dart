import 'dart:async';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:vector_math/vector_math.dart';

Future<GLTFProject> projectSceneViewGltf() async {

  final List<String> gltfSamplesPaths = [
    './projects/archi/model_01/model_01.gltf',
  ];

  GLTFProject project = await loadGLTF(gltfSamplesPaths.first, useWebPath : false);

  Context.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  return project;
}
