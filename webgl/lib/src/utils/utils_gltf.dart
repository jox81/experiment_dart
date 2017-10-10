import '../camera.dart';
import '../webgl_objects/datas/webgl_enum.dart';
import 'dart:core';
import 'dart:async';
import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import '../utils/utils_assets.dart';

// Todo (jpu) : extensions
// Todo (jpu) : extras
// Todo (jpu) : Remplacer la copie complete des donnée par un design de Facade ? (utiliser des getter utilisant la source)?
// Todo (jpu) : Ajouter des méthodes de Link reférénce ?
// Todo (jpu) : UNPACK_COLORSPACE_CONVERSION_WEBGL flag to NONE to ignore colorSpace globaly in runtime
class GLTFObject {
  static Future<glTF.Gltf> loadGLTFResource(String url,
      {bool useWebPath: true}) async {
    UtilsAssets.useWebPath = useWebPath;

    Completer completer = new Completer<glTF.Gltf>();
    await UtilsAssets.loadJSONResource(url).then((Map<String, dynamic> result) {
      try {
        glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
        completer.complete(gltf);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future as Future<glTF.Gltf>;
  }

  glTF.Gltf _gltfSource;
  glTF.Gltf get gltfSource => _gltfSource;

  List<GLTFBuffer> buffers = new List();
  List<GLTFBufferView> bufferViews = new List();
  List<Camera> cameras = new List();
  List<GLTFImage> images = new List();
  List<GLTFSampler> samplers = new List();
  List<GLTFTexture> textures = new List();
  List<GLTFMaterial> materials = new List();

  GLTFObject._(this._gltfSource) {
    //Buffers
    for (glTF.Buffer gltfBuffer in _gltfSource.buffers) {
      GLTFBuffer buffer = new GLTFBuffer.fromGltf(gltfBuffer);
      if (buffer != null) {
        buffers.add(buffer);
      }
    }

    //BufferViews
    for (glTF.BufferView gltfBufferView in _gltfSource.bufferViews) {
      GLTFBufferView bufferView = new GLTFBufferView.fromGltf(gltfBufferView);
      if (bufferView != null) {
        bufferView.bufferIndex = buffers.indexOf(bufferView.buffer);
        assert(bufferView.bufferIndex != -1);
        bufferView.buffer = buffers[bufferView.bufferIndex];
        bufferViews.add(bufferView);
      }
    }

    //Cameras
    for (glTF.Camera gltfCamera in _gltfSource.cameras) {
      Camera camera = Camera.fromGltf(gltfCamera);
      if (camera != null) {
        cameras.add(camera);
      }
    }

    //Images
    for (glTF.Image gltfImage in _gltfSource.images) {
      GLTFImage image = new GLTFImage.fromGltf(gltfImage);
      if (image != null) {
        images.add(image);
      }
    }

    //Samplers
    for (glTF.Sampler gltfSampler in _gltfSource.samplers) {
      GLTFSampler sampler = new GLTFSampler.fromGltf(gltfSampler);
      if (sampler != null) {
        samplers.add(sampler);
      }
    }

    //Textures
    for (glTF.Texture gltfTexture in _gltfSource.textures) {
      GLTFTexture texture = new GLTFTexture.fromGltf(gltfTexture);
      if (texture != null) {
        textures.add(texture);
      }
    }

    //Materials
    for (glTF.Material gltfMaterial in _gltfSource.materials) {
      GLTFMaterial material = new GLTFMaterial.fromGltf(gltfMaterial);
      if (material != null) {
        materials.add(material);
      }
    }
  }

  GLTFObject();

  factory GLTFObject.fromGltf(glTF.Gltf gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFObject._(gltfSource);
  }
}

abstract class GltfProperty /*extends Stringable*/ {
  Map<String, Object> extensions;
  Object extras;
}

// Todo (jpu) : add other child extends
abstract class GLTFChild extends GltfProperty {
  String name;
}

class GLTFBuffer extends GLTFChild {
  glTF.Buffer _gltfSource;
  glTF.Buffer get gltfSource => _gltfSource;

  Uri uri;
  int byteLength;

  Uint8List data;

  GLTFBuffer._(this._gltfSource)
      : this.uri = _gltfSource.uri,
        this.byteLength = _gltfSource.byteLength,
        this.data = _gltfSource.data;

  factory GLTFBuffer.fromGltf(glTF.Buffer gltfBufferSource) {
    if (gltfBufferSource == null) return null;
    return new GLTFBuffer._(gltfBufferSource);
  }

  @override
  String toString() {
    return 'GLTFBuffer{uri: $uri, byteLength: $byteLength, data: $data}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFBuffer &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          uri == other.uri &&
          byteLength == other.byteLength &&
          data == other.data;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^ uri.hashCode ^ byteLength.hashCode ^ data.hashCode;
}

class GLTFBufferView extends GLTFChild{
  glTF.BufferView _gltfSource;
  glTF.BufferView get gltfSource => _gltfSource;

  GLTFBuffer buffer;
  int bufferIndex;
  int byteLength;
  int byteOffset;
  int byteStride;
  int target;
  BufferType bufferType;

  GLTFBufferView._(this._gltfSource)
      : this.byteLength = _gltfSource.byteLength,
        this.byteOffset = _gltfSource.byteOffset,
        this.byteStride = _gltfSource.byteStride,
        this.buffer = new GLTFBuffer.fromGltf(_gltfSource.buffer),
        this.target = _gltfSource.target,
        this.bufferType = BufferType.getByIndex(_gltfSource.target);

  GLTFBufferView(this.buffer, this.bufferIndex, this.byteLength,
      this.byteOffset, this.byteStride, this.target, this.bufferType);

  factory GLTFBufferView.fromGltf(glTF.BufferView gltfBufferViewSource) {
    if (gltfBufferViewSource == null || gltfBufferViewSource.usage == null)
      return null;
    GLTFBufferView bufferView = new GLTFBufferView._(gltfBufferViewSource);
    return bufferView;
  }

  @override
  String toString() {
    return 'GLTFBufferView{buffer: $buffer, bufferIndex: $bufferIndex, byteLength: $byteLength, byteOffset: $byteOffset, byteStride: $byteStride, target: $target, bufferType: $bufferType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFBufferView &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          buffer == other.buffer &&
          bufferIndex == other.bufferIndex &&
          byteLength == other.byteLength &&
          byteOffset == other.byteOffset &&
          byteStride == other.byteStride &&
          target == other.target &&
          bufferType == other.bufferType;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      buffer.hashCode ^
      bufferIndex.hashCode ^
      byteLength.hashCode ^
      byteOffset.hashCode ^
      byteStride.hashCode ^
      target.hashCode ^
      bufferType.hashCode;
}

class GLTFImage extends GLTFChild{
  glTF.Image _gltfSource;
  glTF.Image get gltfSource => _gltfSource;

  Uri uri;
  String mimeType;
  GLTFBufferView bufferView;
  Uint8List data;

  GLTFImage._(this._gltfSource)
      : this.uri = _gltfSource.uri,
        this.mimeType = _gltfSource.mimeType,
        this.bufferView = new GLTFBufferView.fromGltf(_gltfSource.bufferView),
        this.data = _gltfSource.data;

  factory GLTFImage.fromGltf(glTF.Image gltfImageSource) {
    if (gltfImageSource == null) return null;
    return new GLTFImage._(gltfImageSource);
  }

  @override
  String toString() {
    return 'GLTFImage{uri: $uri, mimeType: $mimeType, bufferView: $bufferView, data: $data}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFImage &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          uri == other.uri &&
          mimeType == other.mimeType &&
          bufferView == other.bufferView &&
          data == other.data;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      uri.hashCode ^
      mimeType.hashCode ^
      bufferView.hashCode ^
      data.hashCode;
}

class GLTFSampler extends GLTFChild{
  glTF.Sampler _gltfSource;
  glTF.Sampler get gltfSource => _gltfSource;

  final TextureFilterType magFilter;
  final TextureFilterType minFilter;
  final TextureWrapType wrapS;
  final TextureWrapType wrapT;

  GLTFSampler._(this._gltfSource)
      : this.magFilter = TextureFilterType.getByIndex(_gltfSource.magFilter),
        this.minFilter = TextureFilterType.getByIndex(_gltfSource.minFilter),
        this.wrapS = TextureWrapType.getByIndex(_gltfSource.wrapS),
        this.wrapT = TextureWrapType.getByIndex(_gltfSource.wrapT);

  GLTFSampler(this.magFilter, this.minFilter, this.wrapS, this.wrapT);

  factory GLTFSampler.fromGltf(glTF.Sampler gltfSamplerSource) {
    if (gltfSamplerSource == null) return null;
    return new GLTFSampler._(gltfSamplerSource);
  }

  @override
  String toString() {
    return 'GLTFSampler{magFilter: $magFilter, minFilter: $minFilter, wrapS: $wrapS, wrapT: $wrapT}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFSampler &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          magFilter == other.magFilter &&
          minFilter == other.minFilter &&
          wrapS == other.wrapS &&
          wrapT == other.wrapT;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      magFilter.hashCode ^
      minFilter.hashCode ^
      wrapS.hashCode ^
      wrapT.hashCode;
}

class GLTFTexture extends GLTFChild{
  glTF.Texture _gltfSource;
  glTF.Texture get gltfSource => _gltfSource;

  final GLTFSampler sampler;
  final GLTFImage source;

  GLTFTexture._(this._gltfSource)
      : this.sampler = new GLTFSampler.fromGltf(_gltfSource.sampler),
        this.source = new GLTFImage.fromGltf(_gltfSource.source);

  GLTFTexture(this.sampler, this.source);

  factory GLTFTexture.fromGltf(glTF.Texture gltfTextureSource) {
    if (gltfTextureSource == null) return null;
    return new GLTFTexture._(gltfTextureSource);
  }

  @override
  String toString() {
    return 'GLTFTexture{sampler: $sampler, source: $source}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFTexture &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          sampler == other.sampler &&
          source == other.source;

  @override
  int get hashCode => _gltfSource.hashCode ^ sampler.hashCode ^ source.hashCode;
}

class GLTFMaterial extends GLTFChild{
  glTF.Material _gltfSource;
  glTF.Material get gltfSource => _gltfSource;

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

  GLTFMaterial._(this._gltfSource)
      : this.pbrMetallicRoughness =
            new GLTFPbrMetallicRoughness.fromGltf(_gltfSource.pbrMetallicRoughness),
        this.normalTexture =
            new GLTFNormalTextureInfo.fromGltf(_gltfSource.normalTexture),
        this.occlusionTexture =
            new GLTFOcclusionTextureInfo.fromGltf(_gltfSource.occlusionTexture),
        this.emissiveTexture =
            new GLTFTextureInfo.fromGltf(_gltfSource.emissiveTexture),
        this.emissiveFactor = _gltfSource.emissiveFactor,
        this.alphaMode = _gltfSource.alphaMode,
        this.alphaCutoff = _gltfSource.alphaCutoff,
        this.doubleSided = _gltfSource.doubleSided;

  GLTFMaterial(
      this.pbrMetallicRoughness,
      this.normalTexture,
      this.occlusionTexture,
      this.emissiveTexture,
      this.emissiveFactor,
      this.alphaMode,
      this.alphaCutoff,
      this.doubleSided);

  factory GLTFMaterial.fromGltf(glTF.Material gltfMaterialSource) {
    if (gltfMaterialSource == null) return null;
    return new GLTFMaterial._(gltfMaterialSource);
  }

  @override
  String toString() {
    return 'GLTFMaterial{pbrMetallicRoughness: $pbrMetallicRoughness, normalTexture: $normalTexture, occlusionTexture: $occlusionTexture, emissiveTexture: $emissiveTexture, emissiveFactor: $emissiveFactor, alphaMode: $alphaMode, alphaCutoff: $alphaCutoff, doubleSided: $doubleSided}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFMaterial &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          pbrMetallicRoughness == other.pbrMetallicRoughness &&
          normalTexture == other.normalTexture &&
          occlusionTexture == other.occlusionTexture &&
          emissiveTexture == other.emissiveTexture &&
          emissiveFactor == other.emissiveFactor &&
          alphaMode == other.alphaMode &&
          alphaCutoff == other.alphaCutoff &&
          doubleSided == other.doubleSided;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      pbrMetallicRoughness.hashCode ^
      normalTexture.hashCode ^
      occlusionTexture.hashCode ^
      emissiveTexture.hashCode ^
      emissiveFactor.hashCode ^
      alphaMode.hashCode ^
      alphaCutoff.hashCode ^
      doubleSided.hashCode;
}

class GLTFPbrMetallicRoughness extends GltfProperty{
  glTF.PbrMetallicRoughness _gltfSource;
  glTF.PbrMetallicRoughness get gltfSource => _gltfSource;

  final List<double> baseColorFactor;
  final GLTFTextureInfo baseColorTexture;// Todo (jpu) : Convert to linear flow

  final double metallicFactor;
  final double roughnessFactor;
  final GLTFTextureInfo metallicRoughnessTexture;// Todo (jpu) : Convert to linear flow

  GLTFPbrMetallicRoughness._(this._gltfSource)
      : this.baseColorFactor = _gltfSource.baseColorFactor,
        this.baseColorTexture =
            new GLTFTextureInfo.fromGltf(_gltfSource.baseColorTexture),
        this.metallicFactor = _gltfSource.metallicFactor,
        this.roughnessFactor = _gltfSource.roughnessFactor,
        this.metallicRoughnessTexture =
            new GLTFTextureInfo.fromGltf(_gltfSource.metallicRoughnessTexture);

  GLTFPbrMetallicRoughness(this.baseColorFactor, this.baseColorTexture,
      this.metallicFactor, this.roughnessFactor, this.metallicRoughnessTexture);

  factory GLTFPbrMetallicRoughness.fromGltf(
      glTF.PbrMetallicRoughness pbrMetallicRoughnessSource) {
    if (pbrMetallicRoughnessSource == null) return null;
    return new GLTFPbrMetallicRoughness._(pbrMetallicRoughnessSource);
  }

  @override
  String toString() {
    return 'GLTFPbrMetallicRoughness{baseColorFactor: $baseColorFactor, baseColorTexture: $baseColorTexture, metallicFactor: $metallicFactor, roughnessFactor: $roughnessFactor, metallicRoughnessTexture: $metallicRoughnessTexture}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFPbrMetallicRoughness &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          baseColorFactor == other.baseColorFactor &&
          baseColorTexture == other.baseColorTexture &&
          metallicFactor == other.metallicFactor &&
          roughnessFactor == other.roughnessFactor &&
          metallicRoughnessTexture == other.metallicRoughnessTexture;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      baseColorFactor.hashCode ^
      baseColorTexture.hashCode ^
      metallicFactor.hashCode ^
      roughnessFactor.hashCode ^
      metallicRoughnessTexture.hashCode;
}

class GLTFNormalTextureInfo extends GLTFTextureInfo {
  glTF.NormalTextureInfo get gltfSource => _gltfSource as glTF.NormalTextureInfo;

  final double scale;

  GLTFNormalTextureInfo(int texCoord, GLTFTexture texture, this.scale)
      : super(texCoord, texture);
  GLTFNormalTextureInfo.fromGltf(glTF.NormalTextureInfo normalTextureInfoSource)
      : this.scale = normalTextureInfoSource.scale,
        super.fromGltf(normalTextureInfoSource);


  @override
  String toString() {
    return 'GLTFNormalTextureInfo{scale: $scale} | ${super.toString()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is GLTFNormalTextureInfo &&
          runtimeType == other.runtimeType &&
          scale == other.scale;

  @override
  int get hashCode => super.hashCode ^ scale.hashCode;
}

class GLTFOcclusionTextureInfo extends GLTFTextureInfo {
  glTF.OcclusionTextureInfo get gltfSource => _gltfSource as glTF.OcclusionTextureInfo;

  double strength;

  GLTFOcclusionTextureInfo(int texCoord, GLTFTexture texture, this.strength)
      : super(texCoord, texture);

  GLTFOcclusionTextureInfo.fromGltf(
      glTF.OcclusionTextureInfo occlusionTextureInfoSource)
      : this.strength = occlusionTextureInfoSource.strength,
        super.fromGltf(occlusionTextureInfoSource);

  @override
  String toString() {
    return 'GLTFOcclusionTextureInfo{strength: $strength} | ${super.toString()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is GLTFOcclusionTextureInfo &&
          runtimeType == other.runtimeType &&
          strength == other.strength;

  @override
  int get hashCode => super.hashCode ^ strength.hashCode;
}

class GLTFTextureInfo extends GltfProperty{
  glTF.TextureInfo _gltfSource;
  glTF.TextureInfo get gltfSource => _gltfSource;

  final int texCoord;
  final GLTFTexture texture;

  GLTFTextureInfo(this.texCoord, this.texture);

  GLTFTextureInfo.fromGltf(this._gltfSource)
      : this.texCoord = _gltfSource.texCoord,
        this.texture = new GLTFTexture.fromGltf(_gltfSource.texture);

  @override
  String toString() {
    return 'GLTFTextureInfo{texCoord: $texCoord, texture: $texture}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFTextureInfo &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          texCoord == other.texCoord &&
          texture == other.texture;

  @override
  int get hashCode => _gltfSource.hashCode ^ texCoord.hashCode ^ texture.hashCode;
}

//1.0 ?
//class GLTFTechnique{
//  Map<String, Object> attributs;//<name, parameter>
//  Map<String, Object> uniforms;//<name, parameter>
//  Map parameters;
//}
