import 'dart:async';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:path/path.dart' as path;
import 'package:webgl/src/assets_manager/loader/glsl_loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class ShaderSources{
  static Map<String, ShaderSource> _sources = new Map();
  static ShaderSource get materialPoint => _sources['material_point'];
  static ShaderSource get materialBase => _sources['material_base'];
  static ShaderSource get materialBaseColor => _sources['material_base_color'];
  static ShaderSource get materialBaseVertexColor => _sources['material_base_vertex_color'];
  static ShaderSource get materialBaseTexture => _sources['material_base_texture'];
  static ShaderSource get materialDepthTexture => _sources['material_depth_texture'];
  static ShaderSource get materialBaseTextureNormal => _sources['material_base_texture_normal'];
  static ShaderSource get materialPBR => _sources['material_pbr'];
  static ShaderSource get materialSkybox => _sources['material_skybox'];
  static ShaderSource get materialReflection => _sources['material_reflection'];
  static ShaderSource get kronosGltfPBR => _sources['kronos_gltf_pbr'];
  static ShaderSource get kronosGltfPBRTest => _sources['kronos_gltf_pbr_test'];
  static ShaderSource get kronosGltfDefault => _sources['kronos_gltf_default'];
  static ShaderSource get debugShader => _sources['debug_shader'];
  static ShaderSource get sao => _sources['sao'];
  static ShaderSource get dotScreen => _sources['dot_screen'];

  final AssetManager assetManager;

  String _webPath;
  String _currentPackage;

  Map<String , List<String>> shadersPath = {
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
    ],
    'kronos_gltf_pbr' :[
      'shaders/kronos_gltf/kronos_gltf_pbr.vs.glsl',
      'shaders/kronos_gltf/kronos_gltf_pbr.fs.glsl'
    ],
    'kronos_gltf_pbr_test' :[
      'shaders/kronos_gltf/kronos_gltf_pbr_test.vs.glsl',
      'shaders/kronos_gltf/kronos_gltf_pbr_test.fs.glsl'
    ],
    'kronos_gltf_default' :[
      'shaders/kronos_gltf/kronos_gltf_default.vs.glsl',
      'shaders/kronos_gltf/kronos_gltf_default.fs.glsl'
    ],
    'debug_shader' :[
      'shaders/debug_shader/debug_shader.vs.glsl',
      'shaders/debug_shader/debug_shader.fs.glsl'
    ],
    'sao' :[
      'shaders/sao/sao.vs.glsl',
      'shaders/sao/sao.fs.glsl'
    ],

    //> Filters
    'dot_screen' :[
      'shaders/filters/dot_screen/dot_screen.vs.glsl',
      'shaders/filters/dot_screen/dot_screen.fs.glsl'
    ]
  };

  ShaderSources(this.assetManager){
    _webPath = UtilsHttp.useWebPath ? UtilsHttp.webPath : Uri.base.origin;
    _currentPackage = path.join(_webPath, 'packages/webgl');
  }

  Future loadShaders() async {

    List<Future> futures = <Future>[];

    for(String key in shadersPath.keys){
      futures.add(loadShader(key));
    }

    await Future.wait<dynamic>(futures);
  }

  Future loadShader(String key) async {
    ShaderSource shaderSource;
    shaderSource = new ShaderSource()
      ..shaderType = key
      ..vertexShaderPath =  path.join(_currentPackage, shadersPath[key][0])
      ..fragmentShaderPath = path.join(_currentPackage, shadersPath[key][1]);

    shaderSource.vsCode = await new GLSLLoader(shaderSource.vertexShaderPath).load();
    shaderSource.fsCode = await new GLSLLoader(shaderSource.fragmentShaderPath).load();

    _sources[shaderSource.shaderType] = shaderSource;
  }
}

class ShaderSource{

  String shaderType;

  String vertexShaderPath;
  String fragmentShaderPath;

  String vsCode;
  String fsCode;

  ShaderSource();
}