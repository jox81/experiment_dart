import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';

//import '00_triangle_without_indices/triangle_without_indices.dart';
//import '01_triangle_with_indices/triangle_with_indices.dart';
//import '02_a_simple_mesh/a_simple_mesh.dart';
//import '02_b_multi_mesh/b_multi_mesh.dart';
//import '05_box/box.dart';
//import 'plane_textured/plane_texture.dart';
//import 'primitives/primitives.dart';
import 'materials/materials.dart';

List<Function> projects = [
//  triangleWithoutIndices,
//  triangleWithIndices,
//  aSimpleMesh,
//  bMultiMesh,
//  planeTexture,
//  box,
//primitives,
projectTestMaterials
];

Future main() async {
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  GLTFRenderer renderer = await new GLTFRenderer(canvas);

  GLTFProject gltf = await projects.first();
  debugGltf(gltf, doGlTFProjectLog : true, isDebug:false);

  renderer.render();
}
