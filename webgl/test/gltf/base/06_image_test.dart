import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;

@TestOn("dartium")

Future main() async {

  group("Image", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/image/empty.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFImage> images = gltf.images;
      expect(images.length, 0);
    });
    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/image/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFImage> images = gltf.images;
      expect(images.length, 3);
    });
    test("properties", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/image/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

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
