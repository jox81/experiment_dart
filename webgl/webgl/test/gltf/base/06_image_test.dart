import 'package:webgl/src/gltf/image.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/debug_gltf.dart';
@TestOn("browser")


String testFolderRelativePath = "../..";

Future main() async {

  group("Image", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/image/empty.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);

      List<GLTFImage> images = gltf.images;
      expect(images.length, 0);
    });
    test("Array length", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/image/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);

      List<GLTFImage> images = gltf.images;
      expect(images.length, 3);
    });
    test("properties", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/image/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);

      GLTFImage image00 = gltf.images[0];
      expect(image00.uri.toString(), "pink.png");
      expect(image00.mimeType, isNull);
      expect(image00.data, isNull);
      expect(image00.bufferView, isNull);

      GLTFImage image01 = gltf.images[1];
      expect(image01.uri, isNull);
      expect(image01.mimeType, "image/png");
      expect(image01.data, isNull);
      expect(image01.bufferView, isNotNull);

      GLTFImage image02 = gltf.images[2];
      expect(image02.uri, isNull);
      expect(image02.mimeType, "image/png");
      expect(image02.data, isNotNull);
      expect(image02.data.length, 69);
      expect(image02.bufferView, isNull);
    });
  });
}
