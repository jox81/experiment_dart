import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'dart:web_gl' as webgl;

class GLTFTexture extends GLTFChildOfRootProperty {
  glTF.Texture _gltfSource;
  glTF.Texture get gltfSource => _gltfSource;

  int textureId;
  webgl.Texture webglTexture;
  int _samplerId;
  GLTFSampler get sampler => _samplerId != null ? gltfProject.samplers[_samplerId] : null;

  int _sourceId;
  GLTFImage get source => _sourceId != null ? gltfProject.images[_sourceId] : null;

  bool clamp;

  GLTFTexture._(this._gltfSource): super(_gltfSource.name);

  GLTFTexture({GLTFSampler sampler, GLTFImage source, String name}):super(name);

  factory GLTFTexture.fromGltf(glTF.Texture gltfSource) {
    if (gltfSource == null) return null;

    //Check if exist in project first
    GLTFTexture texture = gltfProject.textures.firstWhere((t)=>t.gltfSource == gltfSource, orElse: ()=> null);
    if(texture == null) texture = new GLTFTexture._(gltfSource);

    if(gltfSource.sampler != null){
      GLTFSampler sampler = gltfProject.samplers.firstWhere((s)=>s.gltfSource == gltfSource.sampler, orElse: ()=> throw new Exception('Texture Sampler can only be bound to an existing project sampler'));
      texture._samplerId = sampler.samplerId;
    }
    
    if(gltfSource.source != null){
      GLTFImage image = gltfProject.images.firstWhere((i)=>i.gltfSource == gltfSource.source, orElse: ()=> throw new Exception('Texture Image can only be bound to an existing project image'));
      texture._sourceId = image.sourceId;
    }

    return texture;
  }

  @override
  String toString() {
    return 'GLTFTexture{sampler: $sampler, source: $source}';
  }
}