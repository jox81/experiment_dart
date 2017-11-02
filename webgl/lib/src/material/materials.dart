import 'package:webgl/src/context.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/material.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(targets: const [
  MaterialType,
  Materials,
  SetShaderVariables,
  MaterialCustom,
  MaterialPoint,
  MaterialBase,
  MaterialBaseColor,
  MaterialBaseVertexColor,
  MaterialBaseTexture,
  MaterialBaseTextureNormal,
  MaterialPBR,
  MaterialDepthTexture,
  MaterialSkyBox,
  MaterialReflection,
], override: '*')
import 'dart:mirrors';

enum MaterialType {
  MaterialCustom,
  MaterialPoint,
  MaterialBase,
  MaterialBaseColor,
  MaterialBaseVertexColor,
  MaterialBaseTexture,
  MaterialBaseTextureNormal,
  MaterialPBR,
  MaterialDepthTexture,
  MaterialSkyBox,
  MaterialReflection
}

class Materials{
  static void assignMaterialTypeToModel(MaterialType materialType, Model model) {
    switch(materialType){
//      case MaterialType.MaterialCustom:
//        newMaterial = new MaterialCustom();
//        break;
      case MaterialType.MaterialPoint:
        model
          ..mesh.mode = DrawMode.POINTS
          ..material = new MaterialPoint(pointSize:5.0, color:new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBase:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialBase();
        break;
      case MaterialType.MaterialBaseColor:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialBaseColor(new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBaseVertexColor:
        MaterialBaseVertexColor material = new MaterialBaseVertexColor();
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = material;
        break;
      case MaterialType.MaterialBaseTexture:
        WebGLTexture texture = TextureUtils.getDefaultColoredTexture();
        MaterialBaseTexture material = new MaterialBaseTexture()
          ..texture = texture;
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = material;
        break;
      case MaterialType.MaterialBaseTextureNormal:
        WebGLTexture texture = TextureUtils.getDefaultColoredTexture();
        MaterialBaseTextureNormal material = new MaterialBaseTextureNormal()
          ..texture = texture;
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = material;
        break;
      case MaterialType.MaterialPBR:
        PointLight light = new PointLight();
        MaterialPBR material = new MaterialPBR(light);
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = material;
        break;
      case MaterialType.MaterialDepthTexture:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialDepthTexture();
        break;
      case MaterialType.MaterialSkyBox:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialSkyBox();
        break;
      case MaterialType.MaterialReflection:
        model
          ..mesh.mode = DrawMode.TRIANGLES
          ..material = new MaterialReflection();
        break;
      default:
        break;
    }
  }
}
typedef void SetShaderVariables(Model model);

class MaterialCustom extends Material {

  SetShaderVariables setShaderAttributsVariables;
  SetShaderVariables setShaderUniformsVariables;

  MaterialCustom(String vsSource, String fsSource)
      : super(vsSource, fsSource);

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
  num pointSize;
  Vector4 color;

  MaterialPoint._internal(
      String vsSource, String fsSource, this.pointSize, this.color)
      : super(vsSource, fsSource);

  factory MaterialPoint({num pointSize: 1.0, Vector4 color}) {
    ShaderSource shaderSource = ShaderSource.sources['material_point'];
    return new MaterialPoint._internal(
        shaderSource.vsCode, shaderSource.fsCode, pointSize, color);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);

    if (color == null) {
      setShaderAttributArrayBuffer(
          'aVertexColor', model.mesh.colors, model.mesh.colorDimensions);
    } else {
      setShaderAttributData('aVertexColor', color);
    }
  }

  setShaderUniforms(Model model) {
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);
    setShaderUniform(
        "uProjectionMatrix", Context.mainCamera.projectionMatrix);
    setShaderUniform("pointSize", pointSize);
  }
}

class MaterialBase extends Material {

  MaterialBase._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBase() {
    ShaderSource shaderSource = ShaderSource.sources['material_base'];
    return new MaterialBase._internal(shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);
  }

  setShaderUniforms(Model model) {
    setShaderUniform("uModelMatrix", Context.modelMatrix);
    setShaderUniform("uViewMatrix", Context.mainCamera.viewMatrix);
//    print('#');
//    logInfo("uViewMatrix-", Context.mainCamera.lookAtMatrix);
//    logInfo("uViewMatrix*", Context.mainCamera.lookAtMatrix * new Matrix4.identity());

    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);
    setShaderUniform("uProjectionMatrix", Context.mainCamera.projectionMatrix);
  }
}

void logInfo(String name, dynamic value){
  print('$name : $value');
}

class MaterialBaseColor extends Material {

  //External Parameters
  Vector4 color;

  MaterialBaseColor._internal(String vsSource, String fsSource, this.color)
      : super(vsSource, fsSource);

  factory MaterialBaseColor(Vector4 color) {
    ShaderSource shaderSource = ShaderSource.sources['material_base_color'];
    return new MaterialBaseColor._internal(
        shaderSource.vsCode, shaderSource.fsCode, color);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);
  }

  setShaderUniforms(Model model) {
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);
    setShaderUniform(
        "uProjectionMatrix", Context.mainCamera.projectionMatrix);
    setShaderUniform("uColor", color.storage);
  }
}

