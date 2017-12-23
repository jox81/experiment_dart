import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;
import 'package:test/test.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/gltf_creation.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
@TestOn("dartium")

Future main() async {

  group("Camera", () async {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/camera/empty.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<Camera> cameras = gltf.cameras;
      expect(cameras.length, 0);
    });
    test("Filled Array", () async {
      String gltfPath = 'gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);
      expect(gltf.cameras.length, 2);
    });
    test("Camera Perspective Type", () async {
      String gltfPath = 'gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      expect(gltf.cameras[0], isNotNull);
      expect(gltf.cameras[0] is CameraPerspective, isTrue);
      CameraPerspective cameraPerspective = gltf.cameras[0] as CameraPerspective;
      expect(cameraPerspective.type, CameraType.perspective);
      expect(cameraPerspective.znear, 1.0);
      expect(cameraPerspective.zfar, 10.0);
      expect(cameraPerspective.yfov, 1.0);
      expect(cameraPerspective.aspectRatio, 1.0);

    });
    test("Camera Orthographic Type", () async {
      String gltfPath = 'gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      expect(gltf.cameras[1], isNotNull);
      expect(gltf.cameras[1] is CameraOrthographic, isTrue);
      CameraOrthographic cameraOrthographic = gltf.cameras[1] as CameraOrthographic;
      expect(cameraOrthographic.type, CameraType.orthographic);
      expect(cameraOrthographic.znear, 1.0);
      expect(cameraOrthographic.zfar, 10.0);
      expect(cameraOrthographic.ymag, 1.0);
      expect(cameraOrthographic.xmag, 1.0);

    });
  });
}
