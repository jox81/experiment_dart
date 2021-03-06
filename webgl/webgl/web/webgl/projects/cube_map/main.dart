import 'dart:async';
import 'package:webgl/render_project.dart';
import 'package:webgl/src/engine/engine_type.dart';
import 'projects/scene_view_cubemap.dart';

Future main() async {
  await new ProjectLauncher().fromCreator(CubeMapProject.build, EngineType.GLTF);
}