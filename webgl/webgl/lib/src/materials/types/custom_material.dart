import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/shaders/shader_sources.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

typedef void SetShaderVariables(
    WebGLProgram program,
    Matrix4 modelMatrix,
    Matrix4 viewMatrix,
    Matrix4 projectionMatrix,
    Vector3 cameraPosition,
    DirectionalLight directionalLight);

@reflector
class MaterialCustom extends Material {
  SetShaderVariables setShaderUniformsVariables;

  ShaderSource get shaderSource => ShaderSources.materialPoint; // Todo (jpu) : ?

  MaterialCustom();

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
    setShaderUniformsVariables(program, modelMatrix, viewMatrix,
        projectionMatrix, cameraPosition, directionalLight);
  }
}