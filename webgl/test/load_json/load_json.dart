@TestOn("dartium")

import 'dart:convert';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/models.dart';

void main() {
  final String testJsonString = r'''
  {
    "scene": {
      "backgrounColor": [
        0.2,
        0.2,
        0.2,
        1
      ]
    },
    "cameras": [
      {
        "fov": 25,
        "zNear": 0.1,
        "zFar": 100,
        "targetPosition": [
          0.0,
          0.0,
          0.0
        ],
        "position": [
          10.0,
          10.0,
          10.0
        ],
        "showGizmo": true
      }
    ],
    "models": [
      {
        "type": "quad",
        "name": "quad",
        "position": [
          5.0,
          0.0,
          -5.0
        ]
      },
      {
        "type": "cube",
        "name": "cube",
        "position": [
          0.0,
          0.0,
          0.0
        ]
      }
    ]
  }
  ''';

  Map testJson;

  setUp(() async {
    testJson = JSON.decode(testJsonString);
  });

  tearDown(() async {
    testJson = null;
  });

  group("json read", () {
    test("test 01", () {
      String type = testJson['models'][0]["type"];
      expect(type, equals("quad"));
    });
  });

  group("test modelTest01", () {
    test("test model", () {
      Model model = Model.createFromJson(testJson['models'][0]);

      expect(model is QuadModel,isTrue);
    });
    test("test model name", () {
      Model model = Model.createFromJson(testJson['models'][0]);

      expect(model.name == 'quad',isTrue);
    });
    test("test model position", () {
      Model model = Model.createFromJson(testJson['models'][0]);

      expect(model.position == new Vector3(5.0, 0.0, -5.0),isTrue);
    });
  });

  group("test modelTest02", () {
    test("test model", () {
      Model model = Model.createFromJson(testJson['models'][1]);

      expect(model is CubeModel,isTrue);
    });
    test("test model name", () {
      Model model = Model.createFromJson(testJson['models'][1]);

      expect(model.name == 'cube',isTrue);
    });
    test("test model position", () {
      Model model = Model.createFromJson(testJson['models'][1]);

      expect(model.position == new Vector3(0.0, 0.0, 0.0),isTrue);
    });
  });
}