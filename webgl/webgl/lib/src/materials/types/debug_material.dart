import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/shaders/shader_sources.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@reflector
class MaterialDebug extends Material {
  Vector3 color = new Vector3(0.5, 0.5, 0.5);

  MaterialDebug();

  ShaderSource get shaderSource => ShaderSources.debugShader;

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    Map<String, bool> defines = new Map();

    //primitives infos
    defines['HAS_COLORS'] = false;
    defines['HAS_NORMALS'] = true;
    defines['HAS_TANGENTS'] = false;
    defines['HAS_UV'] = true;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS_POSITION'] = false;
    defines['DEBUG_FS_NORMALS'] = defines['HAS_NORMALS'] && true;
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
        program, 'u_Color', ShaderVariableType.FLOAT_VEC3, color.storage);
  }
}