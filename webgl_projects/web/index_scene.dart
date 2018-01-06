import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl_application/src/application.dart';

Future main() async {
//  GLTFProject project = await ServiceProject.getProjects().then((p) => p[0]);

  List<String> gltfSamplesPaths = [
    './gltf/projects/archi/model_01/model_01.gltf',
//    './projects/archi/model_02/model_02.gltf',
  ];

  UtilsAssets.webPath = '../';
  GLTFProject project = await loadGLTF(gltfSamplesPaths.first, useWebPath : false);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  await Application.build(canvas)
    ..project = project
    ..render();
}
