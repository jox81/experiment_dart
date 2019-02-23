import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/render_project.dart';
import 'projects/project.dart';

Future main() async {
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  GLTFEngine engine = new GLTFEngine(canvas);

  Gantt3dProject cubeMapProject = await Gantt3dProject.build();

  await renderProject(engine, cubeMapProject);
}