import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@reflector
class MaterialPoint extends Material {
  num pointSize;
  Vector4 color;

  @override
  ShaderSource get shaderSource => AssetLibrary.shaders.materialPoint;

  MaterialPoint({this.pointSize: 1.0, this.color});

  @override
  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    defines['USE_COLOR_UNIFORM'] = true;

    return defines;
  }

  @override
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
    setUniform(program, "u_PointSize", ShaderVariableType.FLOAT, pointSize);
    setUniform(
        program, "u_Color", ShaderVariableType.FLOAT_VEC4, color.storage);
  }
}