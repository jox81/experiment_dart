import 'dart:async';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:webgl/src/gtlf/accessor.dart';
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
  });
}
