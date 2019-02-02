import 'dart:async';
import 'dart:html';
import 'package:webgl/render_project.dart';

Future main() async {

  final List<String> gltfSamplesPaths = [
    './projects/maison/maison_ivoz.gltf',
  ];

  String gtltPath = gltfSamplesPaths.first;
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  await renderProjectFromPath(gtltPath, canvas);
}
