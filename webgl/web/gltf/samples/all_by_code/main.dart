import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';

import '00_triangle_without_indices/triangle_without_indices.dart';
import '01_triangle_with_indices/triangle_with_indices.dart';
import '02_a_simple_mesh/a_simple_mesh.dart';
import '02_b_multi_mesh/b_multi_mesh.dart';
import 'plane_textured/plane_texture.dart';

List<Function> projects = [
//  triangleWithoutIndices,
//  triangleWithIndices,
//  aSimpleMesh,
//  bMultiMesh,
  planeTexture
];

Future main() async {
  GLTFProject gltf = projects.first();

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  debugGltf(gltf, doGlTFProjectLog : true, isDebug:false);
  await new GLTFRenderer(canvas, gltf).render();
}
