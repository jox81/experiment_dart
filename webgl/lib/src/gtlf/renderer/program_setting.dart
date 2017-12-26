import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/utils/utils_debug.dart' as debug;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

import 'package:webgl/src/gtlf/renderer/kronos_material.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';

import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';

class ProgramSetting{

  final GLTFMesh _mesh;

  KronosRawMaterial material;
  List<WebGLProgram> programs = new List();
  Map<String, webgl.Buffer> buffers = new Map();

  Matrix4 modelMatrix;// => (_node.parentMatrix * _node.matrix) as Matrix4;
  Matrix4 get _viewMatrix => mainCamera.viewMatrix;
  Matrix4 get _projectionMatrix => mainCamera.projectionMatrix;

  ProgramSetting(this._mesh){
    //debug.logCurrentFunction();

    for (int i = 0; i < _mesh.primitives.length; i++) {
      GLTFMeshPrimitive primitive = _mesh.primitives[i];

      bool debug = false;
      bool debugWithDebugMaterial = true;
      if(primitive.material == null || debug){
        if(debugWithDebugMaterial){
          material = new KronosDebugMaterial()
            ..color = new Vector3.random();
        } else {
          material = new KronosDefaultMaterial();
        }
      } else {
        material = new KronosPRBMaterial(skipTexture, globalState, primitive.attributes['NORMAL'] != null, primitive.attributes['TANGENT'] != null, primitive.attributes['TEXCOORD_0'] != null);
        KronosPRBMaterial materialPBR = material as KronosPRBMaterial;

        GLTFPBRMaterial baseMaterial = primitive.material;

        materialPBR.baseColorMap = baseMaterial.pbrMetallicRoughness.baseColorTexture?.texture?.webglTexture;
        if (materialPBR.hasBaseColorMap) {
          materialPBR.baseColorSamplerSlot = baseMaterial.pbrMetallicRoughness.baseColorTexture.texture.textureId + skipTexture;
        }
        materialPBR.baseColorFactor = baseMaterial.pbrMetallicRoughness.baseColorFactor;

        materialPBR.normalMap = baseMaterial.normalTexture?.texture?.webglTexture;
        if(materialPBR.hasNormalMap) {
          materialPBR.normalSamplerSlot =
              baseMaterial.normalTexture.texture.textureId + skipTexture;
          materialPBR.normalScale = baseMaterial.normalTexture.scale != null
              ? baseMaterial.normalTexture.scale
              : 1.0;
        }

        materialPBR.emissiveMap = baseMaterial.emissiveTexture?.texture?.webglTexture;
        if(materialPBR.hasEmissiveMap) {
          materialPBR.emissiveSamplerSlot =
              baseMaterial.emissiveTexture.texture.textureId + skipTexture;
          materialPBR.emissiveFactor = baseMaterial.emissiveFactor;
        }

        materialPBR.occlusionMap = baseMaterial.occlusionTexture?.texture?.webglTexture;
        if(materialPBR.hasOcclusionMap) {
          materialPBR.occlusionSamplerSlot =
              baseMaterial.occlusionTexture.texture.textureId + skipTexture;
          materialPBR.occlusionStrength = baseMaterial.occlusionTexture.strength != null
              ? baseMaterial.occlusionTexture.strength
              : 1.0;
        }

        materialPBR.metallicRoughnessMap = baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture?.texture?.webglTexture;
        if(materialPBR.hasMetallicRoughnessMap) {
          materialPBR.metallicRoughnessSamplerSlot =
              baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture.texture
                  .textureId + skipTexture;
        }

        materialPBR.roughness = baseMaterial.pbrMetallicRoughness.roughnessFactor;
        materialPBR.metallic = baseMaterial.pbrMetallicRoughness.metallicFactor;
      }

      programs.add(material.getProgram());
    }
  }

  void drawPrimitives() {
    material.pvMatrix = (_projectionMatrix * _viewMatrix) as Matrix4;

    for (int i = 0; i < _mesh.primitives.length; i++) {
      GLTFMeshPrimitive primitive = _mesh.primitives[i];
      WebGLProgram program = programs[i];
      gl.useProgram(program.webGLProgram);

//      material.pvMatrix =
      _setupPrimitiveBuffers(program, primitive);

      material.setUniforms(
          program, modelMatrix, _viewMatrix, _projectionMatrix, mainCamera.translation, light);

      _drawPrimitive(primitive);
    }
  }

  void _setupPrimitiveBuffers(WebGLProgram program, GLTFMeshPrimitive primitive) {
    //debug.logCurrentFunction();

    //bind
    for (String attributName in primitive.attributes.keys) {
      _bindVertexArrayData(
          program, attributName, primitive.attributes[attributName]);
    }
    if (primitive.indices != null) {
      _bindIndices(primitive.indices);
    }
  }

