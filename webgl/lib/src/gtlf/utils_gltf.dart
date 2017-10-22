import 'dart:core';

abstract class GltfProperty {
  Map<String, Object> extensions;
  Object extras;

  GltfProperty();
}

abstract class GLTFChildOfRootProperty extends GltfProperty {
  String name;

  GLTFChildOfRootProperty(this.name);
}