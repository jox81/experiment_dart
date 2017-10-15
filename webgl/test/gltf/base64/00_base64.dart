import 'dart:async';
import 'dart:convert' show BASE64;
import "package:test/test.dart";

Future main() async {

  group("Base64 convert", () {
    test("base", () async {
      /// based on sample data
      /// '/gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf'

      String fullGltfData64String = "data:application/octet-stream;base64,AAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAA";
      String base64GltFPrefix = "data:application/octet-stream;base64,";

      String baseGltfData64String = fullGltfData64String.substring(base64GltFPrefix.length);

      final List<int> base64Decoded = BASE64.decode(baseGltfData64String);
      expect(base64Decoded.length, 36);
      print(base64Decoded.length);
      print(base64Decoded);

      final String base64Encoded = BASE64.encode(base64Decoded);
      print(base64Encoded);

      expect(baseGltfData64String == base64Encoded, true);
    });
  });
}
