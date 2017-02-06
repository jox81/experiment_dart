import 'dart:async';
import 'package:webgl/src/utils_assets.dart';
@MirrorsUsed(
    targets: const [
      ShaderSource,
    ],
    override: '*')
import 'dart:mirrors';

class ShaderSource{

  static Map<String , List<String>> shadersPath = {
    'material_point' :[
      'shaders/material_point/material_point.vs.glsl',
      'shaders/material_point/material_point.fs.glsl'
    ],
    'material_base' :[
      'shaders/material_base/material_base.vs.glsl',
      'shaders/material_base/material_base.fs.glsl'
    ],
    'material_base_color' :[
      'shaders/material_base_color/material_base_color.vs.glsl',
      'shaders/material_base_color/material_base_color.fs.glsl'
    ],
    'material_base_vertex_color' :[
      'shaders/material_base_vertex_color/material_base_vertex_color.vs.glsl',
      'shaders/material_base_vertex_color/material_base_vertex_color.fs.glsl'
    ],
    'material_base_texture' :[
      'shaders/material_base_texture/material_base_texture.vs.glsl',
      'shaders/material_base_texture/material_base_texture.fs.glsl'
    ],
    'material_depth_texture' :[
      'shaders/material_depth_texture/material_depth_texture.vs.glsl',
      'shaders/material_depth_texture/material_depth_texture.fs.glsl'
    ],
    'material_base_texture_normal' :[
      'shaders/material_base_texture_normal/material_base_texture_normal.vs.glsl',
      'shaders/material_base_texture_normal/material_base_texture_normal.fs.glsl'
    ],
    'material_pbr' :[
      'shaders/material_pbr/material_pbr.vs.glsl',
      'shaders/material_pbr/material_pbr.fs.glsl'
    ],
    'material_skybox' :[
      'shaders/material_skybox/material_skybox.vs.glsl',
      'shaders/material_skybox/material_skybox.fs.glsl'
    ],
    'material_reflection' :[
      'shaders/reflection/reflection.vs.glsl',
      'shaders/reflection/reflection.fs.glsl'
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
    vsCode = await UtilsAssets.loadGlslShader(vertexShaderPath);
    fsCode = await UtilsAssets.loadGlslShader(fragmentShaderPath);
  }
}