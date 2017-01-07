import 'package:webgl/src/context.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/meshes.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

typedef void SetShaderVariables(Mesh mesh);

class MaterialCustom extends Material {

  final List<String> buffersNames;

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
  num pointSize;
  Vector4 color;

  MaterialPoint._internal(String vsSource, String fsSource, this.pointSize, this.color)
      : super(vsSource, fsSource);

  factory MaterialPoint({num pointSize:1.0,Vector4 color:null}){
    ShaderSource shaderSource = ShaderSource.sources['material_point'];
    return new MaterialPoint._internal(shaderSource.vsCode, shaderSource.fsCode, pointSize, color);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName(
        'aVertexColor',
        arrayBuffer: color == null ? mesh.colors : null,
        data: color,
        dimension : mesh.colorDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Context.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Context.mainCamera.vpMatrix.storage);
    setShaderUniformWithName("pointSize", pointSize);
  }
}

class MaterialBase extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialBase._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBase(){
    ShaderSource shaderSource = ShaderSource.sources['material_base'];
    return new MaterialBase._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer : mesh.indices);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Context.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Context.mainCamera.vpMatrix.storage);
  }
}

class MaterialBaseColor extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  //External Parameters
  Vector4 color;

  MaterialBaseColor._internal(String vsSource, String fsSource, this.color)
      : super(vsSource, fsSource);

  factory MaterialBaseColor(Vector4 color){
    ShaderSource shaderSource = ShaderSource.sources['material_base_color'];
    return new MaterialBaseColor._internal(shaderSource.vsCode, shaderSource.fsCode, color);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer:  mesh.indices);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Context.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Context.mainCamera.vpMatrix.storage);
    setShaderUniformWithName("uColor", color.storage);
  }
}

class MaterialBaseVertexColor extends Material {

 final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aVertexColor'];

  MaterialBaseVertexColor._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

 factory MaterialBaseVertexColor(){
   ShaderSource shaderSource = ShaderSource.sources['material_base_vertex_color'];
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
        "uMVMatrix", Context.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Context.mainCamera.vpMatrix.storage);
  }
}

class MaterialBaseTexture extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aTextureCoord'];

  //External parameters
  WebGLTexture texture;

  MaterialBaseTexture._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBaseTexture(){
    ShaderSource shaderSource = ShaderSource.sources['material_base_texture'];
    return new MaterialBaseTexture._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: mesh.indices);

    gl.activeTexture = TextureUnit.TEXTURE0;
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', arrayBuffer: mesh.textureCoords, dimension : mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Context.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Context.mainCamera.vpMatrix.storage);
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
  WebGLTexture texture;
  Vector3 ambientColor;
  DirectionalLight directionalLight;
  bool useLighting = true;

  MaterialBaseTextureNormal._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBaseTextureNormal(){
    ShaderSource shaderSource = ShaderSource.sources['material_base_texture_normal'];
    return new MaterialBaseTextureNormal._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Mesh mesh) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: mesh.vertices, dimension : mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: mesh.indices);

    gl.activeTexture = TextureUnit.TEXTURE0;
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', arrayBuffer: mesh.textureCoords, dimension : mesh.textureCoordsDimensions);

    setShaderAttributWithName(
        'aVertexNormal', arrayBuffer: mesh.vertexNormals, dimension : mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh mesh) {
    setShaderUniformWithName(
        "uMVMatrix", Context.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Context.mainCamera.vpMatrix.storage);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(Context.mvMatrix);
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
  PointLight pointLight;

  MaterialPBR._internal(String vsSource, String fsSource, this.pointLight)
      : super(vsSource, fsSource);

  factory MaterialPBR(PointLight pointLight){
    ShaderSource shaderSource = ShaderSource.sources['material_pbr'];
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
        "uMVMatrix", Context.mvMatrix.storage);
    setShaderUniformWithName(
        "uPMatrix", Context.mainCamera.vpMatrix.storage);

    setShaderUniformWithName(
        "uNormalMatrix",
        new Matrix4.inverted(Context.mvMatrix)
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