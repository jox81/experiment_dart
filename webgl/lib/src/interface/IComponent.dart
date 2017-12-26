import 'dart:async';

import 'package:webgl/src/geometry/node.dart';

abstract class IComponent {

  IComponent();

  Node node;
  Future update();
}