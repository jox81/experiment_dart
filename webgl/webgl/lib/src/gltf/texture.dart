import 'package:webgl/src/gltf/image.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/gltf/sampler.dart';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/introspection/introspection.dart';

@reflector
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

  GLTFTexture({GLTFSampler sampler, GLTFImage source, String name : ''}):this._sampler =sampler, this._source = source, super(name){
    GLTFProject.instance.textures.add(this);
  }

  @override
  String toString() {
    return 'GLTFTexture{sampler: $sampler, source: $source}';
  }
}