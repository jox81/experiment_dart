import 'dart:async';
import 'package:test_webgl/src/gltf/node.dart';

abstract class IComponent {

  IComponent();

  GLTFNode node;
  Future update();
}