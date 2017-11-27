import 'dart:async';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';

Future main() async {
  List<String> gltfSamplesPaths = [
    '/gltf/projects/archi/model_01/model_01.gltf',
  ];

  GLTFProject gltf = await debugGltf(gltfSamplesPaths.first, doGlTFProjectLog : false, isDebug:false);
  await new GLTFRenderer(gltf).render();
}
