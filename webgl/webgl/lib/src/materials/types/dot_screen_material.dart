import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/context.dart';

//@reflector
class MaterialDotScreen extends Material {
  WebGLTexture texture;
  double angle = 0.0;
  double scale = 1.0;
  Vector2 center = new Vector2(0.0, 0.0);
  Vector2 texSize = new Vector2(200.0, 200.0);

  @override
  ShaderSource get shaderSource => AssetLibrary.shaders.dotScreen;

  MaterialDotScreen();

  @override
  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    if (texture != null) {
      gl.activeTexture(TextureUnit.TEXTURE0);
      gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
      setUniform(program, "texture", ShaderVariableType.SAMPLER_2D, 0);
    }
    setUniform(
        program, "center", ShaderVariableType.FLOAT_VEC2, center.storage);
    setUniform(program, "angle", ShaderVariableType.FLOAT, angle);
    setUniform(program, "scale", ShaderVariableType.FLOAT, scale);
    setUniform(
        program, "texSize", ShaderVariableType.FLOAT_VEC2, texSize.storage);
  }
}