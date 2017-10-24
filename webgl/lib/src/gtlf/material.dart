import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/normal_texture_info.dart';
import 'package:webgl/src/gtlf/occlusion_texture_info.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GLTFMaterial extends GLTFChildOfRootProperty {
  glTF.Material _gltfSource;
  glTF.Material get gltfSource => _gltfSource;

  int materialId;

  // Todo (jpu) : add other material objects
  final GLTFPbrMetallicRoughness pbrMetallicRoughness;
  final GLTFNormalTextureInfo normalTexture;
  final GLTFOcclusionTextureInfo occlusionTexture;
  final GLTFTextureInfo emissiveTexture;

  //>
  final List<double> emissiveFactor;
  final String alphaMode;
  final double alphaCutoff;
  final bool doubleSided;

  GLTFMaterial._(this._gltfSource, [String name])
      : this.pbrMetallicRoughness = new GLTFPbrMetallicRoughness.fromGltf(
      _gltfSource.pbrMetallicRoughness),
        this.normalTexture = _gltfSource.normalTexture != null
            ? new GLTFNormalTextureInfo.fromGltf(_gltfSource.normalTexture)
            : null,
        this.occlusionTexture = _gltfSource.occlusionTexture != null
            ? new GLTFOcclusionTextureInfo.fromGltf(
            _gltfSource.occlusionTexture)
            : null,
        this.emissiveTexture = _gltfSource.emissiveTexture != null
            ? new GLTFTextureInfo.fromGltf(_gltfSource.emissiveTexture)
            : null,
        this.emissiveFactor = _gltfSource.emissiveFactor,
        this.alphaMode = _gltfSource.alphaMode,
        this.alphaCutoff = _gltfSource.alphaCutoff,
        this.doubleSided = _gltfSource.doubleSided,
        super(_gltfSource.name);

  GLTFMaterial(
      this.pbrMetallicRoughness,
      this.normalTexture,
      this.occlusionTexture,
      this.emissiveTexture,
      this.emissiveFactor,
      this.alphaMode,
      this.alphaCutoff,
      this.doubleSided, [String name]):
        super(name);

  factory GLTFMaterial.fromGltf(glTF.Material gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFMaterial._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFMaterial{pbrMetallicRoughness: $pbrMetallicRoughness, normalTexture: $normalTexture, occlusionTexture: $occlusionTexture, emissiveTexture: $emissiveTexture, emissiveFactor: $emissiveFactor, alphaMode: $alphaMode, alphaCutoff: $alphaCutoff, doubleSided: $doubleSided}';
  }
}

abstract class ShaderSourceInterface{
  String getSource(ShaderType shaderType);
}

class DefaultShader extends ShaderSourceInterface{
  static DefaultShader _instance = new DefaultShader._();

  Map<ShaderType, String> _shaderSources = {
    ShaderType.VERTEX_SHADER :
      '''
        attribute vec3 aPosition;
        attribute vec3 aNormal;
  
        uniform mat4 uModelMatrix;
        uniform mat4 uViewMatrix;
        uniform mat4 uProjectionMatrix;
        
        void main(void) {
            vec3 v = aNormal;//not used actually;
            gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aPosition, 1.0);
        }
      ''',
    ShaderType.FRAGMENT_SHADER :
      '''
        void main() {
          gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
        }
      '''
  };

  DefaultShader._();

  factory DefaultShader(){
    return _instance;
  }

  @override
  String getSource(ShaderType shaderType) => _shaderSources[shaderType];
}

class PBRShader extends ShaderSourceInterface{
  static PBRShader _instance = new PBRShader._();

  Map<ShaderType, String> _shaderSources = {
    ShaderType.VERTEX_SHADER :
    '''
        attribute vec3 aPosition;
        attribute vec3 aNormal;
  
        uniform mat4 uModelMatrix;
        uniform mat4 uViewMatrix;
        uniform mat4 uProjectionMatrix;
        
        void main(void) {
            vec3 v = aNormal;//not used actually;
            gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aPosition, 1.0);
        }
    ''',
    ShaderType.FRAGMENT_SHADER :
    '''
        precision mediump float;
        uniform vec4 uColor;
    
        void main() {
          gl_FragColor = uColor;
        }
    '''
  };

  PBRShader._();

  factory PBRShader(){
    return _instance;
  }

  @override
  String getSource(ShaderType shaderType) => _shaderSources[shaderType];
}