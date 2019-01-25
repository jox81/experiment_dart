import 'package:webgl/src/introspection/IEdit_element.dart';
import 'reflector.dart';

@reflector
class CustomEditElement extends IEditElement {
  final dynamic element;
  CustomEditElement(this.element);
}