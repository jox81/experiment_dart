import 'package:webgl/src/utils/utils_gltf.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';

@TestOn("dartium")

Future main() async {

  group("Buffer", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource('gltf/tests/base/data/buffer/empty.gltf', useWebPath:true);

      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);
      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 0);
    });
    test("Array length with empty data", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource('gltf/tests/base/data/buffer/valid_full.gltf', useWebPath:true);

      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);
      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 2);

      expect(buffers[0].byteLength,1);
      expect(buffers[0].data, isNull);

      expect(buffers[1].byteLength,1);
      expect(buffers[1].data, isNotNull);
    });
    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource('gltf/samples/gltf_2_0/minimal.gltf', useWebPath:true);

      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);
      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 1);

      GLTFBuffer buffer = buffers[0];
      expect(buffer.byteLength,44);
      expect(buffer.data, isNotNull);
      expect(buffer.data.length, buffers[0].byteLength);

    });
    test("uri", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource('gltf/tests/base/data/image/valid_full.gltf', useWebPath:true);

      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);
      List<GLTFBuffer> buffers = gltf.buffers;
      expect(buffers.length, 1);

      GLTFBuffer buffer = buffers[0];
      expect(buffer.byteLength,69);
      expect(buffer.uri.toString(), 'pink.png');

    });
  });
}
