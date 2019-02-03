import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './perle.gltf',
  ];

  String gltfPath = gltfSamplesPaths.first;
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFEngine engine = new GLTFEngine(canvas);
  (Engine.mainCamera as CameraPerspective).yfov = 44.07;

  GLTFProject project = await Engine.assetsManager.loadGLTFProject(gltfPath, useWebPath : false);
  await project.debug(doProjectLog : false, isDebug:false);

  await engine.render(project);
}
