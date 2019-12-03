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

@reflector
class MaterialSkyBox extends Material {
  WebGLTexture skyboxTexture;

  @override
  ShaderSource get shaderSource => AssetLibrary.shaders.materialSkybox;

  MaterialSkyBox();

  /// ! vu ceci, il faut que l'objet qui a ce matériaux soit rendu en premier
  @override
  void setupBeforeRender(){
    gl.disable(EnableCapabilityType.DEPTH_TEST);
  }
  @override
  void setupAfterRender(){
    gl.enable(EnableCapabilityType.DEPTH_TEST);
  }

  @override
  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    //removing skybox transform
    setUniform(program, "u_ModelMatrix", ShaderVariableType.FLOAT_MAT4,
        new Matrix4.identity().storage);

    //removing camera translation
    Matrix3 m3 = viewMatrix.getRotation();
    Matrix4 m4 = new Matrix4.identity()..setRotation(m3);
    setUniform(
        program, "u_ViewMatrix", ShaderVariableType.FLOAT_MAT4, m4.storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    // Todo (jpu) : si dans ce matériaux, l'active texture n'est pas TEXTURE0, 0 alors ça plante ! pq ?
    gl.activeTexture(TextureUnit.TEXTURE0);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture.webGLTexture);
    setUniform(program, "u_EnvMap", ShaderVariableType.SAMPLER_CUBE, 0);
  }
}
