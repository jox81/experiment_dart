import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/utils/utils_gltf.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;

@TestOn("dartium")

Future main() async {

  group("BufferView", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/buffer_view/empty.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFBufferView> bufferViews = gltf.bufferViews;
      expect(bufferViews.length, 0);
    });
    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/buffer_view/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFBufferView> bufferViews = gltf.bufferViews;
      expect(bufferViews.length, 1);
    });
    test("BufferView properties", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/buffer_view/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFBufferView bufferView = gltf.bufferViews[0];
      expect(bufferView.byteLength,4);
      expect(bufferView.byteOffset, 0);
      expect(bufferView.byteStride, 4);
      expect(bufferView.usage, BufferType.ARRAY_BUFFER);
    });
  });
}
