import 'package:webgl/src/material.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/mesh.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/texture_utils.dart';
import 'dart:async';
import 'package:webgl/src/light.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/utils.dart';
import 'dart:web_gl';

typedef void SetShaderVariables(Mesh mesh);

class MaterialCustom extends Material {

  List<String> buffersNames;

  SetShaderVariables setShaderAttributsVariables;
  SetShaderVariables setShaderUniformsVariables;

  MaterialCustom(String vsSource, String fsSource, this.buffersNames): super(vsSource, fsSource);

  @override
  setShaderAttributs(Mesh mesh) {
    setShaderAttributsVariables(mesh);
  }

  @override
  setShaderUniforms(Mesh mesh) {
    setShaderUniformsVariables(mesh);
  }
}

class MaterialPoint extends Material {

  static const String vertexShaderPath = '../shaders/material_point/material_point.vs.glsl';
  static const String fragmentShaderPath = '../shaders/material_point/material_point.fs.glsl';

  final List<String> buffersNames = ['aVertexPosition', 'aVertexColor'];
  final num pointSize;

  MaterialPoint._internal(String vsSource, String fsSource, this.pointSize)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialPoint> create(num pointSize) async {
    String vsCode = await Utils
        .loadGlslShader(vertexShaderPath);
    String fsCode = await Utils
        .loadGlslShader(fragmentShaderPath);
    return new MaterialPoint._internal(vsCode, fsCode, pointSize);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName(
        'aVertexColor', mesh.colors, mesh.colorDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
    setShaderUniformWithName("pointSize", pointSize);
  }
}

class MaterialBase extends Material {

  static const String vertexShaderPath = '../shaders/material_base/material_base.vs.glsl';
  static const String fragmentShaderPath = '../shaders/material_base/material_base.fs.glsl';

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialBase._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialBase> create() async {
    String vsCode = await Utils
        .loadGlslShader(vertexShaderPath);
    String fsCode = await Utils
        .loadGlslShader(fragmentShaderPath);
    return new MaterialBase._internal(vsCode, fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
  }
}

class MaterialBaseColor extends Material {

  static const String vertexShaderPath = '../shaders/material_base_color/material_base_color.vs.glsl';
  static const String fragmentShaderPath = '../shaders/material_base_color/material_base_color.fs.glsl';

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  //External Parameters
  final Vector3 color;

  MaterialBaseColor._internal(String vsSource, String fsSource, this.color)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialBaseColor> create(Vector3 color) async {
    String vsCode = await Utils
        .loadGlslShader(vertexShaderPath);
    String fsCode = await Utils
        .loadGlslShader(fragmentShaderPath);
    return new MaterialBaseColor._internal(vsCode, fsCode, color);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
    setShaderUniformWithName("uColor", color.storage);
  }
}

class MaterialBaseVertexColor extends Material {

  static const String vertexShaderPath = '../shaders/material_base_vertex_color/material_base_vertex_color.vs.glsl';
  static const String fragmentShaderPath = '../shaders/material_base_vertex_color/material_base_vertex_color.fs.glsl';

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aVertexColor'];

