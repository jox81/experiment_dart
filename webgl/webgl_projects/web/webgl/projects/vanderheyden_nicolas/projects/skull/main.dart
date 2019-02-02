import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/creation.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './skull.gltf',
  ];

  String gltfPath = gltfSamplesPaths.first;
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFProject project = await GLTFCreation.loadGLTFProject(gltfPath, useWebPath : false);
  await project.debug(doProjectLog : false, isDebug:false);

  GLTFEngine engine = new GLTFEngine(canvas);
  (Engine.mainCamera as CameraPerspective).yfov = 44.07;
  await engine.render(project);
}
