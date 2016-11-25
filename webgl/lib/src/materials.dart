import 'package:webgl/src/material.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/mesh.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:async';
import 'package:webgl/src/light.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/utils.dart';
import 'dart:web_gl';
import 'package:webgl/src/utils_shader.dart';

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

  final List<String> buffersNames = ['aVertexPosition', 'aVertexColor'];
  final num pointSize;

  MaterialPoint._internal(String vsSource, String fsSource, this.pointSize)
      : super(vsSource, fsSource);

  factory MaterialPoint(num pointSize){
    ShaderSource shaderSource = Application.shadersSources['material_point'];
    return new MaterialPoint._internal(shaderSource.vsCode, shaderSource.fsCode, pointSize);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName(
        'aVertexColor', arrayBuffer:  mesh.colors, dimension : mesh.colorDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", scene.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", scene.mainCamera.vpMatrix.storage);
    setShaderUniformWithName("pointSize", pointSize);
  }
}

class MaterialBase extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialBase._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBase(){
    ShaderSource shaderSource = Application.shadersSources['material_base'];
    return new MaterialBase._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer : mesh.indices);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", scene.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", scene.mainCamera.vpMatrix.storage);
  }
}

class MaterialBaseColor extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  //External Parameters
  final Vector3 color;

  MaterialBaseColor._internal(String vsSource, String fsSource, this.color)
      : super(vsSource, fsSource);

  factory MaterialBaseColor(Vector3 color){
    ShaderSource shaderSource = Application.shadersSources['material_base_color'];
    return new MaterialBaseColor._internal(shaderSource.vsCode, shaderSource.fsCode, color);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer:  mesh.indices);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", scene.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", scene.mainCamera.vpMatrix.storage);
    setShaderUniformWithName("uColor", color.storage);
  }
}

class MaterialBaseVertexColor extends Material {

 final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aVertexColor'];

  MaterialBaseVertexColor._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

 factory MaterialBaseVertexColor(){
   ShaderSource shaderSource = Application.shadersSources['material_base_vertex_color'];
   return new MaterialBaseVertexColor._internal(shaderSource.vsCode, shaderSource.fsCode);
 }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: mesh.indices);
    setShaderAttributWithName(
        'aVertexColor', arrayBuffer: mesh.colors, dimension : mesh.colorDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", scene.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", scene.mainCamera.vpMatrix.storage);
  }
}

class MaterialBaseTexture extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aTextureCoord'];

  //External parameters
  Texture texture;

  MaterialBaseTexture._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBaseTexture(){
    ShaderSource shaderSource = Application.shadersSources['material_base_texture'];
    return new MaterialBaseTexture._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: mesh.indices);

    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', arrayBuffer: mesh.textureCoords, dimension : mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", scene.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", scene.mainCamera.vpMatrix.storage);
    setShaderUniformWithName('uSampler', 0);
  }

}

class MaterialBaseTextureNormal extends Material {

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

  factory MaterialBaseTextureNormal(){
    ShaderSource shaderSource = Application.shadersSources['material_base_texture_normal'];
    return new MaterialBaseTextureNormal._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: mesh.indices);

    gl.activeTexture(GL.TEXTURE0);
    gl.bindTexture(GL.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', arrayBuffer: mesh.textureCoords, dimension : mesh.textureCoordsDimensions);

    setShaderAttributWithName(
        'aVertexNormal', arrayBuffer: mesh.vertexNormals, dimension : mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", scene.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", scene.mainCamera.vpMatrix.storage);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(scene.mvMatrix);
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

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aNormal'];

  //External Parameters
  final PointLight pointLight;

  MaterialPBR._internal(String vsSource, String fsSource, this.pointLight)
      : super(vsSource, fsSource);

  factory MaterialPBR(PointLight pointLight){
    ShaderSource shaderSource = Application.shadersSources['material_pbr'];
    return new MaterialPBR._internal(shaderSource.vsCode, shaderSource.fsCode, pointLight);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: mesh.indices);
    setShaderAttributWithName(
        'aNormal', arrayBuffer: mesh.vertexNormals, dimension : mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", scene.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", scene.mainCamera.vpMatrix.storage);

    setShaderUniformWithName(
        "uNormalMatrix",
        new Matrix4.inverted(scene.mvMatrix)
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