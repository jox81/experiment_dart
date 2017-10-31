import 'dart:async';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer.dart';

Future main() async {
  String gltfUrl = 'gltf/samples/gltf_2_0/02_simple_meshes/gltf_embed/SimpleMeshes.gltf';
  GLTFProject gltf = await debugGltf(gltfUrl);

  await new GLTFRenderer(gltf).render();
}
