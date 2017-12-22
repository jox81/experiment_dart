import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'dart:web_gl' as webgl;

class GLTFTexture extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int textureId = nextId++;

  webgl.Texture webglTexture;

  GLTFSampler _sampler;
  GLTFSampler get sampler => _sampler;
  set sampler(GLTFSampler value) {
    _sampler = value;
  }

  GLTFImage _source;
  GLTFImage get source => _source;
  set source(GLTFImage value) {
    _source = value;
  }

  bool clamp;

  GLTFTexture({GLTFSampler sampler, GLTFImage source, String name : ''}):this._sampler =sampler, this._source = source, super(name);

  @override
  String toString() {
    return 'GLTFTexture{sampler: $sampler, source: $source}';
  }
}