import 'dart:html';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/project/project.dart';

//only used for tests
Future<GLTFProject> loadGLTFProject(String filaePath) async {
  new GLTFEngine(new CanvasElement());

  GLTFProjectLoader loader = new GLTFProjectLoader()
    ..filePath = filaePath;

  await loader.load();

  return loader.result;
}