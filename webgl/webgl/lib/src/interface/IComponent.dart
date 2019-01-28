import 'dart:async';
import 'package:webgl/src/gltf/node.dart';

abstract class IComponent {

  IComponent();

  GLTFNode node;
  Future update();
}