import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart';
import 'dart:io';


Future main() async {

  group("json read", () {
    test("test 01", () async {
      final reader = new GltfJsonReader(
          new File('web/gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf').openRead());
      final result = await reader.read();
      expect(result.gltf, const isInstanceOf<Gltf>());
    });
  });
}