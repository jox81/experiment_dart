import 'dart:async';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:webgl/src/utils/utils_math.dart';

Future main() async {
  group("findNextIntMultiple", () {
    test("base test", () async {
      int baseMultiple = 4;
      print('baseMultiple : $baseMultiple');
      for (var startValue = 1; startValue < 20; startValue++) {
        int nextMultiple =
            UtilsMath.findNextIntMultiple(startValue, baseMultiple);
        print('startValue : $startValue, nextMultiple : $nextMultiple');
        expect(nextMultiple % baseMultiple == 0, true);
      }
    });
  });
  group("convertVec2FloatListToVec3FloatList", () {
    test("base test", () async {
      Float32List baseList =
          new Float32List.fromList([1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0]);
      double fillValue = 0.0;
      print(baseList);

      baseList =
          UtilsMath.convertVec2FloatListToVec3FloatList(baseList, fillValue);
      print(baseList);
      expect(baseList,
          [1.0, 1.0, 0.0, 2.0, 2.0, 0.0, 3.0, 3.0, 0.0, 4.0, 4.0, 0.0]);
    });
    test("base test 2", () async {
      Float32List baseList =
          new Float32List.fromList([
            0.0, 0.0,
            1.0, 0.0,
            0.0, 1.0,
          ]);
      double fillValue = 0.0;
      print(baseList);

      baseList =
          UtilsMath.convertVec2FloatListToVec3FloatList(baseList, fillValue);
      print(baseList);
      expect(baseList,
          [
            0.0, 0.0, 0.0,
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
          ]);
    });
    test("base test 3", () async {
      List<List<double>> _colorsFace = [
        [1.0, 0.0, 0.0, 1.0], // Front face
        [1.0, 1.0, 0.0, 1.0], // Back face
        [0.0, 0.0, 1.0, 1.0], // Right face
        [1.0, 0.0, 1.0, 1.0], // Left face
        [0.0, 1.0, 1.0, 1.0], // Bottom face
        [0.0, 1.0, 1.0, 1.0], // Bottom face
      ];

      var colors = new List.generate(4 * 4 * _colorsFace.length, (int index) {
        // index ~/ 18 returns 0-5, that's color index
        // index % 4 returns 0-3 that's color component for each color
        return _colorsFace[index ~/ 18][index % 4];
      }, growable: false);

      print("colors : ");
      print(colors);
    });
  });
}
