import 'dart:async';
import 'dart:html';
import 'package:webgl/render_gltf.dart';

Future main() async {
  List<String> gltfSamplesPaths = [
    './projects/archi/model_01/model_01.gltf',
//    './projects/archi/model_02/model_02.gltf',
  ];

  String gtltPath = gltfSamplesPaths.first;
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  await renderGltf(gtltPath, canvas);
}