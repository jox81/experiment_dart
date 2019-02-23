import 'dart:html';
import 'package:webgl/src/assets_manager/library.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:path/path.dart' as path;
import 'package:webgl/src/assets_manager/loaders/shader_source_loader.dart';
import 'package:webgl/src/assets_manager/not_loaded_exception.dart';
import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/src/shaders/shader_source.dart';

class AssetLibrary {
  AssetLibrary();

  static _ImageLibrary project = new _ImageLibrary();
  // Todo (jpu) : extends library for those 2
  static _CubeMapLibrary cubeMaps = new _CubeMapLibrary();
  static _ShaderLibrary shaders = new _ShaderLibrary();

  static Future loadDefault() async {
    await AssetLibrary.project.loadAll();
    await AssetLibrary.cubeMaps.load(CubeMapName.papermill_diffuse);
    await AssetLibrary.cubeMaps.load(CubeMapName.papermill_specular);
    await AssetLibrary.shaders.loadAll();
  }
}

class _ImageLibrary extends Library {
  String _brdfLUTPath = 'packages/webgl/images/utils/brdfLUT.png';
  ImageElement get brdfLUT => getImageElement(_brdfLUTPath);

  String _uvPath = 'packages/webgl/images/utils/uv.png';
  ImageElement get uv => getImageElement(_uvPath);

  String _uvGridPath = 'packages/webgl/images/utils/uv_grid.jpg';
  ImageElement get uvGrid => getImageElement(_uvGridPath);

  String _cratePath = 'packages/webgl/images/crate.gif';
  ImageElement get crate => getImageElement(_cratePath);

  _ImageLibrary() {
    addImageElementPath(_brdfLUTPath);
    addImageElementPath(_uvPath);
    addImageElementPath(_uvGridPath);
    addImageElementPath(_cratePath);
  }
}

enum CubeMapName {
  test,
  kitchen,
  pisa,
  papermill_diffuse,
  papermill_specular,
}

class _CubeMapLibrary {
  ///List of List because it can have multiple mips level images
  Map<CubeMapName, List<List<String>>> _cubeMapsPath = {
    CubeMapName.test: [
      [
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/test/test_px.png"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/test/test_nx.png"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/test/test_py.png"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/test/test_ny.png"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/test/test_pz.png"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/test/test_nz.png"),
      ]
    ],
    CubeMapName.kitchen: [
      [
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c00.bmp"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c01.bmp"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c02.bmp"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c03.bmp"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c04.bmp"),
        path.join(
            Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c05.bmp")
      ]
    ],
    CubeMapName.pisa: [
      [
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/pisa/pisa_posx.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/pisa/pisa_negx.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/pisa/pisa_posy.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/pisa/pisa_negy.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/pisa/pisa_posz.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/pisa/pisa_negz.jpg"),
      ]
    ],
    CubeMapName.papermill_diffuse: [
      [
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/papermill/diffuse/diffuse_right_0.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/papermill/diffuse/diffuse_left_0.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/papermill/diffuse/diffuse_top_0.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/papermill/diffuse/diffuse_bottom_0.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/papermill/diffuse/diffuse_front_0.jpg"),
        path.join(Uri.base.origin,
            "packages/webgl/images/cubemap/papermill/diffuse/diffuse_back_0.jpg"),
      ]
    ],
    CubeMapName.papermill_specular: () {
      int mipsLevel = 10;
      List<List<String>> images = [];

      for (int i = 0; i < mipsLevel; ++i) {
        images.add([
          path.join(Uri.base.origin,
              "packages/webgl/images/cubemap/papermill/specular/specular_right_$i.jpg"),
          path.join(Uri.base.origin,
              "packages/webgl/images/cubemap/papermill/specular/specular_left_$i.jpg"),
          path.join(Uri.base.origin,
              "packages/webgl/images/cubemap/papermill/specular/specular_top_$i.jpg"),
          path.join(Uri.base.origin,
              "packages/webgl/images/cubemap/papermill/specular/specular_bottom_$i.jpg"),
          path.join(Uri.base.origin,
              "packages/webgl/images/cubemap/papermill/specular/specular_front_$i.jpg"),
          path.join(Uri.base.origin,
              "packages/webgl/images/cubemap/papermill/specular/specular_back_$i.jpg"),
        ]);
      }

      return images;
    }()
  };

  Map<CubeMapName, List<List<ImageElement>>> _data = {};

  List<List<ImageElement>> _getAsset(CubeMapName cubeMapName) =>
      _data[cubeMapName] ?? (throw new NotLoadedAssetException());
  List<List<ImageElement>> getCubeMap(CubeMapName cubeMapName) =>
      _getAsset(cubeMapName);

  List<List<ImageElement>> get papermillDiffuse =>
      _getAsset(CubeMapName.papermill_diffuse);
  List<List<ImageElement>> get papermillSpecular =>
      _getAsset(CubeMapName.papermill_specular);
  List<List<ImageElement>> get pisa => _getAsset(CubeMapName.pisa);
  List<List<ImageElement>> get kitchen => _getAsset(CubeMapName.kitchen);
  List<List<ImageElement>> get test => _getAsset(CubeMapName.test);

