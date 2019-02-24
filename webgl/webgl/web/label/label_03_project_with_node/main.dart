import 'dart:async';
import 'dart:html';
import 'package:webgl/gltf.dart';
import 'package:webgl/render_project.dart';
import 'project/project.dart';

Future main() async {

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFEngine engine = new GLTFEngine(canvas);

  LabelProject project = await LabelProject.build();
  await renderProject(engine, project);
}

