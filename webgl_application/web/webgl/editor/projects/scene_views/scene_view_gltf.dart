import 'dart:async';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';

Future<GLTFProject> projectSceneViewGltf() async {

  final List<String> gltfSamplesPaths = [
    './projects/archi/model_01/model_01.gltf',
  ];

  GLTFProject project = await loadGLTF(gltfSamplesPaths.first, useWebPath : false);

  return project;
}
