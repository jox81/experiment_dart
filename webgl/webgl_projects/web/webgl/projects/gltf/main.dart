import 'dart:async';
import 'dart:html';
import 'package:webgl/render_project.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './projects/archi/model_01/model_01.gltf',
//    './projects/space_ships/space_ship_01/space_ship_01.gltf',
  ];

  String gtltPath = gltfSamplesPaths.first;

  await new ProjectLauncher().fromPath(gtltPath);
}
