import 'dart:async';
import 'package:webgl/render_project.dart';
import 'package:webgl/src/engine/engine_type.dart';
import 'projects/project.dart';

Future main() async {
  await new ProjectLauncher().fromCreator(ArchiInteractive.build, EngineType.GLTF);
}
