import 'dart:async';
import 'package:webgl/render_project.dart';
import 'projects/project.dart';
import 'package:webgl/src/engine/engine_type.dart';

Future main() async {
  await new ProjectLauncher().fromCreator(Gantt3dProject.build, EngineType.GLTF);
}