import 'dart:async';
import 'dart:convert' show base64;
import "package:test/test.dart";
import 'package:webgl/src/gltf/gltf_creation.dart';
import 'package:webgl/src/utils/utils_assets.dart';

String testFolderRelativePath = "../..";

Future main() async {

  group("Base64 convert", () {
    test("base from inside gtlf", () async {
      /// based on sample data
      /// '/gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf'

      String fullGltfData64String = "data:application/octet-stream;base64,AAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAA";
      String base64GltFPrefix = "data:application/octet-stream;base64,";

      String baseGltfData64String = fullGltfData64String.substring(
          base64GltFPrefix.length);

      final List<int> base64Decoded = base64.decode(baseGltfData64String);
      expect(base64Decoded.length, 36);
      print(base64Decoded.length);
      print(base64Decoded);

      final String base64Encoded = base64.encode(base64Decoded);
      print(base64Encoded);

      expect(baseGltfData64String == base64Encoded, true);
    });

    test("base from inside gtlf bin uri", () async {
      /// based on sample data
      /// '/gltf/samples/gltf_2_0/TriangleWithoutIndices/gltf/triangleWithoutIndices.bin'

      String gltfBinUrl = '${testFolderRelativePath}/gltf/tests/samples/gltf_2_0/00_triangle_without_indices/gltf/triangleWithoutIndices.bin';
      String base64Result = 'AAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAA';
      UtilsAssets.useWebPath = true;

      List<int> base64Decoded = await GLTFCreation.loadGltfBinResource(gltfBinUrl, isRelative: false);
      expect(base64Decoded.length, 36);
      print(base64Decoded.length);
      print(base64Decoded);

      final String base64Encoded = base64.encode(base64Decoded);
      print(base64Encoded);

      expect(base64Result == base64Encoded, true);
    });

    test("image from inside gtlf uri", () async {
      /// based on sample data
      /// '/gltf/samples/gltf_2_0/BoxTextured/glTF-Embedded/BoxTextured.gltf'

      String fullGltfData64String = "data:image/png;base64,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";
      String base64GltFPrefix = "data:image/png;base64,";

      String baseGltfData64String = fullGltfData64String.substring(base64GltFPrefix.length);

      final List<int> base64Decoded = base64.decode(baseGltfData64String);
      expect(base64Decoded.length, 2433);
      print(base64Decoded.length);
      print(base64Decoded);

      final String base64Encoded = base64.encode(base64Decoded);
      print(base64Encoded);

      expect(baseGltfData64String == base64Encoded, true);
    });
  });
}
