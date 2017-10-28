import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GLTFSampler extends GLTFChildOfRootProperty {
  glTF.Sampler _gltfSource;

  int samplerId;// Todo (jpu) :
  glTF.Sampler get gltfSource => _gltfSource;

  final TextureFilterType magFilter;
  final TextureFilterType minFilter;
  final TextureWrapType wrapS;
  final TextureWrapType wrapT;

  GLTFSampler._(this._gltfSource)
      : this.magFilter = TextureFilterType.getByIndex(_gltfSource.magFilter),
        this.minFilter = TextureFilterType.getByIndex(_gltfSource.minFilter),
        this.wrapS = TextureWrapType.getByIndex(_gltfSource.wrapS),
        this.wrapT = TextureWrapType.getByIndex(_gltfSource.wrapT),
        super(_gltfSource.name);

  GLTFSampler(this.magFilter, this.minFilter, this.wrapS, this.wrapT,[String name]):super(name);

  factory GLTFSampler.fromGltf(glTF.Sampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFSampler sampler = new GLTFSampler._(gltfSource);
    return sampler;
  }

  @override
  String toString() {
    return 'GLTFSampler{magFilter: $magFilter, minFilter: $minFilter, wrapS: $wrapS, wrapT: $wrapT}';
  }
}