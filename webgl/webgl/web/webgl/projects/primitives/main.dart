import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/render_project.dart';

import 'projects/scene_view_primitives.dart';

Future main() async {

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFEngine engine = new GLTFEngine(canvas);

  PrimitivesProject primitivesProject = await PrimitivesProject.build();

  await renderProject(engine, primitivesProject);
}