  Future load(CubeMapName cubeMapName) async {
    List<List<String>> paths = _cubeMapsPath[cubeMapName];

    List<List<ImageElement>> imageElements =
        new List.generate(paths.length, (i) => new List(6));

    for (int mipsLevels = 0; mipsLevels < paths.length; mipsLevels++) {
      for (int i = 0; i < 6; i++) {
        ImageLoader loader = new ImageLoader()..filePath = paths[mipsLevels][i];
        AssetLibrary.project.addLoader(loader);
        await loader.load();
        imageElements[mipsLevels][i] = loader.result;
      }
    }

    _data[cubeMapName] = imageElements;
  }
}

enum ShaderName {
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

class _ShaderLibrary {
  Map<String, ShaderSource> _sources = new Map();

  ShaderSource get materialPoint => _sources[ShaderName.material_point.toString()];
  ShaderSource get materialBase => _sources[ShaderName.material_base.toString()];
  ShaderSource get materialBaseColor => _sources[ShaderName.material_base_color.toString()];
  ShaderSource get materialBaseVertexColor => _sources[ShaderName.material_base_vertex_color.toString()];
  ShaderSource get materialBaseTexture =>  _sources[ShaderName.material_base_texture.toString()];
  ShaderSource get materialDepthTexture => _sources[ShaderName.material_depth_texture.toString()];
  ShaderSource get materialBaseTextureNormal => _sources[ShaderName.material_base_texture_normal.toString()];
  ShaderSource get materialPBR => _sources[ShaderName.material_pbr.toString()];
  ShaderSource get materialSkybox => _sources[ShaderName.material_skybox.toString()];
  ShaderSource get materialReflection => _sources[ShaderName.material_reflection.toString()];
  ShaderSource get kronosGltfPBR => _sources[ShaderName.kronos_gltf_pbr.toString()];
  ShaderSource get kronosGltfPBRTest =>  _sources[ShaderName.kronos_gltf_pbr_test.toString()];
  ShaderSource get kronosGltfDefault => _sources[ShaderName.kronos_gltf_default.toString()];
  ShaderSource get debugShader => _sources[ShaderName.debug_shader.toString()];
  ShaderSource get sao => _sources[ShaderName.sao.toString()];
  ShaderSource get dotScreen => _sources[ShaderName.dot_screen.toString()];

  List<ShaderInfos> _shadersInfos = [
    new ShaderInfos(
        ShaderName.material_point.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_point/material_point.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_point/material_point.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_base.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_base/material_base.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_base/material_base.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_base_color.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_base_color/material_base_color.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_base_color/material_base_color.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_base_vertex_color.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_base_vertex_color/material_base_vertex_color.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_base_vertex_color/material_base_vertex_color.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_base_texture.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_base_texture/material_base_texture.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_base_texture/material_base_texture.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_depth_texture.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_depth_texture/material_depth_texture.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_depth_texture/material_depth_texture.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_base_texture_normal.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_base_texture_normal/material_base_texture_normal.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_base_texture_normal/material_base_texture_normal.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_pbr.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_pbr/material_pbr.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_pbr/material_pbr.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_skybox.toString(),
        new Uri.file(
            'packages/webgl/shaders/material_skybox/material_skybox.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/material_skybox/material_skybox.fs.glsl')),
    new ShaderInfos(
        ShaderName.material_reflection.toString(),
        new Uri.file('packages/webgl/shaders/reflection/reflection.vs.glsl'),
        new Uri.file('packages/webgl/shaders/reflection/reflection.fs.glsl')),
    new ShaderInfos(
        ShaderName.kronos_gltf_pbr.toString(),
        new Uri.file(
            'packages/webgl/shaders/kronos_gltf/kronos_gltf_pbr.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/kronos_gltf/kronos_gltf_pbr.fs.glsl')),
    new ShaderInfos(
        ShaderName.kronos_gltf_pbr_test.toString(),
        new Uri.file(
            'packages/webgl/shaders/kronos_gltf/kronos_gltf_pbr_test.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/kronos_gltf/kronos_gltf_pbr_test.fs.glsl')),
    new ShaderInfos(
        ShaderName.kronos_gltf_default.toString(),
        new Uri.file(
            'packages/webgl/shaders/kronos_gltf/kronos_gltf_default.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/kronos_gltf/kronos_gltf_default.fs.glsl')),
    new ShaderInfos(
        ShaderName.debug_shader.toString(),
        new Uri.file(
            'packages/webgl/shaders/debug_shader/debug_shader.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/debug_shader/debug_shader.fs.glsl')),
    new ShaderInfos(
        ShaderName.sao.toString(),
        new Uri.file('packages/webgl/shaders/sao/sao.vs.glsl'),
        new Uri.file('packages/webgl/shaders/sao/sao.fs.glsl')),

    //> Filters
    new ShaderInfos(
        ShaderName.dot_screen.toString(),
        new Uri.file(
            'packages/webgl/shaders/filters/dot_screen/dot_screen.vs.glsl'),
        new Uri.file(
            'packages/webgl/shaders/filters/dot_screen/dot_screen.fs.glsl'))
  ];

  Future loadAll() async {
    ShaderSourceLoader shaderSourceLoader = new ShaderSourceLoader();
    List<ShaderSource> shaderSources =
        await shaderSourceLoader.loadAll(_shadersInfos);
    for (ShaderSource shaderSource in shaderSources) {
      _sources[shaderSource.name] = shaderSource;
    }
  }
}