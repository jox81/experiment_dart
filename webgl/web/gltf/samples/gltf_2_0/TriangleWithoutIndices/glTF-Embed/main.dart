import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'dart:async';

String gltfUrl = '/gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf';

Future main() async {
  await debugGltf(gltfUrl);
}