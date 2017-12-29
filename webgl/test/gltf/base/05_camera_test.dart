import 'package:webgl/src/camera.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/gltf_creation.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
@TestOn("dartium")

Future main() async {

  group("Camera", () {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/camera/empty.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      List<Camera> cameras = gltf.cameras;
      expect(cameras.length, 0);
    });
    test("Filled Array", () async {
      String gltfPath = 'gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      expect(gltf.cameras.length, 2);
    });
    test("Camera Perspective Type", () async {
      String gltfPath = 'gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

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

      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

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
