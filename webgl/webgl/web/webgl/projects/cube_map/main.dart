import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/render_project.dart';
import 'projects/scene_view_cubemap.dart';

Future main() async {
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFEngine engine = new GLTFEngine(canvas);

  CubeMapProject cubeMapProject = await CubeMapProject.build();

  await renderProject(engine, cubeMapProject);
}