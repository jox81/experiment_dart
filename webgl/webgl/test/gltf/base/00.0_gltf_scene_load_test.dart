import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/creation.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/project/project_debugger.dart';

@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {
  group("test camera", () {
    test("test camera creation", () async {
      GLTFProject project = await GLTFCreation.loadGLTFProject('${testFolderRelativePath}/gltf/tests/base/data/camera/empty.gltf', useWebPath : false);
      ProjectDebugger projectDebugger = new GLTFProjectDebugger();
      await projectDebugger.debug(project, doProjectLog : false, isDebug:false);
      expect(project, isNotNull);
    });
  });
}