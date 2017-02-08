import 'package:webgl/src/geometry/object3d.dart';

abstract class IComponent {

  IComponent();

  Object3d object3d;
  update();
}