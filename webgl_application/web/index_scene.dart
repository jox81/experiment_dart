import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';

Future main() async {
  ProjectService.projects = await loadBaseProjects();
  ProjectService service = new ProjectService();
  GLTFProject project = await service.getProjects()[0];
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  await Application.build(canvas)
    ..project = project
    ..render();
}
