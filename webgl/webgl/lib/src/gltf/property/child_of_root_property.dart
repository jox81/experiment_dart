import 'package:webgl/src/gltf/property/property.dart';
import 'package:webgl/src/introspection/introspection.dart';

@reflector
abstract class GLTFChildOfRootProperty extends GltfProperty {
  String name;

  GLTFChildOfRootProperty(this.name);
}