import 'dart:async';
import 'dart:html';
import 'package:webgl/src/project.dart';
import 'package:webgl_application/scene_views/scene_view.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';

Future main() async {
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  Application application = await Application.create(canvas);

  Project project = await ServiceProject.getProjects().then((p) => p[0]);
  Scene scene = project.scene;
  await scene.setup();

  Application.instance.currentScene = scene;
  application.render();
}
