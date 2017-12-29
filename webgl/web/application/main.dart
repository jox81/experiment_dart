import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'primitives.dart';

Future main() async {
  GLTFProject project = getProjectTriangleWithIndices();

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  await new GLTFRenderer(canvas, project).render();
}
