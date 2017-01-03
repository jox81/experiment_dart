import 'dart:async';
import 'dart:web_gl';

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

class ProgramInfo{
  List<WebGLActiveInfo> attributes = new List();
  List<WebGLActiveInfo> uniforms = new List();
  int attributeCount = 0;
  int uniformCount = 0;

  void display(){

  }
}

class UtilsShader {
  // Taken from the WebGL spec:
  // http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14
  static var enumTypes = {
    0x8B50: ShaderVariableType.FLOAT_VEC2,
    0x8B51: ShaderVariableType.FLOAT_VEC3,
    0x8B52: ShaderVariableType.FLOAT_VEC4,
    0x8B53: ShaderVariableType.INT_VEC2,
    0x8B54: ShaderVariableType.INT_VEC3,
    0x8B55: ShaderVariableType.INT_VEC4,
    0x8B56: ShaderVariableType.BOOL,
    0x8B57: ShaderVariableType.BOOL_VEC2,
    0x8B58: ShaderVariableType.BOOL_VEC3,
    0x8B59: ShaderVariableType.BOOL_VEC4,
    0x8B5A: ShaderVariableType.FLOAT_MAT2,
    0x8B5B: ShaderVariableType.FLOAT_MAT3,
    0x8B5C: ShaderVariableType.FLOAT_MAT4,
    0x8B5E: ShaderVariableType.SAMPLER_2D,
    0x8B60: ShaderVariableType.SAMPLER_CUBE,
    0x1400: ShaderVariableType.BYTE,
    0x1401: ShaderVariableType.UNSIGNED_BYTE,
    0x1402: ShaderVariableType.SHORT,
    0x1403: ShaderVariableType.UNSIGNED_SHORT,
    0x1404: ShaderVariableType.INT,
    0x1405: ShaderVariableType.UNSIGNED_INT,
    0x1406: ShaderVariableType.FLOAT
  };

  static ProgramInfo getProgramInfo(WebGLProgram program) {
    ProgramInfo result = new ProgramInfo();

    // Loop through active attributes
    int activeAttributsCount = program.activeAttributsCount;
    for (var i = 0; i < activeAttributsCount; i++) {
      WebGLActiveInfo attribute = new WebGLActiveInfo(program.getActiveAttrib(i));
      attribute.shaderVariableType = enumTypes[attribute.activeInfo.type];
      result.attributes.add(attribute);
      result.attributeCount += attribute.activeInfo.size;
    }

    // Loop through active uniforms
    var activeUniforms = program.getParameter(ProgramParameterGlEnum.ACTIVE_UNIFORMS);
    for (var i = 0; i < activeUniforms; i++) {
      WebGLActiveInfo uniform = new WebGLActiveInfo(program.getActiveUniform(i));
      uniform.shaderVariableType = enumTypes[uniform.activeInfo.type];
      result.uniforms.add(uniform);
      result.uniformCount += uniform.activeInfo.size;
    }

    return result;
  }
  
}

class ShaderSource{
  static Map<String , List<String>> shadersPath = {
    'material_point' :[
      '/application/shaders/material_point/material_point.vs.glsl',
      '/application/shaders/material_point/material_point.fs.glsl'
    ],
    'material_base' :[
      '/application/shaders/material_base/material_base.vs.glsl',
      '/application/shaders/material_base/material_base.fs.glsl'
    ],
    'material_base_color' :[
      '/application/shaders/material_base_color/material_base_color.vs.glsl',
      '/application/shaders/material_base_color/material_base_color.fs.glsl'
    ],
    'material_base_vertex_color' :[
      '/application/shaders/material_base_vertex_color/material_base_vertex_color.vs.glsl',
      '/application/shaders/material_base_vertex_color/material_base_vertex_color.fs.glsl'
    ],
    'material_base_texture' :[
      '/application/shaders/material_base_texture/material_base_texture.vs.glsl',
      '/application/shaders/material_base_texture/material_base_texture.fs.glsl'
    ],
    'material_base_texture_normal' :[
      '/application/shaders/material_base_texture_normal/material_base_texture_normal.vs.glsl',
      '/application/shaders/material_base_texture_normal/material_base_texture_normal.fs.glsl'
    ],
    'material_pbr' :[
      '/application/shaders/material_pbr/material_pbr.vs.glsl',
      '/application/shaders/material_pbr/material_pbr.fs.glsl'
    ]
  };
  static Map<String, ShaderSource> sources = new Map();

  static Future loadShaders() async {

    for(String key in shadersPath.keys){

      ShaderSource shaderSource = new ShaderSource()
        ..shaderType = key
        ..vertexShaderPath = shadersPath[key][0]
        ..fragmentShaderPath = shadersPath[key][1];
      await shaderSource._loadShader();

      sources[shaderSource.shaderType] = shaderSource;
    }
  }

  String shaderType;

  String vertexShaderPath;
  String fragmentShaderPath;

  String vsCode;
  String fsCode;

  ShaderSource();

  Future _loadShader()async {
    vsCode = await Utils.loadGlslShader(vertexShaderPath);
    fsCode = await Utils.loadGlslShader(fragmentShaderPath);
  }

}

