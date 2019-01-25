import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import "package:test/test.dart";

String testFolderRelativePath = "../..";

void main() {
  group('Accessor getElements', () {
    GLTFProject gltf;

//    setUpAll(() async {
//      final reader = new GltfJsonReader(
//          new File('test/base/data/accessor/get_elements.gltf').openRead());
//
//      result = await reader.read();
//
//      expect(reader.context.errors, isEmpty);
//      expect(reader.context.warnings, isEmpty);
//
//      // All buffers are loaded
//      expect(result.gltf.buffers.every((buffer) => buffer.data != null), true);
//    });

    setUpAll(() async {
      String gltfPath =
          '${testFolderRelativePath}/gltf/tests/base/data/accessor/get_elements.gltf';
      gltf = await loadGLTFProject(gltfPath, useWebPath : false);
      await debugProject(gltf, doProjectLog : false, isDebug:false);


      // All buffers are loaded
      expect(gltf.buffers.every((buffer) => buffer.data != null), true);
    });

//    test('Regular', () async {
//      final elements = gltf.accessors[0].getElements();
//
//      expect(
//          elements, orderedEquals(<double>[0.0, -5.0, 27.0, -0.0, 10.5, 0.5]));
//    });
//
//    test('scalar float & vec2 ushort', () async {
//      final elements1 = result.gltf.accessors[1].getElements();
//      final elements2 = result.gltf.accessors[2].getElements();
//      final elements2n = result.gltf.accessors[2].getElements(normalize: true);
//
//      expect(elements1, orderedEquals(<double>[1000.0, 0.25]));
//      expect(elements2, orderedEquals(<int>[50, 45, 12345, 0]));
//      expect(
//          elements2n,
//          orderedEquals(<double>[
//            50 * (1 / 65535),
//            45 * (1 / 65535),
//            12345 * (1 / 65535),
//            0.0
//          ]));
//    });
//
//    test('vec3 byte & vec4 short', () async {
//      final elements1 = result.gltf.accessors[3].getElements();
//      final elements1n = result.gltf.accessors[3].getElements(normalize: true);
//      final elements2 = result.gltf.accessors[4].getElements();
//      final elements2n = result.gltf.accessors[4].getElements(normalize: true);
//
//      expect(elements1, orderedEquals(<int>[1, 126, -127, 0, 50, -125]));
//      expect(
//          elements1n,
//          orderedEquals(<double>[
//            1 / 127,
//            126 * (1 / 127),
//            -127 * (1 / 127),
//            0.0,
//            50 * (1 / 127),
//            -125 * (1 / 127)
//          ]));
//      expect(
//          elements2, orderedEquals(<int>[50, 45, 12345, 0, -1, 45, 12345, 0]));
//
//      expect(
//          elements2n,
//          orderedEquals(<double>[
//            50 * (1 / 32767),
//            45 * (1 / 32767),
//            12345 * (1 / 32767),
//            0.0,
//            -1 * (1 / 32767),
//            45 * (1 / 32767),
//            12345 * (1 / 32767),
//            0 * (1 / 32767)
//          ]));
//    });
  });
}
