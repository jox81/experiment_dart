import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@reflector
class GLTFSampler extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int samplerId = nextId++;

  /// TextureFilterType magFilter;
  final int magFilter;
  /// TextureFilterType minFilter;
  final int minFilter;
  /// TextureWrapType wrapS;
  final int wrapS;
  /// TextureWrapType wrapT;
  final int wrapT;

  GLTFSampler({
    this.magFilter : TextureFilterType.LINEAR,
    this.minFilter : TextureFilterType.LINEAR,
    this.wrapS,// Todo (jpu) : add default value ?
    this.wrapT,// Todo (jpu) : add default value ?
    String name : ''
  }):super(name){
    GLTFEngine.currentProject.samplers.add(this);
  }

  @override
  String toString() {
    return 'GLTFSampler{samplerId:$samplerId, magFilter: $magFilter, minFilter: $minFilter, wrapS: $wrapS, wrapT: $wrapT}';
  }
}