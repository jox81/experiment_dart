import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/context.dart';

///PBR's
///http://marcinignac.com/blog/pragmatic-pbr-setup-and-gamma/
///module explained can be found here : https://github.com/vorg/pragmatic-pbr/tree/master/local_modules
///base
@reflector
class MaterialPragmaticPBR extends Material {
  PointLight pointLight;

  ShaderSource get shaderSource => ShaderSource.materialPBR;

  MaterialPragmaticPBR(this.pointLight);

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
    Matrix3 normalMatrix = (viewMatrix * modelMatrix)
        .getNormalMatrix() as Matrix3;
    setUniform(program, "u_NormalMatrix", ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);
    setUniform(program, "u_LightPos", ShaderVariableType.FLOAT_VEC3,
        pointLight.translation.storage);
  }
}
