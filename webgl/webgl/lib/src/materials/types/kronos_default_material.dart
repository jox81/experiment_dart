import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@reflector
class KronosDefaultMaterial extends Material {
  KronosDefaultMaterial();

  ShaderSource get shaderSource => ShaderSource.kronosGltfDefault;

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    // Todo (jpu) : enable defines if needed

    Map<String, bool> defines = new Map();

    defines['USE_IBL'] = false;
    defines['USE_TEX_LOD'] = false;

    //primitives infos
    defines['HAS_NORMALS'] = false;
    defines['HAS_TANGENTS'] = false;
    defines['HAS_UV'] = false;

    //Material base infos
    defines['HAS_NORMALMAP'] = false;
    defines['HAS_EMISSIVEMAP'] = false;
    defines['HAS_OCCLUSIONMAP'] = false;

    //Material infos
    defines['HAS_BASECOLORMAP'] = false;
    defines['HAS_METALROUGHNESSMAP'] = false;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS'] = false;

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    //debugLog.logCurrentFunction();

    setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    setUniform(program, 'u_MVPMatrix', ShaderVariableType.FLOAT_MAT4,
        ((projectionMatrix * viewMatrix * modelMatrix) as Matrix4).storage);

    Matrix3 normalMatrix =
    (viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    setUniform(program, 'u_NormalMatrix', ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    setUniform(program, 'u_LightPos', ShaderVariableType.FLOAT_VEC3,
        directionalLight.translation.storage);
  }
}