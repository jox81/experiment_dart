import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/utils/utils_gltf.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;

@TestOn("dartium")
Future main() async {
  group("Accessor", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource(
          'gltf/tests/base/data/accessor/empty.gltf',
          useWebPath: true);
      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);

      List<GLTFMaterial> materials = gltf.materials;
      expect(materials.length, 0);
    });
//    test("Array length", () async {
//      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource(
//          'gltf/tests/base/data/material/valid_full.gltf',
//          useWebPath: true);
//      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);
//
//      List<GLTFMaterial> materials = gltf.materials;
//      expect(materials.length, 1);
//    });
  });
}
