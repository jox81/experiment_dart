import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl_application/scene_views/scene_view.dart';
import 'package:webgl_application/src/application.dart';

Future main() async {
  GLTFProject project = await ServiceProject.getProjects().then((p) => p[0]);
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  await Application.build(canvas)
    ..project = project
    ..render();
}
