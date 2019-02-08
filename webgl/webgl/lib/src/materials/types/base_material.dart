import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@reflector
class MaterialBase extends Material {
  ShaderSource get shaderSource => AssetLibrary.shaders.materialBase;

  MaterialBase();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelMatrix", ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    setUniform(program, "u_ViewMatrix", ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
  }
}