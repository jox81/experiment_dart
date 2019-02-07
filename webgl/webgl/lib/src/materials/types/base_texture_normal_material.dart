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
class MaterialBaseTextureNormal extends Material {
  WebGLTexture texture;
  Vector3 ambientColor = new Vector3.all(1.0);
  DirectionalLight directionalLight;
  bool useLighting = false;

  ShaderSource get shaderSource => ShaderSources.materialBaseTextureNormal;

  MaterialBaseTextureNormal();

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

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix =
    (viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    setUniform(program, "u_NormalMatrix", ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    setUniform(program, "u_UseLighting", ShaderVariableType.BOOL,
        useLighting ? 1 : 0); // must be int, not bool

    if (useLighting) {
      setUniform(program, "u_AmbientColor", ShaderVariableType.FLOAT_VEC3,
          ambientColor.storage);
      Vector3 adjustedLD = new Vector3.zero();
      directionalLight.direction.normalizeInto(adjustedLD);
      adjustedLD.scale(-1.0);

      setUniform(program, "u_LightingDirection", ShaderVariableType.FLOAT_VEC3,
          adjustedLD.storage);
      setUniform(program, "u_DirectionalColor", ShaderVariableType.FLOAT_VEC3,
          directionalLight.color.storage);
    }

    gl.activeTexture(TextureUnit.TEXTURE7);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
    setUniform(program, "u_Sampler", ShaderVariableType.SAMPLER_2D, 7);
  }
}