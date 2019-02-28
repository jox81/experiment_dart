import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/render_project.dart';
import 'package:webgl/src/project/project.dart';

import 'projects/animation_project.dart';

Future main() async {

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  Engine engine = new GLTFEngine(canvas);

  Project project = await AnimationProject.build();

  await renderProject(engine, project);
}
