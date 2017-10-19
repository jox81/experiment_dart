import 'dart:async';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer.dart';

//See tutorial : https://github.com/javagl/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_006_SimpleAnimation.md
Future main() async {
  String gltfUrl = '/gltf/samples/gltf_2_0/03_animated_triangle/gltf_embed/AnimatedTriangle.gltf';
  GLTFProject gltf = await debugGltf(gltfUrl);

  new GLTFRenderer(gltf)..render();
}
