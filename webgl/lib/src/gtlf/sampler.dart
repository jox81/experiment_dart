import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFSampler extends GLTFChildOfRootProperty {
  glTF.Sampler _gltfSource;

  int samplerId;
  glTF.Sampler get gltfSource => _gltfSource;

  /// TextureFilterType magFilter;
  final int magFilter;
  /// TextureFilterType minFilter;
  final int minFilter;
  /// TextureWrapType wrapS;
  final int wrapS;
  /// TextureWrapType wrapT;
  final int wrapT;

  GLTFSampler._(this._gltfSource)
      : this.magFilter = _gltfSource.magFilter,
        this.minFilter = _gltfSource.minFilter,
        this.wrapS = _gltfSource.wrapS,
        this.wrapT = _gltfSource.wrapT,
        super(_gltfSource.name);

  GLTFSampler(this.magFilter, this.minFilter, this.wrapS, this.wrapT,[String name]):super(name);

  factory GLTFSampler.fromGltf(glTF.Sampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFSampler sampler = new GLTFSampler._(gltfSource);
    return sampler;
  }

  @override
  String toString() {
    return 'GLTFSampler{samplerId:$samplerId, magFilter: $magFilter, minFilter: $minFilter, wrapS: $wrapS, wrapT: $wrapT}';
  }
}