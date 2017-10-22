import 'dart:async';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer.dart';

Future main() async {
  String gltfUrl = '/gltf/samples/gltf_2_0/05_box/gltf_embed/Box.gltf';
  GLTFProject gltf = await debugGltf(gltfUrl, doLog : true);

  new GLTFRenderer(gltf)..render();
}
