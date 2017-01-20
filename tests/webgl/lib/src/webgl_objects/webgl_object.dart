import 'package:webgl/src/introspection.dart';

abstract class WebGLObject extends IEditElement {
  bool invalidated;
  void delete();
}