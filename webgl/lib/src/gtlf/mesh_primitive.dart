import 'package:collection/collection.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

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
