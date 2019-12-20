import 'dart:async';
import 'package:webgl/render_project.dart';
import 'package:webgl/src/engine/engine_type.dart';
import 'projects/scene_view_primitives.dart';

Future main() async {
  await new ProjectLauncher().fromCreator(PrimitivesProject.build, EngineType.GLTF);
}
