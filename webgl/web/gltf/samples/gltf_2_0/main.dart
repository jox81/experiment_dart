import 'dart:async';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer.dart';

Future main() async {
  List<String> gltfSmaplePaths = [
//    '/gltf/samples/gltf_2_0/00_triangle_without_indices/gltf_embed/TriangleWithoutIndices.gltf',
//    '/gltf/samples/gltf_2_0/00_triangle_without_indices/gltf/TriangleWithoutIndices.gltf',
//    '/gltf/samples/gltf_2_0/01_triangle_with_indices/gltf_embed/Triangle.gltf',
//    '/gltf/samples/gltf_2_0/01_triangle_with_indices/gltf/Triangle.gltf',
//    'gltf/samples/gltf_2_0/02_simple_meshes/gltf_embed/SimpleMeshes.gltf',
//    'gltf/samples/gltf_2_0/02_simple_meshes/gltf/SimpleMeshes.gltf',
//    '/gltf/samples/gltf_2_0/03_animated_triangle/gltf_embed/AnimatedTriangle.gltf',
//    '/gltf/samples/gltf_2_0/03_animated_triangle/gltf/AnimatedTriangle.gltf',
//    '/gltf/samples/gltf_2_0/04_camera/gltf_embed/Cameras.gltf',
//    '/gltf/samples/gltf_2_0/04_camera/gltf/Cameras.gltf',
//    '/gltf/samples/gltf_2_0/05_box/gltf_embed/Box.gltf',
    '/gltf/samples/gltf_2_0/06_duck/gltf_embed/Duck.gltf'
  ];

  GLTFProject gltf = await debugGltf(gltfSmaplePaths.first, doLog : true);

  await new GLTFRenderer(gltf).render();
}
