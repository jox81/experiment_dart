import 'dart:async';
@TestOn("browser")

import 'dart:math';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';

Future main() async {

//  UtilsAssets.useWebPath = true;

//  CanvasElement canvas;

//  setUp(() async {
//    canvas = querySelector('#glCanvas');
//  });
//
//  tearDown(() async {
//    canvas = null;
//  });

//  group("Application Init", () {
//    test("application create test2", () async {
//      Application application = await Application.create(canvas);
//
//      GLTFCamera camera = new GLTFCamera(radians(37.0), 0.1, 100.0)
//        ..targetPosition = new Vector3.zero()
//        ..position = new Vector3(0.0, 0.0, -1.0);
//      Engine.mainCamera = camera;
//
//      //Todo ?...
//    });
//  });

  group("Base", () {
    test("identity", () async {
      Matrix3 m1 = new Matrix3.identity();
      Matrix3 m2 = new Matrix3(
          1.0, 0.0, 0.0,
          0.0, 1.0, 0.0,
          0.0, 0.0, 1.0,
      );

      expect(m1, m2);
    });

    test("setRotationX", () async {
      double angle = radians(90.0);

      double c = cos(angle);
      double s = sin(angle);

      Matrix3 m1 = new Matrix3(
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
      );
      m1.setRotationX(angle);

      Matrix3 m2 = new Matrix3(
        1.0, 0.0, 0.0,
        0.0, c, s,
        0.0, -s, c,
      );

      expect(m1, m2);
    });

    test("setRotationY", () async {
      double angle = radians(90.0);

      double c = cos(angle);
      double s = sin(angle);

      Matrix3 m1 = new Matrix3(
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
      );
      m1.setRotationY(angle);

      Matrix3 m2 = new Matrix3(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c,
      );

      expect(m1, m2);
    });

    test("setRotationZ", () async {
      double angle = radians(90.0);

      double c = cos(angle);
      double s = sin(angle);

      Matrix3 m1 = new Matrix3(
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
      );
      m1.setRotationZ(angle);

      Matrix3 m2 = new Matrix3(
          c, s, 0.0,
          -s, c, 0.0,
          0.0, 0.0, 1.0
      );
      expect(m1, m2);
    });
  });

}