class MaterialBaseVertexColor extends Material {

  MaterialBaseVertexColor._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBaseVertexColor() {
    ShaderSource shaderSource =
        ShaderSource.sources['material_base_vertex_color'];
    return new MaterialBaseVertexColor._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);

    if(model.mesh.colors.length == 0){
      print('No colors data defined for : ${model.name}:${model.modelType}');
      model.mesh.colors = new List<double>.generate((model.mesh.vertexCount * model.mesh.colorDimensions).toInt(), (i)=> 1.0 );
    }
    setShaderAttributArrayBuffer(
        'aVertexColor', model.mesh.colors, model.mesh.colorDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);
    setShaderUniform(
        "uProjectionMatrix", Context.mainCamera.projectionMatrix);
  }
}

class MaterialBaseTexture extends Material {

  //External parameters
  WebGLTexture texture;

  MaterialBaseTexture._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBaseTexture() {
    ShaderSource shaderSource = ShaderSource.sources['material_base_texture'];
    return new MaterialBaseTexture._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);

    //textureCoords
    List<double> coords =
        model.mesh.textureCoords.length > 0 ? model.mesh.textureCoords : null;
    if (coords == null)
      print(
          '### MaterialBaseTexture : No textureCoords in the mesh of Model type : ${model.runtimeType}');
    setShaderAttributArrayBuffer(
        'aTextureCoord', coords, model.mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Model model) {

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.texture2d.bind(texture);

    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);
    setShaderUniform(
        "uProjectionMatrix", Context.mainCamera.projectionMatrix);
    setShaderUniform('uSampler', 0);
    setShaderUniform('uTextureMatrix', texture?.textureMatrix);
  }
}

class MaterialBaseTextureNormal extends Material {

  //External Parameters
  WebGLTexture texture;
  Vector3 ambientColor = new Vector3.all(1.0);
  DirectionalLight directionalLight;
  bool useLighting = false;

  MaterialBaseTextureNormal._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialBaseTextureNormal() {
    ShaderSource shaderSource =
        ShaderSource.sources['material_base_texture_normal'];
    return new MaterialBaseTextureNormal._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.texture2d.bind(texture);
    setShaderAttributArrayBuffer('aTextureCoord', model.mesh.textureCoords,
        model.mesh.textureCoordsDimensions);

    setShaderAttributArrayBuffer('aVertexNormal', model.mesh.vertexNormals,
        model.mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);
    setShaderUniform(
        "uProjectionMatrix", Context.mainCamera.projectionMatrix);

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix = (Context.mainCamera.viewMatrix * Context.modelMatrix).getNormalMatrix() as Matrix3;
    setShaderUniform("uNormalMatrix", normalMatrix);

    //Light

    // draw lighting?
    setShaderUniform(
        "uUseLighting", useLighting ? 1 : 0); // must be int, not bool

    if (useLighting) {
      setShaderUniform(
          "uAmbientColor", ambientColor.r, ambientColor.g, ambientColor.b);

      Vector3 adjustedLD = new Vector3.zero();
      directionalLight.direction.normalizeInto(adjustedLD);
      adjustedLD.scale(-1.0);

      //Float32List f32LD = new Float32List(3);
      //adjustedLD.copyIntoArray(f32LD);
      //_gl.uniform3fv(_uLightDirection, f32LD);

      setShaderUniform(
          "uLightingDirection", adjustedLD.x, adjustedLD.y, adjustedLD.z);

      setShaderUniform("uDirectionalColor", directionalLight.color.r,
          directionalLight.color.g, directionalLight.color.b);
    }
  }
}

///PBR's
///http://marcinignac.com/blog/pragmatic-pbr-setup-and-gamma/
///module explained can be found here : https://github.com/vorg/pragmatic-pbr/tree/master/local_modules
///base
class MaterialPBR extends Material {

  //External Parameters
  PointLight pointLight;

  MaterialPBR._internal(String vsSource, String fsSource, this.pointLight)
      : super(vsSource, fsSource);

  factory MaterialPBR(PointLight pointLight) {
    ShaderSource shaderSource = ShaderSource.sources['material_pbr'];
    return new MaterialPBR._internal(
        shaderSource.vsCode, shaderSource.fsCode, pointLight);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);

    if(model.mesh.vertexNormals.length == 0){
      print('No vertexNormals data defined for : ${model.name}:${model.modelType}');
      model.mesh.colors = new List<double>.generate((model.mesh.vertexCount * model.mesh.vertexNormalsDimensions).toInt(), (i)=> 1.0 );
    }
    setShaderAttributArrayBuffer('aNormal', model.mesh.vertexNormals,
        model.mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);
    setShaderUniform(
        "uProjectionMatrix", Context.mainCamera.projectionMatrix);

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix = (Context.mainCamera.viewMatrix * Context.modelMatrix).getNormalMatrix() as Matrix3;
    setShaderUniform("uNormalMatrix", normalMatrix);

