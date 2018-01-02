import 'dart:async';
import 'package:webgl/src/gtlf/node.dart';

abstract class IComponent {

  IComponent();

  GLTFNode node;
  Future update();
}