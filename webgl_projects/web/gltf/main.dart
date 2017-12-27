import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/utils/utils_assets.dart';

Future main() async {
  List<String> gltfSamplesPaths = [
//    './projects/archi/model_01/model_01.gltf',
    './projects/archi/model_02/model_02.gltf',
  ];

  UtilsAssets.webPath = '../';
  GLTFProject gltf = await debugGltf(gltfSamplesPaths.first, doGlTFProjectLog : false, isDebug:false);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  await new GLTFRenderer(canvas, gltf).render();
}
