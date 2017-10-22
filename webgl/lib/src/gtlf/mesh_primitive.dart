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

  Map<String, GLTFAccessor> attributes = new Map<String, GLTFAccessor>();

  final DrawMode mode;

  final bool hasPosition;
  final bool hasNormal;
  final bool hasTangent;

  final int colorCount;
  final int jointsCount;
  final int weigthsCount;
  final int texcoordCount;

  int _indicesAccessorId;
  GLTFAccessor get indices => _indicesAccessorId != null ? gltfProject.accessors[_indicesAccessorId] : null;

  int _materialId;
  int get materialId => _materialId;
  GLTFMaterial get material => _materialId != null ? gltfProject.materials[_materialId] : null;

  // Todo (jpu) : add other members ?
//  int get count => _count;
//  int get vertexCount => _vertexCount;
//  List<Map<String, Accessor>> get targets => _targets;

  GLTFMeshPrimitive._(
      this._gltfSource, )
      : this.mode = _gltfSource.mode != null
            ? DrawMode.getByIndex(_gltfSource.mode)
            : DrawMode.TRIANGLES,
        this.hasPosition = _gltfSource.hasPosition,
        this.hasNormal = _gltfSource.hasNormal,
        this.hasTangent = _gltfSource.hasTangent,
        this.colorCount = _gltfSource.colorCount,
        this.jointsCount = _gltfSource.jointsCount,
        this.weigthsCount = _gltfSource.weigthsCount,
        this.texcoordCount = _gltfSource.texcoordCount;

  factory GLTFMeshPrimitive.fromGltf(glTF.MeshPrimitive gltfSource) {
    if (gltfSource == null) return null;
    GLTFMeshPrimitive meshPrimitive =  new GLTFMeshPrimitive._(gltfSource);

    //attributs
    for (String key in gltfSource.attributes.keys) {
        GLTFAccessor accessor = gltfProject.accessors.firstWhere((a)=>a.gltfSource == gltfSource.attributes[key], orElse: ()=> throw new Exception('Attribut accessor can only be bound to an existing project accessor'));
        meshPrimitive.attributes[key] = accessor;
    }

    //indices
    if(gltfSource.indices != null) {
      GLTFAccessor accessorIndices = gltfProject.accessors.firstWhere((a) =>
      a.gltfSource == gltfSource.indices, orElse: () => throw new Exception(
          'Indices accessor can only be bound to an existing project accessor'));
      assert(accessorIndices.accessorId != null);
      meshPrimitive._indicesAccessorId = accessorIndices.accessorId;
    }

    //material
    if(gltfSource.material != null) {
      GLTFMaterial material = gltfProject.materials.firstWhere((m)=>m.gltfSource == gltfSource.material, orElse: ()=> throw new Exception('Mesh material can only be bound to an existing project material'));
      meshPrimitive._materialId = material.materialId;
    }
    return meshPrimitive;
  }

  @override
  String toString() {
    return 'GLTFMeshPrimitive{attributes: $attributes, mode: $mode, hasPosition: $hasPosition, hasNormal: $hasNormal, hasTangent: $hasTangent, colorCount: $colorCount, jointsCount: $jointsCount, weigthsCount: $weigthsCount, texcoordCount: $texcoordCount, _indices: $_indicesAccessorId, _materialId: $_materialId}';
  }
}