  MaterialBaseVertexColor._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialBaseVertexColor> create() async {
    String vsCode = await Utils
        .loadGlslShader(vertexShaderPath);
    String fsCode = await Utils
        .loadGlslShader(fragmentShaderPath);
    return new MaterialBaseVertexColor._internal(vsCode, fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
    setShaderAttributWithName(
        'aVertexColor', mesh.colors, mesh.colorDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
  }
}

class MaterialBaseTexture extends Material {

  static const String vertexShaderPath = '../shaders/material_base_texture/material_base_texture.vs.glsl';
  static const String fragmentShaderPath = '../shaders/material_base_texture/material_base_texture.fs.glsl';

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aTextureCoord'];

  //External parameters
  Texture texture;

  MaterialBaseTexture._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialBaseTexture> create() async {
    String vsCode = await Utils
        .loadGlslShader(vertexShaderPath);
    String fsCode = await Utils
        .loadGlslShader(fragmentShaderPath);
    return new MaterialBaseTexture._internal(vsCode, fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);

    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', mesh.textureCoords, mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);
    setShaderUniformWithName('uSampler', 0);
  }

}

class MaterialBaseTextureNormal extends Material {

  static const String vertexShaderPath = '../shaders/material_base_texture_normal/material_base_texture_normal.vs.glsl';
  static const String fragmentShaderPath = '../shaders/material_base_texture_normal/material_base_texture_normal.fs.glsl';

  final buffersNames = [
    'aVertexPosition',
    'aVertexIndice',
    'aTextureCoord',
    'aVertexNormal'
  ];

  //External Parameters
  Texture texture;
  Vector3 ambientColor;
  DirectionalLight directionalLight;
  bool useLighting = true;

  MaterialBaseTextureNormal._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialBaseTextureNormal> create() async {
    String vsCode = await Utils
        .loadGlslShader(vertexShaderPath);
    String fsCode = await Utils
        .loadGlslShader(fragmentShaderPath);
    return new MaterialBaseTextureNormal._internal(vsCode, fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);

    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', mesh.textureCoords, mesh.textureCoordsDimensions);

    setShaderAttributWithName(
        'aVertexNormal', mesh.vertexNormals, mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(Application.instance.mvMatrix);
    Matrix3 normalMatrix = mvInverse.getRotation();

    normalMatrix.transpose();
    setShaderUniformWithName("uNMatrix", normalMatrix.storage);

    //Light

    // draw lighting?
    setShaderUniformWithName(
        "uUseLighting", useLighting ? 1 : 0); // must be int, not bool

    if (useLighting) {
      setShaderUniformWithName(
          "uAmbientColor", ambientColor.r, ambientColor.g, ambientColor.b);

      Vector3 adjustedLD = new Vector3.zero();
      directionalLight.direction.normalizeInto(adjustedLD);
      adjustedLD.scale(-1.0);

      //Float32List f32LD = new Float32List(3);
      //adjustedLD.copyIntoArray(f32LD);
      //_gl.uniform3fv(_uLightDirection, f32LD);

      setShaderUniformWithName(
          "uLightingDirection", adjustedLD.x, adjustedLD.y, adjustedLD.z);

      setShaderUniformWithName("uDirectionalColor", directionalLight.color.r,
          directionalLight.color.g, directionalLight.color.b);
    }
  }
}

///PBR's
///http://marcinignac.com/blog/pragmatic-pbr-setup-and-gamma/
///base
class MaterialPBR extends Material {

  static const String vertexShaderPath = '../shaders/material_pbr/material_pbr.vs.glsl';
  static const String fragmentShaderPath = '../shaders/material_pbr/material_pbr.fs.glsl';

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aNormal'];

  //External Parameters
  final PointLight pointLight;

  MaterialPBR._internal(String vsSource, String fsSource, this.pointLight)
      : super(vsSource, fsSource);
  //>>
  static Future<MaterialPBR> create(PointLight pointLight) async {
    String vsCode = await Utils
        .loadGlslShader(vertexShaderPath);
    String fsCode = await Utils
        .loadGlslShader(fragmentShaderPath);
    return new MaterialPBR._internal(vsCode, fsCode, pointLight);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', mesh.indices, null);
    setShaderAttributWithName(
        'aNormal', mesh.vertexNormals, mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Application.instance.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Application.instance.mainCamera.matrix.storage);

    setShaderUniformWithName(
        "uNormalMatrix",
        new Matrix4.inverted(Application.instance.mvMatrix)
            .transposed()
            .getRotation()
            .storage);
    setShaderUniformWithName("uLightPos", pointLight.position.storage);
  }
}

/*
//Loading glsl files....
  //may be used to load code async
  -1-

  MaterialPBR._internal(String vsSource, String fsSource, this.pointLight) : super(vsSource, fsSource);
  //>>
  static Future<MaterialPBR> create(PointLight pointLight)async {
    String vsCode = await Utils.loadGlslShader('../shaders/material_pbr/material_pbr.vs.glsl');
    String fsCode = await Utils.loadGlslShader('../shaders/material_pbr/material_pbr.fs.glsl');
    return new MaterialPBR._internal(vsCode, fsCode, pointLight);
  }

  >> but need to change creation time to :
  MaterialPBR materialPBR = await MaterialPBR.create(pointLight);


  //Or use sync getter
  -2-

  static String get vsCode {
    return Utils.loadGlslShaderSync('../shaders/material_pbr/material_pbr.vs.glsl');
  }

  static String get fsCode {
    return Utils.loadGlslShaderSync('../shaders/material_pbr/material_pbr.fs.glsl');
  }

  MaterialPBR(this.pointLight) : super(vsCode, fsCode);

  >> But have warning message:
  Synchronous XMLHttpRequest on the main thread is deprecated because of its detrimental effects to the end user's experience. For more help, check http://xhr.spec.whatwg.org/.

 */