import 'package:webgl/src/introspection/introspection.dart';

//@reflector
abstract class GltfProperty{
  Map<String, Object> extensions;
  Object extras;

  GltfProperty();
}