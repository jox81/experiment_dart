import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/context.dart';

@reflector
class MaterialDepthTexture extends Material {
  WebGLTexture texture;

  num near = 1.0;
  num far = 1000.0;

  ShaderSource get shaderSource => ShaderSource.materialDepthTexture;

  MaterialDepthTexture();

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
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    //removing camera translation
    Matrix3 m3 = viewMatrix.getRotation();
    Matrix4 m4 = new Matrix4.identity()..setRotation(m3);
    setUniform(
        program, "u_ViewMatrix", ShaderVariableType.FLOAT_MAT4, m4.storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    gl.activeTexture(TextureUnit.TEXTURE7);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
    setUniform(program, "u_EnvMap", ShaderVariableType.SAMPLER_2D, 7);

    setUniform(program, "u_near", ShaderVariableType.FLOAT, near);
    setUniform(program, "u_far", ShaderVariableType.FLOAT, far);
  }
}