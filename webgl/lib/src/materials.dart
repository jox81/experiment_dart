import 'package:webgl/src/context.dart';
import 'package:webgl/src/material.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

typedef void SetShaderVariables(Model model);

class MaterialCustom extends Material {

  final List<String> buffersNames;

  SetShaderVariables setShaderAttributsVariables;
  SetShaderVariables setShaderUniformsVariables;

  MaterialCustom(String vsSource, String fsSource, this.buffersNames): super(vsSource, fsSource);

  @override
  setShaderAttributs(Model model) {
    setShaderAttributsVariables(model);
  }

  @override
  setShaderUniforms(Model model) {
    setShaderUniformsVariables(model);
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

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName(
        'aVertexColor',
        arrayBuffer: color == null ? model.mesh.colors : null,
        data: color,
        dimension : model.mesh.colorDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);
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

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer : model.mesh.indices);
  }

  setShaderUniforms(Model model) {

    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);
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

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer:  model.mesh.indices);
  }

  setShaderUniforms(Model model) {
    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);
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

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: model.mesh.indices);
    setShaderAttributWithName(
        'aVertexColor', arrayBuffer: model.mesh.colors, dimension : model.mesh.colorDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);
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

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: model.mesh.indices);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', arrayBuffer: model.mesh.textureCoords, dimension : model.mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);
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

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: model.mesh.indices);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', arrayBuffer: model.mesh.textureCoords, dimension : model.mesh.textureCoordsDimensions);

    setShaderAttributWithName(
        'aVertexNormal', arrayBuffer: model.mesh.vertexNormals, dimension : model.mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(Context.modelViewMatrix);
    Matrix3 normalMatrix = mvInverse.getRotation();

    normalMatrix.transpose();
    setShaderUniformWithName("uNormalMatrix", normalMatrix);

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
///module explained can be found here : https://github.com/vorg/pragmatic-pbr/tree/master/local_modules
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

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: model.mesh.indices);
    setShaderAttributWithName(
        'aNormal', arrayBuffer: model.mesh.vertexNormals, dimension : model.mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);

    setShaderUniformWithName(
        "uNormalMatrix",
        new Matrix4.inverted(Context.modelViewMatrix)
            .transposed()
            .getRotation());
    setShaderUniformWithName("uLightPos", pointLight.position.storage);
  }
}

class MaterialDepthTexture extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aTextureCoord'];

  //External parameters
  WebGLTexture texture;

  MaterialDepthTexture._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialDepthTexture(){
    ShaderSource shaderSource = ShaderSource.sources['material_depth_texture'];
    return new MaterialDepthTexture._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: model.mesh.indices);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);
    setShaderAttributWithName(
        'aTextureCoord', arrayBuffer: model.mesh.textureCoords, dimension : model.mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniformWithName(
        "uModelViewMatrix", Context.modelViewMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.vpMatrix);
    setShaderUniformWithName('uSampler', 0);
  }

}

class MaterialSkyBox extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice'];

  //External parameters
  WebGLTexture skyboxTexture;

  MaterialSkyBox._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialSkyBox(){
    ShaderSource shaderSource = ShaderSource.sources['material_skybox'];
    return new MaterialSkyBox._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: model.mesh.indices);
  }

  setShaderUniforms(Model model) {

    //removing skybox transform
    setShaderUniformWithName(
        "uModelMatrix", new Matrix4.identity());

    //removing camera translation
    Matrix3 m3 = Context.mainCamera.lookAtMatrix.getRotation();
    Matrix4 m4 = new Matrix4.identity()..setRotation(m3);
    setShaderUniformWithName(
        "uViewMatrix", m4);

    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.perspectiveMatrix);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(Context.modelViewMatrix);
    Matrix3 normalMatrix = mvInverse.getRotation();

    normalMatrix.transpose();
    setShaderUniformWithName("uNormalMatrix", normalMatrix);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.bind(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture);
    setShaderUniformWithName('uEnvMap', 0);
  }

}

class MaterialReflection extends Material {

  final buffersNames = ['aVertexPosition', 'aVertexIndice', 'aNormal'];

  //External parameters
  WebGLTexture skyboxTexture;

  MaterialReflection._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialReflection(){
    ShaderSource shaderSource = ShaderSource.sources['material_reflection'];
    return new MaterialReflection._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributWithName(
        'aVertexPosition', arrayBuffer: model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    setShaderAttributWithName('aVertexIndice', elemetArrayBuffer: model.mesh.indices);
    setShaderAttributWithName(
        'aNormal', arrayBuffer: model.mesh.vertexNormals, dimension : model.mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Model model) {

    setShaderUniformWithName(
        "uModelMatrix", model.transform);
    setShaderUniformWithName(
        "uViewMatrix", Context.mainCamera.lookAtMatrix);
    setShaderUniformWithName(
        "uProjectionMatrix", Context.mainCamera.perspectiveMatrix);

    //??
    setShaderUniformWithName(
        "uInverseViewMatrix", new Matrix4.inverted(Context.mainCamera.lookAtMatrix) );

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.bind(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture);
    setShaderUniformWithName('uSkybox', 0);
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