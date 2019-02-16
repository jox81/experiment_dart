import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './plaquette.gltf',
  ];

  String gltfPath = gltfSamplesPaths.first;
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;


  GLTFEngine engine = new GLTFEngine(canvas);
  (Engine.mainCamera as CameraPerspective).yfov = 44.07;

  GLTFProjectLoader gLTFProjectLoader = new GLTFProjectLoader()..filePath = gltfPath;
  await gLTFProjectLoader.load();
  GLTFProject project = gLTFProjectLoader.result;
  await project.debug(doProjectLog : false, isDebug:false);

  await engine.init(project);
  await engine.render();
}
