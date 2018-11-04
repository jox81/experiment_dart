import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './perle.gltf',
  ];

  String gltfPath = gltfSamplesPaths.first;
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFProject gltfProject = await loadGLTF(gltfPath, useWebPath : false);
  await debugGltf(gltfProject, doGlTFProjectLog : false, isDebug:false);

  GLTFRenderer rendered = new GLTFRenderer(canvas);
  await rendered.init(gltfProject);
  rendered.mainCamera.yfov = 44.07;
  rendered.render();
}
