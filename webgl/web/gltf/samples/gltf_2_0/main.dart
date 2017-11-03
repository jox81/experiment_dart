import 'dart:async';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer.dart';

Future main() async {
  List<String> gltfSamplesPaths = [
//    '/gltf/samples/gltf_2_0/00_triangle_without_indices/gltf_embed/TriangleWithoutIndices.gltf',
//    '/gltf/samples/gltf_2_0/00_triangle_without_indices/gltf/TriangleWithoutIndices.gltf',
//    '/gltf/samples/gltf_2_0/01_triangle_with_indices/gltf_embed/Triangle.gltf',
//    '/gltf/samples/gltf_2_0/01_triangle_with_indices/gltf/Triangle.gltf',
//    '/gltf/samples/gltf_2_0/02_simple_meshes/gltf_embed/SimpleMeshes.gltf',
//    '/gltf/samples/gltf_2_0/02_simple_meshes/gltf/SimpleMeshes.gltf',
//    '/gltf/samples/gltf_2_0/03_animated_triangle/gltf_embed/AnimatedTriangle.gltf',
//    '/gltf/samples/gltf_2_0/03_animated_triangle/gltf/AnimatedTriangle.gltf',
//    '/gltf/samples/gltf_2_0/04_camera/gltf_embed/Cameras.gltf',
//    '/gltf/samples/gltf_2_0/04_camera/gltf/Cameras.gltf',
//    '/gltf/samples/gltf_2_0/05_box/gltf_embed/Box.gltf', // Todo (jpu) : render black with pbr ? => currentCamera.position = new Vector3(-5.0, -5.0, -10.0); with HAS_NORMALS = true
//    '/gltf/samples/gltf_2_0/06_duck/gltf_embed/Duck.gltf',
//    '/gltf/samples/gltf_2_0/07_2cylinder_engine/gltf_embed/2CylinderEngine.gltf',

    '/gltf/samples/gltf_2_0/BoxTextured/glTF-Embedded/BoxTextured.gltf',// Todo (jpu) : render black with pbr ?
//    '/gltf/samples/gltf_2_0/plane_textured/test_texture.gltf',// Todo (jpu) : render black with pbr ? set
//    '/gltf/samples/gltf_2_0/minimal.gltf',

//    '/gltf/samples/gltf_2_0/avocado/Avocado.gltf',// Todo (jpu) : bug too muwh texture for now
  ];

  GLTFProject gltf = await debugGltf(gltfSamplesPaths.first, doLog : true);
  await new GLTFRenderer(gltf).render();
}
