import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'dart:web_gl' as webgl;

class GLTFTexture extends GLTFChildOfRootProperty {
  static int nextId = 0;

  glTF.Texture _gltfSource;
  glTF.Texture get gltfSource => _gltfSource;

  final int textureId = nextId++;
  webgl.Texture webglTexture;

  GLTFSampler _sampler;
  GLTFSampler get sampler => _sampler;

  GLTFImage _source;
  GLTFImage get source => _source;

  bool clamp;

  GLTFTexture({GLTFSampler sampler, GLTFImage source, String name : ''}):this._sampler =sampler, this._source = source, super(name);

  factory GLTFTexture.fromGltf(glTF.Texture gltfSource) {
    if (gltfSource == null) return null;

    GLTFSampler sampler;
    if(gltfSource.sampler != null){
      sampler = gltfProject.samplers.firstWhere((s)=>s.gltfSource == gltfSource.sampler, orElse: ()=> throw new Exception('Texture Sampler can only be bound to an existing project sampler'));
    }

    GLTFImage image;
    if(gltfSource.source != null){
      image = gltfProject.images.firstWhere((i)=>i.gltfSource == gltfSource.source, orElse: ()=> throw new Exception('Texture Image can only be bound to an existing project image'));
    }

    //Check if exist in project first
    GLTFTexture texture = gltfProject.textures.firstWhere((t)=>t.gltfSource == gltfSource, orElse: ()=> null);
    if(texture == null) {
      texture = new GLTFTexture(
        sampler : sampler,
        source : image,
        name: gltfSource.name
      );
      texture._gltfSource = gltfSource;
    }else {
      texture._sampler = sampler;
      texture._source = image;
    }
    return texture;
  }

  @override
  String toString() {
    return 'GLTFTexture{sampler: $sampler, source: $source}';
  }
}