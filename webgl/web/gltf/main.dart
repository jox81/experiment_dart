import 'dart:async';
import 'dart:developer';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';

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
//    '/gltf/samples/gltf_2_0/05_box/gltf_embed/Box.gltf', // Todo (jpu) : render black ? => currentCamera.position = new Vector3(-5.0, -5.0, -10.0); with HAS_NORMALS = true
//    '/gltf/samples/gltf_2_0/minimal.gltf',

  //textured
//    '/gltf/samples/gltf_2_0/plane_textured/test_texture.gltf',// Todo (jpu) : render black ? => currentCamera.position = new Vector3(5.0, 5.0, 10.0);
//    '/gltf/samples/gltf_2_0/06_duck/gltf_embed/Duck.gltf',
//    '/gltf/samples/gltf_2_0/BoxTextured/glTF/BoxTextured.gltf',
//    '/gltf/samples/gltf_2_0/BoxTextured/glTF/BoxTextured_multi.gltf',
//    '/gltf/samples/gltf_2_0/BoxTextured/glTF-Embedded/BoxTextured.gltf',// Todo (jpu) : render black ? =>
//    '/gltf/wip/simple_sphere/simple_sphere.gltf',

  //Complex model
//    '/gltf/samples/gltf_2_0/07_2cylinder_engine/gltf_embed/2CylinderEngine.gltf',
    // Todo (jpu) :GL ERROR :GL_INVALID_OPERATION : glDrawElements: range out of bounds for buffer

  //PBR
//    '/gltf/samples/gltf_2_0/avocado/Avocado.gltf', //=> change fov, problem transparency one center:force 2sided
//    '/gltf/samples/gltf_2_0/BarramundiFish/glTF/BarramundiFish.gltf',
//    '/gltf/samples/gltf_2_0/BoomBox/glTF/BoomBox.gltf',
//    '/gltf/samples/gltf_2_0/corset/glTF/Corset.gltf',
//    '/gltf/samples/gltf_2_0/waterBottle/glTF/WaterBottle.gltf',
//    '/gltf/samples/gltf_2_0/DamagedHelmet/glTF/DamagedHelmet.gltf',
//    '/gltf/samples/gltf_2_0/MetalRoughSpheres/glTF-Embedded/MetalRoughSpheres.gltf',

  //Wip
//    '/gltf/wip/export_test/export_test.gltf',
//    '/gltf/wip/export_test/export_test_grey.gltf',
    '/gltf/wip/hierarchy_test/hieracrhy_test.gltf',
  ];
//
  GLTFProject gltf = await debugGltf(gltfSamplesPaths.first, doLog : false);
  await new GLTFRenderer(gltf).render();
}