    setShaderUniform("uLightPos", pointLight.position.storage);
  }
}

class MaterialDepthTexture extends Material {

  //External parameters
  WebGLTexture texture;

  num near = 1.0;
  num far = 1000.0;

  MaterialDepthTexture._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialDepthTexture() {
    ShaderSource shaderSource = ShaderSource.sources['material_depth_texture'];
    return new MaterialDepthTexture._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.texture2d.bind(texture);
    setShaderAttributArrayBuffer('aTextureCoord', model.mesh.textureCoords,
        model.mesh.textureCoordsDimensions);
  }

  setShaderUniforms(Model model) {
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);

    setShaderUniform(
        "uProjectionMatrix", Context.mainCamera.projectionMatrix);

    setShaderUniform('uSampler', 0);

    setShaderUniform('near', near);
    setShaderUniform('far', far);
  }
}

class MaterialSkyBox extends Material {

  //External parameters
  WebGLTexture skyboxTexture;

  MaterialSkyBox._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialSkyBox() {
    ShaderSource shaderSource = ShaderSource.sources['material_skybox'];
    return new MaterialSkyBox._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);
  }

  setShaderUniforms(Model model) {
    //removing skybox transform
    setShaderUniform("uModelMatrix", new Matrix4.identity());

    //removing camera translation
    Matrix3 m3 = Context.mainCamera.viewMatrix.getRotation();
    Matrix4 m4 = new Matrix4.identity()..setRotation(m3);
    setShaderUniform("uViewMatrix", m4);

    setShaderUniform("uProjectionMatrix", Context.mainCamera.projectionMatrix);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.textureCubeMap.bind(skyboxTexture);
    setShaderUniform('uEnvMap', 0);
  }

  setupBeforeRender(){
    gl.depthTest = false;
  }
  setupAfterRender(){
    gl.depthTest = true;
  }

}

class MaterialReflection extends Material {

  //External parameters
  WebGLTexture skyboxTexture;

  MaterialReflection._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialReflection() {
    ShaderSource shaderSource = ShaderSource.sources['material_reflection'];
    return new MaterialReflection._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);
    setShaderAttributArrayBuffer('aNormal', model.mesh.vertexNormals,
        model.mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Model model) {

//    print("###############");

//    print("uModelMatrix: \n${Context.modelMatrix}");
//    print("uViewMatrix: \n${Context.mainCamera.lookAtMatrix}");
//    setShaderUniform("uModelMatrix", Context.modelMatrix);
//    setShaderUniform("uViewMatrix", Context.mainCamera.lookAtMatrix);
//use in common with vertex shader ?

//    print("uModelViewMatrix: \n${Context.mainCamera.lookAtMatrix * Context.modelMatrix}");
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);


    setShaderUniform("uProjectionMatrix", Context.mainCamera.projectionMatrix);

    setShaderUniform("uInverseViewMatrix",
        new Matrix4.inverted(Context.mainCamera.viewMatrix));

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix = (Context.mainCamera.viewMatrix * Context.modelMatrix).getNormalMatrix() as Matrix3;
    setShaderUniform("uNormalMatrix", normalMatrix);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.textureCubeMap.bind(skyboxTexture);
    setShaderUniform('uEnvMap', 0);
  }
}

//Todo
class MaterialNormalMapping extends Material {

  //External parameters
  WebGLTexture skyboxTexture;

  MaterialNormalMapping._internal(String vsSource, String fsSource)
      : super(vsSource, fsSource);

  factory MaterialNormalMapping() {
    ShaderSource shaderSource = ShaderSource.sources['material_reflection'];
    return new MaterialNormalMapping._internal(
        shaderSource.vsCode, shaderSource.fsCode);
  }

  setShaderAttributs(Model model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);
    setShaderAttributArrayBuffer('aNormal', model.mesh.vertexNormals,
        model.mesh.vertexNormalsDimensions);
  }

  setShaderUniforms(Model model) {

//    print("###############");

//    print("uModelMatrix: \n${Context.modelMatrix}");
//    print("uViewMatrix: \n${Context.mainCamera.lookAtMatrix}");
//    setShaderUniform("uModelMatrix", Context.modelMatrix);
//    setShaderUniform("uViewMatrix", Context.mainCamera.lookAtMatrix);
//use in common with vertex shader ?

//    print("uModelViewMatrix: \n${Context.mainCamera.lookAtMatrix * Context.modelMatrix}");
    setShaderUniform("uModelViewMatrix", Context.mainCamera.viewMatrix * Context.modelMatrix);


    setShaderUniform("uProjectionMatrix", Context.mainCamera.projectionMatrix);

    setShaderUniform("uInverseViewMatrix",
        new Matrix4.inverted(Context.mainCamera.viewMatrix));

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix = (Context.mainCamera.viewMatrix * Context.modelMatrix).getNormalMatrix() as Matrix3;
    setShaderUniform("uNormalMatrix", normalMatrix);

    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.textureCubeMap.bind(skyboxTexture);
    setShaderUniform('uEnvMap', 0);
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
