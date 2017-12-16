import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GLTFSampler extends GLTFChildOfRootProperty {
  static int nextId = 0;

  glTF.Sampler _gltfSource;
  glTF.Sampler get gltfSource => _gltfSource;

  int samplerId;

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
    this.wrapS,// Todo (jpu) : add default value
    this.wrapT,// Todo (jpu) : add default value
    String name : ''
  }):super(name);

  factory GLTFSampler.fromGltf(glTF.Sampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFSampler sampler = new GLTFSampler(
        magFilter : gltfSource.magFilter != -1 ? gltfSource.magFilter : TextureFilterType.LINEAR,
        minFilter : gltfSource.minFilter != -1 ? gltfSource.magFilter : TextureFilterType.LINEAR,
        wrapS : gltfSource.wrapS,
        wrapT : gltfSource.wrapT,
        name : gltfSource.name
    );
    sampler._gltfSource = gltfSource;
    return sampler;
  }

  @override
  String toString() {
    return 'GLTFSampler{samplerId:$samplerId, magFilter: $magFilter, minFilter: $minFilter, wrapS: $wrapS, wrapT: $wrapT}';
  }
}