import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@reflector
class MaterialSAO extends Material {
  MaterialSAO();

  ShaderSource get shaderSource => AssetLibrary.shaders.sao;

  int get depthTextureMap => null;
  double get intensity => 100.0;
  double get sampleRadiusWS => 5.0;
  double get bias => 0.0;
  double get zNear => 1.0;
  double get zFar => 1000.0;
  Vector2 get viewportResolution => new Vector2(256.0, 256.0);
  Vector4 get projInfo => new Vector4(1.0, 1.0, 1.0, 0.0);
  double get projScale => 100.0;

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    //primitives infos
    defines['HAS_COLORS'] = false;
    defines['HAS_UV'] = true;
    defines['HAS_NORMALS'] = false;
    defines['HAS_TANGENTS'] = false;

    //Fragment shader
    defines['DIFFUSE_TEXTURE'] = false;
    defines['NORMAL_TEXTURE'] = false;
    defines['DEPTH_PACKING'] = false;
    defines['PERSPECTIVE_CAMERA'] = false;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS_POSITION'] = false;
    defines['DEBUG_FS_NORMALS'] = defines['HAS_NORMALS'] && false;
    defines['DEBUG_FS_UV'] = defines['HAS_UV'] && false;

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    setUniform(
        program, 'tDepth', ShaderVariableType.SAMPLER_2D, depthTextureMap);
    setUniform(program, 'intensity', ShaderVariableType.FLOAT, intensity);
    setUniform(
        program, 'sampleRadiusWS', ShaderVariableType.FLOAT, sampleRadiusWS);
    setUniform(program, 'bias', ShaderVariableType.FLOAT, bias);
    setUniform(program, 'zNear', ShaderVariableType.FLOAT, zNear);
    setUniform(program, 'zFar', ShaderVariableType.FLOAT, zFar);
    setUniform(program, 'viewportResolution', ShaderVariableType.FLOAT,
        viewportResolution);
    setUniform(program, 'projInfo', ShaderVariableType.FLOAT, projInfo);
    setUniform(program, 'projScale', ShaderVariableType.FLOAT, projScale);
  }
}