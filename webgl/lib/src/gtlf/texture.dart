import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFTexture extends GLTFChildOfRootProperty {
  glTF.Texture _gltfSource;
  glTF.Texture get gltfSource => _gltfSource;

  final GLTFSampler sampler;
  final GLTFImage source;

  GLTFTexture._(this._gltfSource)
      : this.sampler = new GLTFSampler.fromGltf(_gltfSource.sampler),
        this.source = new GLTFImage.fromGltf(_gltfSource.source);

  GLTFTexture(this.sampler, this.source);

  factory GLTFTexture.fromGltf(glTF.Texture gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFTexture._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFTexture{sampler: $sampler, source: $source}';
  }
}