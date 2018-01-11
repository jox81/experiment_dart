import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';

Future main() async {
  ProjectService.loader = loadBaseProjects;
  ProjectService service = new ProjectService();
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;


  await Application.build(canvas)
  ..project = (await service.getProjects())[0]
    ..render();
}
