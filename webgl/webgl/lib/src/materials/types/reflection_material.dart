import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/context.dart';

@reflector
class MaterialReflection extends Material {
  WebGLTexture skyboxTexture;

  ShaderSource get shaderSource => ShaderSource.materialReflection;

  MaterialReflection();

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
    setUniform(program, "u_InverseViewMatrix", ShaderVariableType.FLOAT_MAT4,
        new Matrix4.inverted(viewMatrix).storage);

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix =
    (viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    setUniform(program, "u_NormalMatrix", ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    gl.activeTexture(TextureUnit.TEXTURE7);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture.webGLTexture);
    setUniform(program, "u_EnvMap", ShaderVariableType.SAMPLER_CUBE, 7);
  }
}