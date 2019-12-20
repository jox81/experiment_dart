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
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

//@reflector
abstract class Material {
  String name;

  Matrix4 pvMatrix = new Matrix4.identity();

  ShaderSource get shaderSource;

  Map<String, bool> _defines;
  Map<String, bool> get defines => _defines ??= getDefines();

  /// This builds Preprocessors for glsl shader source
  String _definesToString(Map<String, bool> defines) {
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
  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();
    //add define to override
    return defines;
  }

  WebGLProgram _program;
  WebGLProgram get program => _program ??= _getProgram();
  WebGLProgram _getProgram() {

    String shaderDefines = _definesToString(defines);

    String vsSource = shaderDefines + shaderSource.vsCode;
    String fsSource = shaderDefines + shaderSource.fsCode;

    /// ShaderType type
    WebGLShader createShader(int shaderType, String shaderSource) {
      WebGLShader shader = new WebGLShader(shaderType)
        ..source = shaderSource
        ..compile();

      if (debug.isDebug) {
        bool compiled = shader.compileStatus;
        if (!compiled) {
          shader.logShaderInfos();
          shader.delete();

          throw "Could not compile ${glEnum.ShaderType.getByIndex(shaderType)} shader :\n\n ${shader.infoLog}}";
        }
      }

      return shader;
    }

    WebGLProgram createProgram(WebGLShader vertexShader, WebGLShader fragmentShader) {
      WebGLProgram program = new WebGLProgram();
      program.attachShader(vertexShader);
      program.attachShader(fragmentShader);
      program.link();
      if (debug.isDebug) {
        bool linked = program.linkStatus;
        if (!linked) {
          String infoLog = program.infoLog;
          program.delete();
          throw "Could not link the shader program! > $infoLog";
        }
      }
      program.validate();
      if (debug.isDebug) {
        bool validated = program.validateStatus;
        if (!validated) {
          String infoLog = program.infoLog;
          throw "Could not validate program! > $infoLog";
        }
      }

      return program;
    }

    WebGLShader vertexShader = createShader(ShaderType.VERTEX_SHADER, vsSource);
    WebGLShader fragmentShader = createShader(ShaderType.FRAGMENT_SHADER, fsSource);
    WebGLProgram program = createProgram(vertexShader, fragmentShader);

    return program;
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

    program.uniformLocations[uniformName] ??=
        program.getUniformLocation(uniformName);
    WebGLUniformLocation wrappedUniformLocation =
        program.uniformLocations[uniformName];

    //let's pass if u_Camera, else it won't draw reflection correctly wrappedUniformLocation.data == data && uniformName != "u_Camera"
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