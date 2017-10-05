import 'dart:async';
import 'package:gltf/gltf.dart';
import 'package:webgl/src/utils/utils_assets.dart';

Future main() async {

  UtilsAssets.useWebPath = true;
  var testJson = await UtilsAssets.loadJSONResource('gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf');

  Gltf gltf = new Gltf.fromMap(testJson, new Context());
  Mesh mesh = gltf.meshes[0];
}
