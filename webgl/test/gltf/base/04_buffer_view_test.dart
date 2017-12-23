import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/gltf_creation.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
@TestOn("dartium")

Future main() async {

  group("BufferView", () {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/buffer_view/empty.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFBufferView> bufferViews = gltf.bufferViews;
      expect(bufferViews.length, 0);
    });
    test("Array length", () async {
      String gltfPath = 'gltf/tests/base/data/buffer_view/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFBufferView> bufferViews = gltf.bufferViews;
      expect(bufferViews.length, 1);
    });
    test("BufferView properties", () async {
      String gltfPath = 'gltf/tests/base/data/buffer_view/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      GLTFBufferView bufferView = gltf.bufferViews[0];
      expect(bufferView.byteLength,4);
      expect(bufferView.byteOffset, 0);
      expect(bufferView.byteStride, 4);
      expect(bufferView.usage, BufferType.ARRAY_BUFFER);
    });
  });
}
