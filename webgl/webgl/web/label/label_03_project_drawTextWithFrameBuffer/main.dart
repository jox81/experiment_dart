import 'dart:async';
import 'dart:html';
import 'package:webgl/render_project.dart';
import 'package:webgl/src/base/engine/engine.dart';
import 'project/project.dart';

Future main() async {

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  BaseEngine engine = new BaseEngine(canvas);

  LabelProject project = await LabelProject.build();
  await renderProject(engine, project);
}

