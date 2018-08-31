import 'package:webgl/src/introspection.dart';

@reflector
abstract class GltfProperty{
  Map<String, Object> extensions;
  Object extras;

  GltfProperty();
}

@reflector
abstract class GLTFChildOfRootProperty extends GltfProperty {
  String name;

  GLTFChildOfRootProperty(this.name);
}