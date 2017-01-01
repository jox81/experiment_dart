import 'dart:async';
import 'dart:web_gl';

import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils.dart';

class ActiveInfoCustom{
  String typeName;
  ActiveInfo activeInfo;
  ActiveInfoCustom(this.activeInfo) {}
}

class ProgramInfo{
  List<ActiveInfoCustom> attributes = new List();
  List<ActiveInfoCustom> uniforms = new List();
  int attributeCount = 0;
  int uniformCount = 0;

  void display(){

  }
}

class UtilsShader {
  // Taken from the WebGl spec:
  // http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14
  static var enumTypes = {
    0x8B50: 'FLOAT_VEC2',
    0x8B51: 'FLOAT_VEC3',
    0x8B52: 'FLOAT_VEC4',
    0x8B53: 'INT_VEC2',
    0x8B54: 'INT_VEC3',
    0x8B55: 'INT_VEC4',
    0x8B56: 'BOOL',
    0x8B57: 'BOOL_VEC2',
    0x8B58: 'BOOL_VEC3',
    0x8B59: 'BOOL_VEC4',
    0x8B5A: 'FLOAT_MAT2',
    0x8B5B: 'FLOAT_MAT3',
    0x8B5C: 'FLOAT_MAT4',
    0x8B5E: 'SAMPLER_2D',
    0x8B60: 'SAMPLER_CUBE',
    0x1400: 'BYTE',
    0x1401: 'UNSIGNED_BYTE',
    0x1402: 'SHORT',
    0x1403: 'UNSIGNED_SHORT',
    0x1404: 'INT',
    0x1405: 'UNSIGNED_INT',
    0x1406: 'FLOAT'
  };

  static ProgramInfo getProgramInfo(Program program) {
    ProgramInfo result = new ProgramInfo();

    // Loop through active attributes
    var activeAttributes = gl.getProgramParameter(
        program, RenderingContext.ACTIVE_ATTRIBUTES);
    for (var i = 0; i < activeAttributes; i++) {
      ActiveInfoCustom attribute = new ActiveInfoCustom(gl.getActiveAttrib(program, i));
      attribute.typeName = enumTypes[attribute.activeInfo.type];
      result.attributes.add(attribute);
      result.attributeCount += attribute.activeInfo.size;
    }

    // Loop through active uniforms
    var activeUniforms = gl.getProgramParameter(program, RenderingContext.ACTIVE_UNIFORMS);
    for (var i = 0; i < activeUniforms; i++) {
      ActiveInfoCustom uniform = new ActiveInfoCustom(gl.getActiveUniform(program, i));
      uniform.typeName = enumTypes[uniform.activeInfo.type];
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

