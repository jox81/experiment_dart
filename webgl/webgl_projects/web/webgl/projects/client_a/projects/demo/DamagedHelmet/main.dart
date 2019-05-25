import 'dart:async';
import 'package:webgl/render_project.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './glTF/DamagedHelmet.gltf',
  ];

  String gtltPath = gltfSamplesPaths.first;

  await new ProjectLauncher().fromPath(gtltPath);
}