  void _bindIndices(GLTFAccessor accessorIndices) {
    //debug.logCurrentFunction();

    Uint16List indices = accessorIndices.bufferView.buffer.data.buffer
        .asUint16List(
        accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
        accessorIndices.count);
    //debug.logCurrentFunction(indices.toString());

    _initBuffer('INDICES', accessorIndices.bufferView.usage, indices);
  }

  void _bindVertexArrayData(
      WebGLProgram program, String attributName, GLTFAccessor accessor) {
    //debug.logCurrentFunction();
    if(accessor.bufferView == null) throw 'bufferView must be defined';
    if(accessor.bufferView.buffer == null) throw 'buffer must be defined';

    Float32List verticesInfos = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.byteOffset + accessor.bufferView.byteOffset,
        accessor.count * (accessor.byteStride ~/ accessor.componentLength));

    //The offset of an accessor into a bufferView and the offset of an accessor into a buffer must be a multiple of the size of the accessor's component type.
    assert((accessor.bufferView.byteOffset + accessor.byteOffset) %
        accessor.componentLength ==
        0);

    //Each accessor must fit its bufferView, so next expression must be less than or equal to bufferView.length
    assert(accessor.byteOffset +
        accessor.byteStride * (accessor.count - 1) +
        (accessor.components * accessor.componentLength) <=
        accessor.bufferView.byteLength, '${accessor.byteOffset +
        accessor.byteStride * (accessor.count - 1) +
        (accessor.components * accessor.componentLength)} <= ${accessor.bufferView.byteLength}');

    //debug.logCurrentFunction('$attributName');
    //debug.logCurrentFunction(verticesInfos.toString());

    //>
    _initBuffer(attributName, accessor.bufferView.usage, verticesInfos);

    //>
    _setAttribut(program, attributName, accessor);
  }

  /// BufferType bufferType
  // Todo (jpu) : is it possible to use only one of the bufferViews
  void _initBuffer(String bufferName, int bufferType, TypedData data) {
    //debug.logCurrentFunction();

    if(buffers[bufferName] == null) {
      buffers[bufferName] =
          gl.createBuffer();
      gl.bindBuffer(bufferType, buffers[bufferName]);
      gl.bufferData(bufferType, data, BufferUsageType.STATIC_DRAW);
    }else{
      gl.bindBuffer(bufferType, buffers[bufferName]);
    }
  }

  //text utils
  String _capitalize(String s) =>
      s[0].toUpperCase() + s.substring(1).toLowerCase();

  /// [componentCount] => ex : 3 (x, y, z)
  void _setAttribut(
      WebGLProgram program, String attributName, GLTFAccessor accessor) {
    //debug.logCurrentFunction('$attributName');

    String shaderAttributName;
    if (attributName == 'TEXCOORD_0') {
      shaderAttributName = 'a_UV';
    } else {
      shaderAttributName = 'a_${_capitalize(attributName)}';
    }

    //>
    program.attributLocations[attributName] ??= gl.getAttribLocation(program.webGLProgram, shaderAttributName);
    int attributLocation = program.attributLocations[attributName];

    //if exist
    if (attributLocation >= 0) {
      int components = accessor.components;

      /// ShaderVariableType componentType
      int componentType = accessor.componentType;
      bool normalized = accessor.normalized;

      // how many bytes to move to the next vertex
      // 0 = use the correct stride for type and numComponents
      int stride = accessor.byteStride;

      // start at the beginning of the buffer that contains the sent data in the initBuffer.
      // Do not take the accesors offset. Actually, one buffer is created by attribut so start at 0
      int offset = 0;

      //debug.logCurrentFunction(
//          'gl.vertexAttribPointer($attributLocation, $components, $componentType, $normalized, $stride, $offset);');
      //debug.logCurrentFunction('$accessor');

      //>
      gl.vertexAttribPointer(attributLocation, components, componentType,
          normalized, stride, offset);
      gl.enableVertexAttribArray(
          attributLocation); // turn on getting data out of a buffer for this attribute
    }
  }

  void _drawPrimitive(GLTFMeshPrimitive primitive) {
    if (primitive.indices == null || primitive.mode == DrawMode.POINTS) {
      GLTFAccessor accessorPosition = primitive.attributes['POSITION'];
      if(accessorPosition == null) throw 'Mesh attribut Position accessor must almost have POSITION data defined :)';
      gl.drawArrays(
          primitive.mode, accessorPosition.byteOffset, accessorPosition.count);
    } else {
      GLTFAccessor accessorIndices = primitive.indices;
      gl.drawElements(primitive.mode, accessorIndices.count,
          accessorIndices.componentType, 0);
    }
  }
}