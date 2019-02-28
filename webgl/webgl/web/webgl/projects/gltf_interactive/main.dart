import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/render_project.dart';
import 'package:webgl/src/project/project.dart';

import 'projects/project.dart';

Future main() async {

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  GLTFEngine engine = new GLTFEngine(canvas);

  Project project = await ArchiInteractive.build();

  await renderProject(engine, project);
}
