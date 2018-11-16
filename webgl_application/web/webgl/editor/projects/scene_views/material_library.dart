import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/light/light.dart';

class MaterialLibrary {

  String cubeMapName = 'pisa';

  WebGLTexture get cubeMapTexture => _cubeMapTexture ?? (throw 'load ressource first');

  MaterialSkyBox _materialSkyBox;
  MaterialSkyBox get materialSkyBox => _materialSkyBox ??= new MaterialSkyBox()
    ..skyboxTexture = cubeMapTexture;

  MaterialPoint _matrerialPoint;
  MaterialPoint get matrerialPoint => _matrerialPoint ??= new MaterialPoint(pointSize:10.0, color:new Vector4(0.0, 0.66, 1.0, 1.0));

  MaterialBase _materialBase;
  MaterialBase get materialBase => _materialBase ??= new MaterialBase();

  MaterialBaseColor _materialBaseColor;
  MaterialBaseColor get materialBaseColor => _materialBaseColor ??= new MaterialBaseColor(new Vector4(1.0, 0.0, 0.0, 1.0));

  MaterialBaseVertexColor _materialBaseVertexColor;
  MaterialBaseVertexColor get materialBaseVertexColor => _materialBaseVertexColor ??= new MaterialBaseVertexColor();

  MaterialReflection _materialReflection;
  MaterialReflection get materialReflection => _materialReflection ??= new MaterialReflection()..skyboxTexture = cubeMapTexture;

  MaterialLibrary();

  Future loadRessources() async{
    await _getCubeMapTexture(cubeMapName);

    AmbientLight ambientLight = new AmbientLight()
      ..color = new Vector3(1.0,1.0,1.0);
    DirectionalLight directionalLight = new DirectionalLight()
      ..direction = new Vector3(-0.25,-0.125,-0.25)
      ..color = new Vector3(0.8, 0.8, 0.8);

    PointLight pointLight = new PointLight()
      ..color.setFrom(directionalLight.color)
      ..translation = new Vector3(20.0, 20.0, 20.0);

    bool useLighting = true;

    Uri uriImage = new Uri.file("./projects/images/uv_grid.jpg");
    ImageElement imageUV = await TextureUtils.loadImage(uriImage.path);
    WebGLTexture texture = await TextureUtils.createTexture2DFromImageElement(imageUV)
      ..textureWrapS = TextureWrapType.REPEAT
      ..textureWrapT = TextureWrapType.REPEAT;
  }

  WebGLTexture _cubeMapTexture;
  Future<WebGLTexture> _getCubeMapTexture(String cubeMapName) async {
    if(_cubeMapTexture == null) {
      List<List<ImageElement>> cubeMapImages =
      await TextureUtils.loadCubeMapImages(cubeMapName);
      _cubeMapTexture =
          TextureUtils.createCubeMapFromImages(cubeMapImages, flip: false);
    }
    return _cubeMapTexture;
  }

  RawMaterial get testRawMaterial {
    RawMaterial material;

//  material = new MaterialBaseTexture()..texture = texture;

    // Todo (jpu) : ok, but test changing lights
//  material = new MaterialBaseTextureNormal()
//    ..texture = texture
//    ..ambientColor = ambientLight.color
//    ..directionalLight = directionalLight
//    ..useLighting = useLighting;

//  material = new MaterialDepthTexture();// Todo (jpu) : test this
    // Todo (jpu) : see console : WebGL: INVALID_OPERATION: useProgram: program not valid
//  material = new MaterialPragmaticPBR(pointLight);
//  material = new MaterialDotScreen();// Todo (jpu) : test this
//  material = new MaterialSAO();// Todo (jpu) : test this

    return material;
  }

  GLTFPBRMaterial _baseMaterial;
  GLTFPBRMaterial get gLTFPBRMaterial => _baseMaterial ??= new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: null,//GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );
//  project.materials.add(baseMaterial);
}