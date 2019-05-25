import 'dart:async';
import 'package:webgl/asset_library.dart';
import 'package:webgl/render_project.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './projects/archi/model_01/model_01.gltf',
//    './projects/archi/model_02/model_02.gltf',
  ];

  String gtltPath = gltfSamplesPaths.first;
  await AssetLibrary.loadDefault();

  await new ProjectLauncher().fromPath(gtltPath);
}
