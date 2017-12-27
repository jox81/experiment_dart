import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/renderer/kronos_material.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

/// Represent a part of a mesh
/// [attributs] associate an Accessor by vertex attribute usage : POSITION | NORMAL | TANGENT | TEXCOORD_ | COLOR_ | JOINTS_ | WEIGHTS_
/// in gltf file the accessor is define by its Id
class GLTFMeshPrimitive extends GltfProperty {
  Map<String, GLTFAccessor> attributes = new Map<String, GLTFAccessor>();
  Map<String, webgl.Buffer> buffers = new Map();

  /// DrawMode mode
  int mode;

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

  GLTFPBRMaterial _baseMaterial;
  GLTFPBRMaterial get baseMaterial => _baseMaterial;
  set baseMaterial(GLTFPBRMaterial value) {
    _baseMaterial = value;
  }

  KronosRawMaterial _material;
  KronosRawMaterial get material => _material;

  WebGLProgram program;

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

  void bindMaterial(bool hasLODExtension, int reservedTextureUnits) {
    bool debug = false;
    bool debugWithDebugMaterial = true;

    _material;

    if(baseMaterial == null || debug){
      if(debugWithDebugMaterial){
        _material = new KronosDebugMaterial()
          ..color = new Vector3.random();
      } else {
        _material = new KronosDefaultMaterial();
      }
    } else {
      _material = new KronosPRBMaterial(attributes['NORMAL'] != null, attributes['TANGENT'] != null, attributes['TEXCOORD_0'] != null, hasLODExtension);
      KronosPRBMaterial materialPBR = _material as KronosPRBMaterial;

      materialPBR.baseColorMap = baseMaterial.pbrMetallicRoughness.baseColorTexture?.texture?.webglTexture;
      if (materialPBR.hasBaseColorMap) {
        materialPBR.baseColorSamplerSlot = baseMaterial.pbrMetallicRoughness.baseColorTexture.texture.textureId + reservedTextureUnits;
      }
      materialPBR.baseColorFactor = baseMaterial.pbrMetallicRoughness.baseColorFactor;

      materialPBR.normalMap = baseMaterial.normalTexture?.texture?.webglTexture;
      if(materialPBR.hasNormalMap) {
        materialPBR.normalSamplerSlot =
            baseMaterial.normalTexture.texture.textureId + reservedTextureUnits;
        materialPBR.normalScale = baseMaterial.normalTexture.scale != null
            ? baseMaterial.normalTexture.scale
            : 1.0;
      }

      materialPBR.emissiveMap = baseMaterial.emissiveTexture?.texture?.webglTexture;
      if(materialPBR.hasEmissiveMap) {
        materialPBR.emissiveSamplerSlot =
            baseMaterial.emissiveTexture.texture.textureId + reservedTextureUnits;
        materialPBR.emissiveFactor = baseMaterial.emissiveFactor;
      }

      materialPBR.occlusionMap = baseMaterial.occlusionTexture?.texture?.webglTexture;
      if(materialPBR.hasOcclusionMap) {
        materialPBR.occlusionSamplerSlot =
            baseMaterial.occlusionTexture.texture.textureId + reservedTextureUnits;
        materialPBR.occlusionStrength = baseMaterial.occlusionTexture.strength != null
            ? baseMaterial.occlusionTexture.strength
            : 1.0;
      }

      materialPBR.metallicRoughnessMap = baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture?.texture?.webglTexture;
      if(materialPBR.hasMetallicRoughnessMap) {
        materialPBR.metallicRoughnessSamplerSlot =
            baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture.texture
                .textureId + reservedTextureUnits;
      }

      materialPBR.roughness = baseMaterial.pbrMetallicRoughness.roughnessFactor;
      materialPBR.metallic = baseMaterial.pbrMetallicRoughness.metallicFactor;
    }

    program = _material.getProgram();
  }

  @override
  String toString() {
    return 'GLTFMeshPrimitive{attributes: $attributes, mode: $mode, hasPosition: $hasPosition, hasNormal: $hasNormal, hasTangent: $hasTangent, colorCount: $colorCount, jointsCount: $jointsCount, weigthsCount: $weigthsCount, texcoordCount: $texcoordCount, _indices: ${_indicesAccessor?.accessorId}, _materialId: ${_baseMaterial?.materialId}}';
  }
}
