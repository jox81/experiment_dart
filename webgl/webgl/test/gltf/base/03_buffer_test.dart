import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'dart:async';
import "package:test/test.dart";
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {

  group("Buffer", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/buffer/empty.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);
      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 0);
    });
    test("Array length with empty data", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/buffer/valid_full.gltf';

      GLTFProject gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);

      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 2);

      expect(buffers[0].byteLength,1);
      expect(buffers[0].data, isNotNull);

      expect(buffers[1].byteLength,1);
      expect(buffers[1].data, isNotNull);
    });
    test("Array length", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/minimal.gltf';

      GLTFProject gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);

      print(gltf);

      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 1);

      GLTFBuffer buffer = buffers[0];
      expect(buffer.byteLength,44);
      expect(buffer.data, isNotNull);
      expect(buffer.data.length, buffers[0].byteLength);

    });
    test("uri", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/image/valid_full.gltf';

      GLTFProject gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);

      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 1);

      GLTFBuffer buffer = buffers[0];
      expect(buffer.byteLength,69);
      expect(buffer.uri.toString(), 'pink.png');

    });
  });
}