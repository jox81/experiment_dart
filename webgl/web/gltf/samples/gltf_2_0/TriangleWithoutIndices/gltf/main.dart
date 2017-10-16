import 'dart:async';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer.dart';

Future main() async {
  String gltfUrl = '/gltf/samples/gltf_2_0/TriangleWithoutIndices/gltf/triangleWithoutIndices.gltf';
  gltf = await debugGltf(gltfUrl);

  new GLTFRenderer(gltf)..render();
}
