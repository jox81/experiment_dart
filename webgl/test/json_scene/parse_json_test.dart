@TestOn("dartium")

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/utils/utils_assets.dart';

Future main() async {
  UtilsAssets.useWebPath = true;
  Map testJson;

  setUp(() async {
    testJson = await UtilsAssets.loadJSONResource('../objects/json_values.json');
  });

  tearDown(() async {
    testJson = null;
  });

  group("json read", () {
    test("int", () {
      int value = testJson['int'] as int;
      expect(value == 120, isTrue);
    });
    test("num", () {
      num value = testJson['num'] as num;
      expect(value == 123.5, isTrue);
    });
    test("double", () {
      double value = testJson['double'] as double;
      expect(value == 125.32, isTrue);
    });

    // >> vector3Array

    test("vector3Array", () {
      Vector3 value = new Vector3(testJson['vector3Array'][0] as double, testJson['vector3Array'][1] as double, testJson['vector3Array'][2] as double);
      expect(value.x == 10.0, isTrue);
      expect(value.y == 15.0, isTrue);
      expect(value.z == 20.0, isTrue);
      expect(value == new Vector3(10.0,15.0,20.0), isTrue);
    });
    test("vector3Array", () {
      Vector3 value = new Vector3.fromFloat32List(new Float32List.fromList(testJson['vector3Array'] as List<double>));
      expect(value.x == 10.0, isTrue);
      expect(value.y == 15.0, isTrue);
      expect(value.z == 20.0, isTrue);
      expect(value == new Vector3(10.0,15.0,20.0), isTrue);
    });

  });

  group("json write", () {
    test("change compare", () {
      String jsonString = '{"int":12}';
      Map jsonMap = JSON.decode(jsonString) as Map;
      String jsonEncoded = (JSON.encode(jsonMap));
      expect(jsonString == jsonEncoded, isTrue);
    });
    test("change value", () {
      String jsonString = '{"int":12}';
      Map jsonMap = JSON.decode(jsonString) as Map;

      jsonMap['int'] += 5;

      String jsonEncoded = (JSON.encode(jsonMap));
      expect(jsonEncoded == '{"int":17}', isTrue);
    });
  });

}


