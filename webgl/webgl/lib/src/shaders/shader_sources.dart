import 'dart:async';
import 'package:webgl/src/assets_manager/loaders/shader_source_loader.dart';
import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/src/shaders/shader_name.dart';
import 'package:webgl/src/shaders/shader_source.dart';

class ShaderSources {
  static Map<ShaderName, ShaderSource> _sources = new Map();
  static ShaderSource get materialPoint => _sources[ShaderName.material_point];
  static ShaderSource get materialBase => _sources[ShaderName.material_base];
  static ShaderSource get materialBaseColor => _sources[ShaderName.material_base_color];
  static ShaderSource get materialBaseVertexColor => _sources[ShaderName.material_base_vertex_color];
  static ShaderSource get materialBaseTexture => _sources[ShaderName.material_base_texture];
  static ShaderSource get materialDepthTexture => _sources[ShaderName.material_depth_texture];
  static ShaderSource get materialBaseTextureNormal =>  _sources[ShaderName.material_base_texture_normal];
  static ShaderSource get materialPBR => _sources[ShaderName.material_pbr];
  static ShaderSource get materialSkybox => _sources[ShaderName.material_skybox];
  static ShaderSource get materialReflection => _sources[ShaderName.material_reflection];
  static ShaderSource get kronosGltfPBR => _sources[ShaderName.kronos_gltf_pbr];
  static ShaderSource get kronosGltfPBRTest => _sources[ShaderName.kronos_gltf_pbr_test];
  static ShaderSource get kronosGltfDefault => _sources[ShaderName.kronos_gltf_default];
  static ShaderSource get debugShader => _sources[ShaderName.debug_shader];
  static ShaderSource get sao => _sources[ShaderName.sao];
  static ShaderSource get dotScreen => _sources[ShaderName.dot_screen];

  List<ShaderInfos> _shadersInfos = [
    new ShaderInfos(
        ShaderName.material_point,
        'shaders/material_point/material_point.vs.glsl',
        'shaders/material_point/material_point.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_base,
        'shaders/material_base/material_base.vs.glsl',
        'shaders/material_base/material_base.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_base_color,
        'shaders/material_base_color/material_base_color.vs.glsl',
        'shaders/material_base_color/material_base_color.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_base_vertex_color,
        'shaders/material_base_vertex_color/material_base_vertex_color.vs.glsl',
        'shaders/material_base_vertex_color/material_base_vertex_color.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_base_texture,
        'shaders/material_base_texture/material_base_texture.vs.glsl',
        'shaders/material_base_texture/material_base_texture.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_depth_texture,
        'shaders/material_depth_texture/material_depth_texture.vs.glsl',
        'shaders/material_depth_texture/material_depth_texture.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_base_texture_normal,
        'shaders/material_base_texture_normal/material_base_texture_normal.vs.glsl',
        'shaders/material_base_texture_normal/material_base_texture_normal.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_pbr,
        'shaders/material_pbr/material_pbr.vs.glsl',
        'shaders/material_pbr/material_pbr.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_skybox,
        'shaders/material_skybox/material_skybox.vs.glsl',
        'shaders/material_skybox/material_skybox.fs.glsl'),
    new ShaderInfos(
        ShaderName.material_reflection,
        'shaders/reflection/reflection.vs.glsl',
        'shaders/reflection/reflection.fs.glsl'),
    new ShaderInfos(
        ShaderName.kronos_gltf_pbr,
        'shaders/kronos_gltf/kronos_gltf_pbr.vs.glsl',
        'shaders/kronos_gltf/kronos_gltf_pbr.fs.glsl'),
    new ShaderInfos(
        ShaderName.kronos_gltf_pbr_test,
        'shaders/kronos_gltf/kronos_gltf_pbr_test.vs.glsl',
        'shaders/kronos_gltf/kronos_gltf_pbr_test.fs.glsl'),
    new ShaderInfos(
        ShaderName.kronos_gltf_default,
        'shaders/kronos_gltf/kronos_gltf_default.vs.glsl',
        'shaders/kronos_gltf/kronos_gltf_default.fs.glsl'),
    new ShaderInfos(
        ShaderName.debug_shader,
        'shaders/debug_shader/debug_shader.vs.glsl',
        'shaders/debug_shader/debug_shader.fs.glsl'),
    new ShaderInfos(
        ShaderName.sao,
        'shaders/sao/sao.vs.glsl',
        'shaders/sao/sao.fs.glsl'),

    //> Filters
    new ShaderInfos(
        ShaderName.dot_screen,
        'shaders/filters/dot_screen/dot_screen.vs.glsl',
        'shaders/filters/dot_screen/dot_screen.fs.glsl')
  ];

  ShaderSources();

  Future loadShaders() async {
    List<ShaderSource> shaderSources = await _loadShaders(_shadersInfos);

    for (ShaderSource shaderSource in shaderSources) {
      _sources[shaderSource.shaderName] = shaderSource;
    }
  }

  Future<List<ShaderSource>> _loadShaders(List<ShaderInfos> shadersInfos) async {
    List<Future<ShaderSource>> futures = <Future<ShaderSource>>[];

    List<ShaderSource> shaderSources = [];
    for (ShaderInfos shaderInfos in shadersInfos) {
      futures.add(() async{
        ShaderSource shaderSource = await new ShaderSourceLoader(shaderInfos).load();
        shaderSources.add(shaderSource);
      }());
    }

    await Future.wait<dynamic>(futures);

    return shaderSources;
  }
}
