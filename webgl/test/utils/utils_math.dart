import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/utils/utils_math.dart';

Future main() async {
  group("findNextIntMultiple", () {
    test("base test", () async {
      int baseMultiple = 4;
      print('baseMultiple : $baseMultiple');
      for (var startValue = 1; startValue < 20; startValue++) {
        int nextMultiple = UtilsMath.findNextIntMultiple(startValue , baseMultiple);
        print('startValue : $startValue, nextMultiple : $nextMultiple');
        expect(nextMultiple % baseMultiple == 0, true);
      }
    });
  });
}
