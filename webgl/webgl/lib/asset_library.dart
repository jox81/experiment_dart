import 'dart:html';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:path/path.dart' as path;
import 'package:webgl/src/assets_manager/loaders/shader_source_loader.dart';
import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/src/shaders/shader_source.dart';

class AssetLibrary{
  AssetLibrary();

  static _ImageLibrary images = new _ImageLibrary();
  static _CubeMapLibrary cubeMaps = new _CubeMapLibrary();
  static _ShaderLibrary shaders = new _ShaderLibrary();
}

class _ImageLibrary{

  String brdfLUTPath = 'packages/webgl/images/utils/brdfLUT.png';
  ImageElement get brdfLUT => _images[brdfLUTPath];

  List<String> _paths;
  List<String> get paths => _paths ??= [
    brdfLUTPath,
  ];

  Map<String, ImageElement> _images = {};

  void loadAll(){
    _images = {};
    paths.forEach((String path){
      _images[path] ??= new ImageLoader().loadSync(path);
    });
  }
}

enum CubeMapName{
  test,
  kitchen,
  pisa,
  papermill_diffuse,
  papermill_specular,
}

class _CubeMapLibrary{
  ///List of List because it can have multiple mips level images
  Map<CubeMapName, List<List<String>>> _cubeMapsPath = {
    CubeMapName.test: [[
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_px.png"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_nx.png"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_py.png"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_ny.png"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_pz.png"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_nz.png"),
    ]],
    CubeMapName.kitchen: [[
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c00.bmp"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c01.bmp"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c02.bmp"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c03.bmp"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c04.bmp"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c05.bmp")
    ]],
    CubeMapName.pisa: [[
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_posx.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_negx.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_posy.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_negy.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_posz.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_negz.jpg"),
    ]],
    CubeMapName.papermill_diffuse: [[
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_right_0.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_left_0.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_top_0.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_bottom_0.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_front_0.jpg"),
      path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_back_0.jpg"),
    ]],
    CubeMapName.papermill_specular: (){
      int mipsLevel = 10;
      List<List<String>> images = [];

      for (int i = 0; i < mipsLevel; ++i) {
        images.add(
            [
              path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_right_$i.jpg"),
              path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_left_$i.jpg"),
              path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_top_$i.jpg"),
              path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_bottom_$i.jpg"),
              path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_front_$i.jpg"),
              path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_back_$i.jpg"),
            ]);
      }

      return images;
    }()
  };

  Future<List<List<ImageElement>>> init(CubeMapName cubeMapName) async {

    List<List<String>> paths = _cubeMapsPath[cubeMapName];

    List<List<ImageElement>> imageElements = new List.generate(paths.length, (i) => new List(6));

    for (int mipsLevels = 0; mipsLevels < paths.length; mipsLevels++) {
      for (int i = 0; i < 6; i++) {
        imageElements[mipsLevels][i] = await new ImageLoader().load(paths[mipsLevels][i]);
      }
    }

    return imageElements;
  }
}

enum ShaderName{
  material_point,
  material_base,
  material_base_color,
  material_base_vertex_color,
  material_base_texture,
  material_depth_texture,
  material_base_texture_normal,
  material_pbr,
  material_skybox,
  material_reflection,
  kronos_gltf_pbr,
  kronos_gltf_pbr_test,
  kronos_gltf_default,
  debug_shader,
  sao,
  dot_screen,
}

class _ShaderLibrary{
  Map<ShaderName, ShaderSource> _sources = new Map();
  ShaderSource get materialPoint => _sources[ShaderName.material_point];
  ShaderSource get materialBase => _sources[ShaderName.material_base];
  ShaderSource get materialBaseColor => _sources[ShaderName.material_base_color];
  ShaderSource get materialBaseVertexColor => _sources[ShaderName.material_base_vertex_color];
  ShaderSource get materialBaseTexture => _sources[ShaderName.material_base_texture];
  ShaderSource get materialDepthTexture => _sources[ShaderName.material_depth_texture];
  ShaderSource get materialBaseTextureNormal =>  _sources[ShaderName.material_base_texture_normal];
  ShaderSource get materialPBR => _sources[ShaderName.material_pbr];
  ShaderSource get materialSkybox => _sources[ShaderName.material_skybox];
  ShaderSource get materialReflection => _sources[ShaderName.material_reflection];
  ShaderSource get kronosGltfPBR => _sources[ShaderName.kronos_gltf_pbr];
  ShaderSource get kronosGltfPBRTest => _sources[ShaderName.kronos_gltf_pbr_test];
  ShaderSource get kronosGltfDefault => _sources[ShaderName.kronos_gltf_default];
  ShaderSource get debugShader => _sources[ShaderName.debug_shader];
  ShaderSource get sao => _sources[ShaderName.sao];
  ShaderSource get dotScreen => _sources[ShaderName.dot_screen];

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

  Future init() async {
    List<ShaderSource> shaderSources = await new ShaderSourceLoader().loadAll(_shadersInfos);

    for (ShaderSource shaderSource in shaderSources) {
      _sources[shaderSource.shaderName] = shaderSource;
    }
  }
}