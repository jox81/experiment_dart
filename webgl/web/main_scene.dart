import 'dart:async';
import 'dart:html';
import 'package:webgl/scene_views/scene_view.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';

Future main() async {
  CanvasElement canvas = querySelector('#glCanvas');
  Application application = await Application.create(canvas);
  Scene scene = ServiceScene.getSceneViews()[0];
  await scene.setup();
  application.render(scene);
}
