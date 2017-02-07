import 'package:webgl/src/object3d.dart';

abstract class IComponent {

  IComponent(this.object3d);

  Object3d object3d;
  update();
}