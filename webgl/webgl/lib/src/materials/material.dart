import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart'
    as glEnum;
import 'package:webgl/src/utils/utils_debug.dart' as debug;
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@reflector
abstract class Material {
  String name;

  Matrix4 pvMatrix = new Matrix4.identity();

  ShaderSource get shaderSource;

  Map<String, bool> _defines;
  Map<String, bool> get defines => _defines ??= getDefines();

  /// This builds Preprocessors for glsl shader source
  String _definesToString(Map<String, bool> defines) {
    //debugLog.logCurrentFunction();
    String outStr = '';
    if (defines == null) return outStr;

    for (String def in defines.keys) {
      if (defines[def]) {
        outStr += '#define $def ${defines[def]}\n';
      }
    }
    return outStr;
  }

  ///Defines glsl preprocessors
  Map<String, bool> getDefines();

  WebGLProgram getProgram() {
    //debugLog.logCurrentFunction();

    String shaderDefines = _definesToString(defines);

    String vsSource = shaderDefines + shaderSource.vsCode;
    String fsSource = shaderDefines + shaderSource.fsCode;

    /// ShaderType type
    webgl.Shader createShader(int shaderType, String shaderSource) {
      //debugLog.logCurrentFunction();

      webgl.Shader shader = gl.createShader(shaderType);
      gl.shaderSource(shader, shaderSource);
      gl.compileShader(shader);

      if (debug.isDebug) {
        bool compiled = gl.getShaderParameter(
            shader, ShaderParameters.COMPILE_STATUS) as bool;
        if (!compiled) {
          String compilationLog = gl.getShaderInfoLog(shader);

          throw "Could not compile ${glEnum.ShaderType.getByIndex(shaderType)} shader :\n\n $compilationLog}";
        }
      }

      return shader;
    }

    webgl.Shader vertexShader =
        createShader(ShaderType.VERTEX_SHADER, vsSource);
    webgl.Shader fragmentShader =
        createShader(ShaderType.FRAGMENT_SHADER, fsSource);

    webgl.Program program = gl.createProgram();

    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (debug.isDebug) {
      if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS)
              as bool ==
          false) {
        throw "Could not link the shader program! > ${gl.getProgramInfoLog(program)}";
      }
    }
    gl.validateProgram(program);
    if (debug.isDebug) {
      if (gl.getProgramParameter(
              program, ProgramParameterGlEnum.VALIDATE_STATUS) as bool ==
          false) {
        throw "Could not validate program! > ${gl.getProgramInfoLog(program)} > ${gl.getProgramInfoLog(program)}";
      }
    }

    return new WebGLProgram.fromWebGL(program);
  }

  ///Must be called after gl.useProgram
  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight);

  /// ShaderVariableType componentType
  void setUniform(WebGLProgram program, String uniformName, int componentType,
      dynamic data) {
    //debugLog.logCurrentFunction(uniformName);

    program.uniformLocations[uniformName] ??=
        program.getUniformLocation(uniformName);
    WebGLUniformLocation wrappedUniformLocation =
        program.uniformLocations[uniformName];

//    if(uniformName == ())
    //let's pass if u_Camera, else it won't drow reflection correctly wrappedUniformLocation.data == data && uniformName != "u_Camera"
    if (wrappedUniformLocation.data == data &&
        uniformName != "u_Camera" &&
        uniformName != "u_ModelMatrix") {
      //      print('same $uniformName > return : $data, ${wrappedUniformLocation.data}');
      return;
    }

    wrappedUniformLocation.data = data;
    webgl.UniformLocation uniformLocation =
        wrappedUniformLocation.webGLUniformLocation;
    bool transpose = false;

    switch (componentType) {
      case ShaderVariableType.BOOL:
      case ShaderVariableType.SAMPLER_CUBE:
      case ShaderVariableType.SAMPLER_2D:
        gl.uniform1i(uniformLocation, data as int);
        break;
      case ShaderVariableType.FLOAT:
        gl.uniform1f(uniformLocation, data as num);
        break;
      case ShaderVariableType.FLOAT_VEC2:
        gl.uniform2fv(uniformLocation, data);
        break;
      case ShaderVariableType.FLOAT_VEC3:
        gl.uniform3fv(uniformLocation, data);
        break;
      case ShaderVariableType.FLOAT_VEC4:
        gl.uniform4fv(uniformLocation, data);
        break;
      case ShaderVariableType.FLOAT_MAT3:
        gl.uniformMatrix3fv(uniformLocation, transpose, data);
        break;
      case ShaderVariableType.FLOAT_MAT4:
        gl.uniformMatrix4fv(uniformLocation, transpose, data);
        break;
      default:
        throw new Exception(
            'renderer setUnifrom exception : Trying to set a uniform for a not defined component type : $componentType');
        break;
    }
  }

  void setupBeforeRender() {}

  void setupAfterRender() {}
}