import 'dart:async';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';

Future main() async {
  List<String> gltfSamplesPaths = [
//    './samples/gltf_2_0/00_triangle_without_indices/gltf_embed/TriangleWithoutIndices.gltf',
//    './samples/gltf_2_0/00_triangle_without_indices/gltf/TriangleWithoutIndices.gltf',
//    './samples/gltf_2_0/01_triangle_with_indices/gltf_embed/Triangle.gltf',
//    './samples/gltf_2_0/01_triangle_with_indices/gltf/Triangle.gltf',
//    './samples/gltf_2_0/02_simple_meshes/gltf_embed/SimpleMeshes.gltf',
//    './samples/gltf_2_0/02_simple_meshes/gltf/SimpleMeshes.gltf',
//    './samples/gltf_2_0/03_animated_triangle/gltf_embed/AnimatedTriangle.gltf',
//    './samples/gltf_2_0/03_animated_triangle/gltf/AnimatedTriangle.gltf',
//    './samples/gltf_2_0/04_camera/gltf_embed/Cameras.gltf',
//    './samples/gltf_2_0/04_camera/gltf/Cameras.gltf',
//    './samples/gltf_2_0/05_box/gltf_embed/Box.gltf', // Todo (jpu) : render black ? => currentCamera.position = new Vector3(-5.0, -5.0, -10.0); with HAS_NORMALS = true
//    './samples/gltf_2_0/minimal.gltf',

  //textured
//    './samples/gltf_2_0/plane_textured/test_texture.gltf',// Todo (jpu) : render black ? => currentCamera.position = new Vector3(5.0, 5.0, 10.0);
//    './samples/gltf_2_0/06_duck/gltf_embed/Duck.gltf',
//    './samples/gltf_2_0/BoxTextured/glTF/BoxTextured.gltf',
//    './samples/gltf_2_0/BoxTextured/glTF/BoxTextured_multi.gltf',
//    './samples/gltf_2_0/BoxTextured/glTF-Embedded/BoxTextured.gltf',// Todo (jpu) : render black ? =>
//    './wip/simple_sphere/simple_sphere.gltf',

  //PBR
//    './samples/gltf_2_0/avocado/Avocado.gltf', //=> change fov, problem transparency one center:force 2sided
//    './samples/gltf_2_0/BarramundiFish/glTF/BarramundiFish.gltf',
//    './samples/gltf_2_0/BoomBox/glTF/BoomBox.gltf',
//    './samples/gltf_2_0/corset/glTF/Corset.gltf',
//    './samples/gltf_2_0/waterBottle/glTF/WaterBottle.gltf',
//    './samples/gltf_2_0/DamagedHelmet/glTF/DamagedHelmet.gltf',
//    './samples/gltf_2_0/lantern/gltf/Lantern.gltf',
//    './samples/gltf_2_0/MetalRoughSpheres/glTF/MetalRoughSpheres.gltf',
//    './samples/gltf_2_0/MetalRoughSpheres/glTF-Embedded/MetalRoughSpheres.gltf',// Todo (jpu) : problem with the base colors ?

  //Wip
//    './wip/export_test/export_test.gltf',
//    './wip/export_test/export_test_grey.gltf',
//    './wip/hierarchy_test/hieracrhy_test.gltf',
    './wip/archi/model_01/model_01.gltf',
//    './wip/archi/model_02/model_02.gltf',
  //Blender test Sphere
//    './blender_pbr/blender_test_ball/blender_test_ball_gltf_pbr.gltf'

    //Complex model hierarchy
    // Todo (jpu) :GL ERROR :GL_INVALID_OPERATION : glDrawElements: range out of bounds for buffer > do change indices offset ?
//    './samples/gltf_2_0/07_2cylinder_engine/gltf/2CylinderEngine.gltf',
//    './samples/gltf_2_0/08_reciprocating_saw/gltf_embed/ReciprocatingSaw.gltf',
//    './wip/blender_pbr/01_textured_sphere.gltf'
//    './blender_pbr/polly/project_polly.gltf'
  ];
//
  GLTFProject gltf = await debugGltf(gltfSamplesPaths.first, doGlTFProjectLog : false, isDebug:false);
  await new GLTFRenderer(gltf).render();
}
