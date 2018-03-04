import 'package:test_webgl/src/introspection.dart';

abstract class GltfProperty extends IEditElement {
  Map<String, Object> extensions;
  Object extras;

  GltfProperty();
}

abstract class GLTFChildOfRootProperty extends GltfProperty {
  String name;

  GLTFChildOfRootProperty(this.name);
}