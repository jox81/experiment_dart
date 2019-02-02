import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/context.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './skull.gltf',
  ];

  String gltfPath = gltfSamplesPaths.first;
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFProject project = await loadGLTF(gltfPath, useWebPath : false);
  await debugGltf(project, doGlTFProjectLog : false, isDebug:false);

  GLTFEngine engine = new GLTFEngine(canvas);
  await engine.renderer.init(project);
  Context.mainCamera.yfov = 44.07;
  engine.render();
}
