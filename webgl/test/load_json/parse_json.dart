import 'dart:async';
@TestOn("dartium")

import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils.dart';

Future main() async {

  var testJson = await Utils.loadJSONResource('../objects/json_values.json');

  setUp(() async {
  });

  tearDown(() async {
  });

  group("json parse", () {
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
      Vector3 value = new Vector3.fromFloat32List(new Float32List.fromList(testJson['vector3Array']));
      expect(value.x == 10.0, isTrue);
      expect(value.y == 15.0, isTrue);
      expect(value.z == 20.0, isTrue);
      expect(value == new Vector3(10.0,15.0,20.0), isTrue);
    });

    // >> vector3Object
//    test("vector3Object", () {
//      Vector3 value = testJson['vector3Object'] as Vector3;
//      expect(value.x == 25.0, isTrue);
//    });
  });

}