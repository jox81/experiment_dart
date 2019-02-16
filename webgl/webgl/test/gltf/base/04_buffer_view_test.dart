import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'dart:async';
import "package:test/test.dart";

import '../../data/gltf_helper.dart';
@TestOn("browser")

Future main() async {

  String testFolderRelativePath = "../..";

  group("BufferView", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/buffer_view/empty.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFBufferView> bufferViews = gltf.bufferViews;
      expect(bufferViews.length, 0);
    });
    test("Array length", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/buffer_view/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFBufferView> bufferViews = gltf.bufferViews;
      expect(bufferViews.length, 1);
    });
    test("BufferView properties", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/buffer_view/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      GLTFBufferView bufferView = gltf.bufferViews[0];
      expect(bufferView.byteLength,4);
      expect(bufferView.byteOffset, 0);
      expect(bufferView.byteStride, 4);
      expect(bufferView.usage, BufferType.ARRAY_BUFFER);
    });
  });
}
