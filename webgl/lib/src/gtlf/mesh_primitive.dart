import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

/// Represent a part of a mesh
/// [attributs] associate an Accessor by vertex attribute usage : POSITION | NORMAL | TANGENT | TEXCOORD_ | COLOR_ | JOINTS_ | WEIGHTS_
/// in gltf file the accessor is define by its Id
class GLTFMeshPrimitive extends GltfProperty {
  Map<String, GLTFAccessor> attributes = new Map<String, GLTFAccessor>();

  /// DrawMode mode
  final int mode;

  final bool hasPosition;
  final bool hasNormal;
  final bool hasTangent;

  final int colorCount;
  final int jointsCount;
  final int weigthsCount;
  final int texcoordCount;

  GLTFAccessor _indicesAccessor;
  GLTFAccessor get indices => _indicesAccessor;
  set indicesAccessor(GLTFAccessor value) {
    _indicesAccessor = value;
  }

  GLTFPBRMaterial _material;
  GLTFPBRMaterial get material => _material;
  set material(GLTFPBRMaterial value) {
    _material = value;
  }

  // Todo (jpu) : add other members ?
//  int get count => _count;
//  int get vertexCount => _vertexCount;
//  List<Map<String, Accessor>> get targets => _targets;

  GLTFMeshPrimitive(
      {this.mode,
      this.hasPosition,
      this.hasNormal,
      this.hasTangent,
      this.colorCount,
      this.jointsCount,
      this.weigthsCount,
      this.texcoordCount});

  @override
  String toString() {
    return 'GLTFMeshPrimitive{attributes: $attributes, mode: $mode, hasPosition: $hasPosition, hasNormal: $hasNormal, hasTangent: $hasTangent, colorCount: $colorCount, jointsCount: $jointsCount, weigthsCount: $weigthsCount, texcoordCount: $texcoordCount, _indices: ${_indicesAccessor.accessorId}, _materialId: ${_material.materialId}}';
  }
}
