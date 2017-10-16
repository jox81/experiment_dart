import '../camera.dart';
import 'project.dart';
import 'dart:core';
import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:collection/collection.dart';

class GLTFAsset{
  glTF.Asset _gltfSource;
  glTF.Asset get gltfSource => _gltfSource;

  String version;

  GLTFAsset();

  factory GLTFAsset.fromGltf(glTF.Asset gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFAsset()
    ..version = gltfSource.version;
  }
}

abstract class GltfProperty /*extends Stringable*/ {
  Map<String, Object> extensions;
  Object extras;

  GltfProperty();
}

abstract class GLTFChildOfRootProperty extends GltfProperty {
  String name;

  GLTFChildOfRootProperty();
}

/// Buffer defines the raw data.
///
/// [byteLength] defines the length of the bytes used
///
class GLTFBuffer extends GLTFChildOfRootProperty {
  glTF.Buffer _gltfSource;
  glTF.Buffer get gltfSource => _gltfSource;

  Uri uri;
  int byteLength;

  Uint8List data;

  GLTFBuffer._(this._gltfSource)
      : this.uri = _gltfSource.uri,
        this.byteLength = _gltfSource.byteLength,
        this.data = _gltfSource.data;

  factory GLTFBuffer.fromGltf(glTF.Buffer gltfSource) {
    if (gltfSource == null) return null;
    GLTFBuffer buffer = new GLTFBuffer._(gltfSource);
    return buffer;
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

/// Bufferviews define a segment of the buffer data and define broadly what kind of data lives
/// there using some obscure shortcodes for usage/target.
/// A bufferView can take the whole buffer and be a one part only.
///
/// [buffer] defines the buffer to read
/// [byteLength] defines the length of the bytes used
/// [byteOffset] defines the starting byte to read datas
/// [byteStride] defines // Todo (jpu) : ?
///
/// [usage] define the bufferType : ARRAY_BUFFER | ELEMENT_ARRAY_BUFFER
///
class GLTFBufferView extends GLTFChildOfRootProperty {
  glTF.BufferView _gltfSource;
  glTF.BufferView get gltfSource => _gltfSource;

  int get bufferId => null;// Todo (jpu) :
  GLTFBuffer buffer;

  int byteLength;
  int byteOffset;
  int byteStride;

  int target;
  BufferType usage;

  GLTFBufferView._(this._gltfSource)
      : this.byteLength = _gltfSource.byteLength,
        this.byteOffset = _gltfSource.byteOffset,
        this.byteStride = _gltfSource.byteStride,
        this.buffer = new GLTFBuffer.fromGltf(_gltfSource.buffer),
        this.usage = _gltfSource.usage != null ? BufferType.getByIndex(_gltfSource.usage.target):null,
        this.target = _gltfSource.usage != null ? _gltfSource.usage.target: null; // Todo (jpu) : bug if -1 and usage == null. What to do ?

  GLTFBufferView(
      this.buffer,
      this.byteLength,
      this.byteOffset,
      this.byteStride,
      this.target,
      this.usage,
      String name);

  factory GLTFBufferView.fromGltf(glTF.BufferView gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFBufferView._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFBufferView{buffer: $bufferId, byteLength: $byteLength, byteOffset: $byteOffset, byteStride: $byteStride, target: $target, usage: $usage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFBufferView &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          buffer == other.buffer &&
          byteLength == other.byteLength &&
          byteOffset == other.byteOffset &&
          byteStride == other.byteStride &&
          target == other.target &&
          usage == other.usage;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      buffer.hashCode ^
      byteLength.hashCode ^
      byteOffset.hashCode ^
      byteStride.hashCode ^
      target.hashCode ^
      usage.hashCode;
}

class GLTFImage extends GLTFChildOfRootProperty {
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

  factory GLTFImage.fromGltf(glTF.Image gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFImage._(gltfSource);
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

class GLTFSampler extends GLTFChildOfRootProperty {
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

  factory GLTFSampler.fromGltf(glTF.Sampler gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFSampler._(
        gltfSource);
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

class GLTFMaterial extends GLTFChildOfRootProperty {
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

  factory GLTFMaterial.fromGltf(glTF.Material gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFMaterial._(gltfSource);
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

class GLTFPbrMetallicRoughness extends GltfProperty {
  glTF.PbrMetallicRoughness _gltfSource;
  glTF.PbrMetallicRoughness get gltfSource => _gltfSource;

  final List<double> baseColorFactor;
  final GLTFTextureInfo baseColorTexture; // Todo (jpu) : Convert to linear flow

  final double metallicFactor;
  final double roughnessFactor;
  final GLTFTextureInfo
      metallicRoughnessTexture; // Todo (jpu) : Convert to linear flow

  GLTFPbrMetallicRoughness._(this._gltfSource)
      : this.baseColorFactor = _gltfSource.baseColorFactor,
        this.baseColorTexture =
            new GLTFTextureInfo.fromGltf(_gltfSource.baseColorTexture),
        this.metallicFactor = _gltfSource.metallicFactor,
        this.roughnessFactor = _gltfSource.roughnessFactor,
        this.metallicRoughnessTexture =
            new GLTFTextureInfo.fromGltf(_gltfSource.metallicRoughnessTexture);

  GLTFPbrMetallicRoughness(
      this.baseColorFactor,
      this.baseColorTexture,
      this.metallicFactor,
      this.roughnessFactor,
      this.metallicRoughnessTexture);

  factory GLTFPbrMetallicRoughness.fromGltf(
      glTF.PbrMetallicRoughness gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFPbrMetallicRoughness._(gltfSource);
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
  glTF.NormalTextureInfo get gltfSource =>
      _gltfSource as glTF.NormalTextureInfo;

  final double scale;

  GLTFNormalTextureInfo(int texCoord, GLTFTexture texture, this.scale):super(texCoord, texture);
  
  GLTFNormalTextureInfo.fromGltf(glTF.NormalTextureInfo gltfSource)
      : this.scale = gltfSource.scale,
        super.fromGltf(gltfSource);

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
  glTF.OcclusionTextureInfo get gltfSource =>
      _gltfSource as glTF.OcclusionTextureInfo;

  double strength;

  GLTFOcclusionTextureInfo(int texCoord, GLTFTexture texture, this.strength):super(texCoord, texture);

  GLTFOcclusionTextureInfo.fromGltf(glTF.OcclusionTextureInfo gltfSource)
      : this.strength = gltfSource.strength,
        super.fromGltf(gltfSource);

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

class GLTFTextureInfo extends GltfProperty {
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
  int get hashCode =>
      _gltfSource.hashCode ^ texCoord.hashCode ^ texture.hashCode;
}

/// The accessors are what actually define the format of the data and
/// use codes for "componentType"
/// https://github.com/KhronosGroup/glTF/tree/master/specification/2.0#accessors
///
/// [componentType]
/// ex:
/// > 5123 is an unsigned short (2 bytes)
/// > 5126 is single precision float (4 bytes)
/// [type] defines whether they should be read singly ("SCALAR") or in vector groups (e.g. "VEC3")
///
class GLTFAccessor extends GLTFChildOfRootProperty {
  glTF.Accessor _gltfSource;
  glTF.Accessor get gltfSource => _gltfSource;

  int get accessorId => null;// Todo (jpu) :

  final int byteOffset;
  final ShaderVariableType componentType;
  final String typeString;
  final ShaderVariableType type;
  final int count;
  final bool normalized;
  final List<num> max;
  final List<num> min;
  final GLTFAccessorSparse sparse;

  // Todo (jpu) :
  GLTFBufferView get bufferView => gltfProject.bufferViews[0];
  int get components => _gltfSource.components;
  int get componentLength => _gltfSource.componentLength;
  int get elementLength => _gltfSource.elementLength;
  int get byteStride => _gltfSource.byteStride;
  int get byteLength => _gltfSource.byteLength;
  bool get isUnit => _gltfSource.isUnit;
  bool get isXyzSign => _gltfSource.isXyzSign;

  GLTFAccessor._(this._gltfSource)
      : this.byteOffset = _gltfSource.byteOffset,
        this.componentType =
            ShaderVariableType.getByIndex(_gltfSource.componentType),
        this.count = _gltfSource.count,
        this.typeString = _gltfSource.type,
        this.type = ShaderVariableType.getByComponentAndType(
            ShaderVariableType.getByIndex(_gltfSource.componentType).name,
            _gltfSource.type),
        this.normalized = _gltfSource.normalized,
        this.max = _gltfSource.max,
        this.min = _gltfSource.min,
        this.sparse = _gltfSource.sparse != null
            ? new GLTFAccessorSparse.fromGltf(_gltfSource.sparse)
            : null;

  GLTFAccessor(
      this.byteOffset,
      this.componentType,
      this.typeString,
      this.type,
      this.count,
      this.normalized,
      this.max,
      this.min,
      this.sparse);

  factory GLTFAccessor.fromGltf(glTF.Accessor gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFAccessor._(gltfSource);
  }



  @override
  String toString() {
    return 'GLTFAccessor{byteOffset: $byteOffset, componentType: $componentType, typeString: $typeString, , type: $type, count: $count, normalized: $normalized, max: $max, min: $min, sparse: $sparse}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFAccessor &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          byteOffset == other.byteOffset &&
          componentType == other.componentType &&
          typeString == other.typeString &&
          type == other.type &&
          count == other.count &&
          normalized == other.normalized &&
          max == other.max &&
          min == other.min &&
          sparse == other.sparse;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      byteOffset.hashCode ^
      componentType.hashCode ^
      typeString.hashCode ^
      type.hashCode ^
      count.hashCode ^
      normalized.hashCode ^
      max.hashCode ^
      min.hashCode ^
      sparse.hashCode;
}

class GLTFAccessorSparse extends GltfProperty {
  glTF.AccessorSparse _gltfSource;
  glTF.AccessorSparse get gltfSource => _gltfSource;

  final int count;
  final GLTFAccessorSparseIndices indices;
  final GLTFAccessorSparseValues values;

  GLTFAccessorSparse(this.count, this.indices, this.values);

  GLTFAccessorSparse.fromGltf(
      this._gltfSource, )
      : this.count = _gltfSource.count,
        this.indices = new GLTFAccessorSparseIndices.fromGltf(
            _gltfSource.indices),
        this.values = new GLTFAccessorSparseValues.fromGltf(_gltfSource.values);

  @override
  String toString() {
    return 'GLTFAccessorSparse{count: $count, indices: $indices, values: $values}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFAccessorSparse &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          count == other.count &&
          indices == other.indices &&
          values == other.values;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      count.hashCode ^
      indices.hashCode ^
      values.hashCode;
}

class GLTFAccessorSparseIndices extends GltfProperty {
  glTF.AccessorSparseIndices _gltfSource;
  glTF.AccessorSparseIndices get gltfSource => _gltfSource;

  final int byteOffset;
  final ShaderVariableType componentType;

  GLTFAccessorSparseIndices(this.byteOffset, this.componentType);

  GLTFAccessorSparseIndices.fromGltf(
      this._gltfSource, )
      : this.byteOffset = _gltfSource.byteOffset,
        this.componentType =
            ShaderVariableType.getByIndex(_gltfSource.componentType);

  @override
  String toString() {
    return 'GLTFAccessorSparseIndices{byteOffset: $byteOffset, componentType: $componentType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFAccessorSparseIndices &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          byteOffset == other.byteOffset &&
          componentType == other.componentType;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^ byteOffset.hashCode ^ componentType.hashCode;
}

class GLTFAccessorSparseValues extends GltfProperty {
  glTF.AccessorSparseValues _gltfSource;
  glTF.AccessorSparseValues get gltfSource => _gltfSource;

  final int byteOffset;
  final GLTFBufferView bufferView;

  GLTFAccessorSparseValues(this.byteOffset, this.bufferView);

  GLTFAccessorSparseValues.fromGltf(
      this._gltfSource, )
      : this.byteOffset = _gltfSource.byteOffset,
        this.bufferView = new GLTFBufferView.fromGltf(_gltfSource.bufferView);

  @override
  String toString() {
    return 'GLTFAccessorSparseValues{byteOffset: $byteOffset, bufferView: $bufferView}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFAccessorSparseValues &&
          runtimeType == other.runtimeType &&
          byteOffset == other.byteOffset &&
          bufferView == other.bufferView;

  @override
  int get hashCode => byteOffset.hashCode ^ bufferView.hashCode;
}

class GLTFMesh extends GLTFChildOfRootProperty {
  glTF.Mesh _gltfSource;
  glTF.Mesh get gltfSource => _gltfSource;

  int get meshId => null;// Todo (jpu) :

  final List<GLTFMeshPrimitive> primitives;
  final List<double> weights;

  GLTFMesh._(glTF.Mesh _gltfSource)
      : this.primitives = _gltfSource.primitives
            .map((p) => new GLTFMeshPrimitive.fromGltf(p))
            .toList(),
        this.weights = _gltfSource.weights != null
            ? (<double>[]..addAll(_gltfSource.weights))
            : <double>[];

  factory GLTFMesh.fromGltf(glTF.Mesh gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFMesh._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFMesh{primitives: $primitives, weights: $weights}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GLTFMesh &&
          runtimeType == other.runtimeType &&
          _gltfSource == other._gltfSource &&
          const ListEquality<GLTFMeshPrimitive>().equals(primitives, other.primitives) &&
          const ListEquality<double>().equals(weights, other.weights);

  @override
  int get hashCode =>
      _gltfSource.hashCode ^ primitives.hashCode ^ weights.hashCode;
}

/// Represent a part of a mesh
/// [attributs] associate an Accessor by vertex attribute usage : POSITION | NORMAL | TANGENT | TEXCOORD_ | COLOR_ | JOINTS_ | WEIGHTS_
/// in gltf file the accessor is define by its Id
class GLTFMeshPrimitive extends GltfProperty {
  glTF.MeshPrimitive _gltfSource;
  glTF.MeshPrimitive get gltfSource => _gltfSource;

  final Map<String, GLTFAccessor> attributes;

  final DrawMode mode;

  final bool hasPosition;
  final bool hasNormal;
  final bool hasTangent;

  final int colorCount;
  final int jointsCount;
  final int weigthsCount;
  final int texcoordCount;

  GLTFAccessor _indices;
  GLTFAccessor get indices => _indices;
//  Accessor get indices => _indices;

  int _materialId;
  int get materialId => _materialId;
  GLTFMaterial get material => gltfProject.materials[_materialId];// Todo (jpu) : ?

  // Todo (jpu) : add other members ?
//  int get count => _count;
//  int get vertexCount => _vertexCount;
//  List<Map<String, Accessor>> get targets => _targets;

  GLTFMeshPrimitive._(
      this._gltfSource, )
      : this.attributes = new Map.fromIterables(
            _gltfSource.attributes.keys,
            _gltfSource.attributes.values
                .map((v) => new GLTFAccessor.fromGltf(v))),
        this.mode = _gltfSource.mode != null
            ? DrawMode.getByIndex(_gltfSource.mode)
            : DrawMode.TRIANGLES,
        this.hasPosition = _gltfSource.hasPosition,
        this.hasNormal = _gltfSource.hasNormal,
        this.hasTangent = _gltfSource.hasTangent,
        this.colorCount = _gltfSource.colorCount,
        this.jointsCount = _gltfSource.jointsCount,
        this.weigthsCount = _gltfSource.weigthsCount,
        this.texcoordCount = _gltfSource.texcoordCount,
        this._indices = new GLTFAccessor.fromGltf(_gltfSource.indices);// Todo (jpu) :

  factory GLTFMeshPrimitive.fromGltf(glTF.MeshPrimitive gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFMeshPrimitive._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFMeshPrimitive{attributes: $attributes, mode: $mode, hasPosition: $hasPosition, hasNormal: $hasNormal, hasTangent: $hasTangent, colorCount: $colorCount, jointsCount: $jointsCount, weigthsCount: $weigthsCount, texcoordCount: $texcoordCount, _indices: $_indices, _materialId: $_materialId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFMeshPrimitive &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              const MapEquality<String, GLTFAccessor>().equals(attributes, other.attributes) &&
              mode == other.mode &&
              hasPosition == other.hasPosition &&
              hasNormal == other.hasNormal &&
              hasTangent == other.hasTangent &&
              colorCount == other.colorCount &&
              jointsCount == other.jointsCount &&
              weigthsCount == other.weigthsCount &&
              texcoordCount == other.texcoordCount &&
              _indices == other._indices &&
              _materialId == other._materialId;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      attributes.hashCode ^
      mode.hashCode ^
      hasPosition.hashCode ^
      hasNormal.hashCode ^
      hasTangent.hashCode ^
      colorCount.hashCode ^
      jointsCount.hashCode ^
      weigthsCount.hashCode ^
      texcoordCount.hashCode ^
      _indices.hashCode ^
      _materialId.hashCode;




}

class GLTFScene extends GLTFChildOfRootProperty {
  glTF.Scene _gltfSource;
  glTF.Scene get gltfSource => _gltfSource;

  int sceneId;

  final List<int> _nodesId = new List();
  List<GLTFNode> get nodes => gltfProject.nodes.where((n)=>_nodesId.contains(n.nodeId)).toList(growable: false);
  void addNode(GLTFNode node){
    assert(node != null);
    _nodesId.add(node.nodeId);
  }

  GLTFScene._(this._gltfSource);

  GLTFScene();

  factory GLTFScene.fromGltf(glTF.Scene gltfSource) {
    if (gltfSource == null) return null;
    GLTFScene scene = new GLTFScene._(gltfSource);
    for(glTF.Node node in gltfSource.nodes){
      GLTFNode gltfNode = new GLTFNode.fromGltf(node);

      int nodeId = gltfProject.nodes.indexOf(gltfNode);
      if(nodeId == -1){
        gltfProject.addNode(gltfNode);
      }else{
        gltfNode.nodeId = nodeId;
      }
      scene.addNode(gltfNode);
    }
    return scene;
  }

  @override
  String toString() {
    return 'GLTFScene{nodes: $_nodesId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFScene &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              nodes == other.nodes;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      nodes.hashCode;
}

class GLTFNode extends GLTFChildOfRootProperty{
  glTF.Node _gltfSource;
  glTF.Node get gltfSource => _gltfSource;
  int nodeId;

  Matrix4 _matrix = new Matrix4.identity();
  Matrix4 get matrix => _matrix..setFromTranslationRotationScale(translation, rotation, scale);
  set matrix(Matrix4 value) {
    _matrix = value;
    translation = _matrix.getTranslation();
    rotation = new Quaternion.fromRotation(_matrix.getRotation());
    scale = new Vector3(_matrix.getColumn(0).length, _matrix.getColumn(1).length, _matrix.getColumn(2).length);
  }

  Vector3 translation = new Vector3.all(0.0);
  Quaternion rotation = new Quaternion.identity();
  Vector3 scale = new Vector3.all(1.0);

  List<double> weights;

  Camera camera;
  GLTFMesh mesh;
  GLTFSkin skin;
  List<GLTFNode> get children => gltfProject.nodes.toList().where((n)=>n.parent == this).toList(growable: false);

  int _parentId;
  set parent(GLTFNode value) {
    _parentId = gltfProject.nodes.indexOf(value);
  }
  GLTFNode get parent => _parentId != null ? gltfProject.nodes[_parentId] : null;

  bool isJoint = false;

  GLTFNode._(this._gltfSource) :
        this.camera = Camera.fromGltf(_gltfSource.camera),
        this._parentId = _getParentId(_gltfSource),
        this.mesh = new GLTFMesh.fromGltf(_gltfSource.mesh);

  static int _getParentId(glTF.Node _gltfSource){

    int parentId;

    //Cherche si il existe un node
    glTF.Node node = (gltfProject.gltfSource.nodes.firstWhere((n)=>n == _gltfSource, orElse: ()=>null));
    if(node != null) {
      parentId = gltfProject.gltfSource.nodes.indexOf(node.parent);
      parentId = parentId != -1 ? parentId : null;
    }
    return parentId;
  }

  GLTFNode();

  factory GLTFNode.fromGltf(glTF.Node gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFNode._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFNode{nodeId: $nodeId, matrix: $matrix, translation: $translation, rotation: $rotation, scale: $scale, weights: $weights, camera: $camera, children: ${children.map((n)=>n.nodeId).toList()}, mesh: $mesh, parent: $_parentId, skin: $skin, isJoint: $isJoint}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFNode &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              _matrix == other._matrix &&
              translation == other.translation &&
              rotation.toString() == other.rotation.toString() &&
              scale == other.scale &&
              weights == other.weights &&
              camera == other.camera &&
              mesh == other.mesh &&
              skin == other.skin &&
              _parentId == other._parentId &&
              isJoint == other.isJoint;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      nodeId.hashCode ^
      _matrix.hashCode ^
      translation.hashCode ^
      rotation.hashCode ^
      scale.hashCode ^
      weights.hashCode ^
      camera.hashCode ^
      mesh.hashCode ^
      skin.hashCode ^
      _parentId.hashCode ^
      isJoint.hashCode;



}

//>
// Todo (jpu) :

class GLTFSkin extends GLTFChildOfRootProperty{
  GLTFSkin();
}

//>
//
//class UniqueList<T> extends ListBase<T> {
//  LinkedHashSet<T> _list;
//  List<T> _listTemp;
//
//  int _length = 0;
//
//  UniqueList() {
//      _list = new LinkedHashSet<T>.identity();
//  }
//
//  @override
//  T operator [](int index) =>
//      (index == null || index < 0 || index >= _list.length)
//          ? null
//          : _list.toList()[index];
//
//  @override
//  void operator []=(int index, T value) {
//    assert(value != null);
//    assert(index >= 0 && index < length);
//    _list[index] = value;
//  }
//
//  @override
//  int get length => _length;
//
//  @override
//  set length(int newLength) {
//    _length = newLength;
//  }
//
//  @override
//  String toString() => _list.toString();
//}