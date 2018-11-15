import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/light/light.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart'
    as glEnum;
import 'package:webgl/src/debug/utils_debug.dart' as debug;
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

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

@reflector
class Materials {
  static void assignMaterialTypeToModel(
      MaterialType materialType, GLTFMesh mesh) {
    switch (materialType) {
//      case MaterialType.MaterialCustom:
//        newMaterial = new MaterialCustom();
//        break;
      case MaterialType.MaterialPoint:
        mesh
          ..primitives[0].drawMode = DrawMode.POINTS
          ..primitives[0].material =
              new MaterialPoint(pointSize: 5.0, color: new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBase:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialBase();
        break;
      case MaterialType.MaterialBaseColor:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material =
              new MaterialBaseColor(new Vector4.all(1.0));
        break;
      case MaterialType.MaterialBaseVertexColor:
        MaterialBaseVertexColor material = new MaterialBaseVertexColor();
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialBaseTexture:
        WebGLTexture texture = TextureUtils.getDefaultColoredTexture();
        MaterialBaseTexture material = new MaterialBaseTexture()
          ..texture = texture;
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialBaseTextureNormal:
        WebGLTexture texture = TextureUtils.getDefaultColoredTexture();
        MaterialBaseTextureNormal material = new MaterialBaseTextureNormal()
          ..texture = texture;
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialPBR:
        PointLight light = new PointLight();
        MaterialPragmaticPBR material = new MaterialPragmaticPBR(light);
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = material;
        break;
      case MaterialType.MaterialDepthTexture:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialDepthTexture();
        break;
      case MaterialType.MaterialSkyBox:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialSkyBox();
        break;
      case MaterialType.MaterialReflection:
        mesh
          ..primitives[0].drawMode = DrawMode.TRIANGLES
          ..primitives[0].material = new MaterialReflection();
        break;
      default:
        break;
    }
  }
}

@reflector
abstract class RawMaterial {
  String name;

  Matrix4 pvMatrix = new Matrix4.identity();

  ShaderSource get shaderSource;

  Map<String, bool> _defines;
  Map<String, bool> get defines => _defines ??= getDefines();

  ShaderSource _definedShaderSource;
  ShaderSource get definedShaderSource {
    //debugLog.logCurrentFunction();
    return _definedShaderSource ??= () {
      String shaderDefines = definesToString(defines);
      ShaderSource shaderSourceDefined = new ShaderSource()
        ..vsCode = shaderDefines + shaderSource.vsCode
        ..fsCode = shaderDefines + shaderSource.fsCode;
      return shaderSourceDefined;
    }();
  }

  /// This builds Preprocessors for glsl shader source
  String definesToString(Map<String, bool> defines) {
    //debugLog.logCurrentFunction();
    String outStr = '';
    if (defines == null) return outStr;

    for (String def in defines.keys) {
      if (defines[def]) {
        outStr += '#define $def ${defines[def]}\n';
      }
    }
    return outStr;
  }

  ///Defines glsl preprocessors
  Map<String, bool> getDefines();

  WebGLProgram getProgram() {
    //debugLog.logCurrentFunction();

    String vsSource = definedShaderSource.vsCode;
    String fsSource = definedShaderSource.fsCode;

    /// ShaderType type
    webgl.Shader createShader(int shaderType, String shaderSource) {
      //debugLog.logCurrentFunction();

      webgl.Shader shader = gl.createShader(shaderType);
      gl.shaderSource(shader, shaderSource);
      gl.compileShader(shader);

      if (debug.isDebug) {
        bool compiled = gl.getShaderParameter(
            shader, ShaderParameters.COMPILE_STATUS) as bool;
        if (!compiled) {
          String compilationLog = gl.getShaderInfoLog(shader);

          throw "Could not compile ${glEnum.ShaderType.getByIndex(shaderType)} shader :\n\n $compilationLog}";
        }
      }

      return shader;
    }

    webgl.Shader vertexShader =
        createShader(ShaderType.VERTEX_SHADER, vsSource);
    webgl.Shader fragmentShader =
        createShader(ShaderType.FRAGMENT_SHADER, fsSource);

    webgl.Program program = gl.createProgram();

    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (debug.isDebug) {
      if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS)
              as bool ==
          false) {
        throw "Could not link the shader program! > ${gl.getProgramInfoLog(program)}";
      }
    }
    gl.validateProgram(program);
    if (debug.isDebug) {
      if (gl.getProgramParameter(
              program, ProgramParameterGlEnum.VALIDATE_STATUS) as bool ==
          false) {
        throw "Could not validate program! > ${gl.getProgramInfoLog(program)} > ${gl.getProgramInfoLog(program)}";
      }
    }

    return new WebGLProgram.fromWebGL(program);
  }

  ///Must be called after gl.useProgram
  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight);

  /// ShaderVariableType componentType
  void setUniform(WebGLProgram program, String uniformName, int componentType,
      dynamic data) {
    //debugLog.logCurrentFunction(uniformName);

    program.uniformLocations[uniformName] ??=
        program.getUniformLocation(uniformName);
    WebGLUniformLocation wrappedUniformLocation =
        program.uniformLocations[uniformName];

//    if(uniformName == ())
    //let's pass if u_Camera, else it won't drow reflection correctly wrappedUniformLocation.data == data && uniformName != "u_Camera"
    if (wrappedUniformLocation.data == data &&
        uniformName != "u_Camera" &&
        uniformName != "u_ModelMatrix") {
      //      print('same $uniformName > return : $data, ${wrappedUniformLocation.data}');
      return;
    }
    ;

    wrappedUniformLocation.data = data;
    webgl.UniformLocation uniformLocation =
        wrappedUniformLocation.webGLUniformLocation;
    bool transpose = false;

    switch (componentType) {
      case ShaderVariableType.BOOL:
      case ShaderVariableType.SAMPLER_CUBE:
      case ShaderVariableType.SAMPLER_2D:
        gl.uniform1i(uniformLocation, data as int);
        break;
      case ShaderVariableType.FLOAT:
        gl.uniform1f(uniformLocation, data as num);
        break;
      case ShaderVariableType.FLOAT_VEC2:
        gl.uniform2fv(uniformLocation, data);
        break;
      case ShaderVariableType.FLOAT_VEC3:
        gl.uniform3fv(uniformLocation, data);
        break;
      case ShaderVariableType.FLOAT_VEC4:
        gl.uniform4fv(uniformLocation, data);
        break;
      case ShaderVariableType.FLOAT_MAT3:
        gl.uniformMatrix3fv(uniformLocation, transpose, data);
        break;
      case ShaderVariableType.FLOAT_MAT4:
        gl.uniformMatrix4fv(uniformLocation, transpose, data);
        break;
      default:
        throw new Exception(
            'renderer setUnifrom exception : Trying to set a uniform for a not defined component type : $componentType');
        break;
    }
  }

  void setupBeforeRender() {}

  void setupAfterRender() {}
}

@reflector
class KronosPRBMaterial extends RawMaterial {
  ShaderSource get shaderSource => ShaderSource.kronosGltfPBRTest;

  final bool hasNormalAttribut;
  final bool hasTangentAttribut;
  final bool hasUVAttribut;
  final bool hasColorAttribut;
  final bool hasLODExtension;

  bool get useLod => true;

  KronosPRBMaterial(this.hasNormalAttribut, this.hasTangentAttribut,
      this.hasUVAttribut, this.hasColorAttribut, this.hasLODExtension);

  //> BaseColor
  webgl.Texture baseColorMap;
  bool get hasBaseColorMap => baseColorMap != null;
  int _baseColorSamplerSlot;
  int get baseColorSamplerSlot => _baseColorSamplerSlot;
  set baseColorSamplerSlot(int value) {
    _baseColorSamplerSlot = value;
  }

  List<double> _baseColorFactor;
  List<double> get baseColorFactor => _baseColorFactor;
  set baseColorFactor(List<double> value) {
    _baseColorFactor = value;
  }

  //> Normals Map
  webgl.Texture normalMap;
  bool get hasNormalMap => normalMap != null;
  int _normalSamplerSlot;
  int get normalSamplerSlot => _normalSamplerSlot;
  set normalSamplerSlot(int value) {
    _normalSamplerSlot = value;
  }

  double _normalScale;
  double get normalScale => _normalScale;
  set normalScale(double value) {
    _normalScale = value;
  }

  //> Emissive Map
  webgl.Texture emissiveMap;
  bool get hasEmissiveMap => emissiveMap != null;
  int _emissiveSamplerSlot;
  int get emissiveSamplerSlot => _emissiveSamplerSlot;
  set emissiveSamplerSlot(int value) {
    _emissiveSamplerSlot = value;
  }

  List<double> _emissiveFactor;
  List<double> get emissiveFactor => _emissiveFactor;
  set emissiveFactor(List<double> value) {
    _emissiveFactor = value;
  }

  //> Occlusion Map
  webgl.Texture occlusionMap;
  bool get hasOcclusionMap => occlusionMap != null;
  int _occlusionSamplerSlot;
  int get occlusionSamplerSlot => _occlusionSamplerSlot;
  set occlusionSamplerSlot(int value) {
    _occlusionSamplerSlot = value;
  }

  double _occlusionStrength;
  double get occlusionStrength => _occlusionStrength;
  set occlusionStrength(double value) {
    _occlusionStrength = value;
  }

  //> MetallRoughness Map
  webgl.Texture metallicRoughnessMap;
  bool get hasMetallicRoughnessMap => metallicRoughnessMap != null;
  int _metallicRoughnessSamplerSlot;
  int get metallicRoughnessSamplerSlot => _metallicRoughnessSamplerSlot;
  set metallicRoughnessSamplerSlot(int value) {
    _metallicRoughnessSamplerSlot = value;
  }

  double _roughness;
  set roughness(double value) {
    _roughness = value;
  }

  double get roughness => _roughness;

  double _metallic;
  set metallic(double value) {
    _metallic = value;
  }

  double get metallic => _metallic;

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    Map<String, bool> defines = new Map();

    defines['USE_IBL'] = useLod;
    defines['USE_TEX_LOD'] = hasLODExtension;

    //primitives infos
    defines['HAS_NORMALS'] = hasNormalAttribut;
    defines['HAS_TANGENTS'] = hasTangentAttribut;
    defines['HAS_UV'] = hasUVAttribut;
    defines['HAS_COLORS'] = hasColorAttribut;

    //Material base infos
    defines['HAS_NORMALMAP'] = hasNormalMap;
    defines['HAS_EMISSIVEMAP'] = hasEmissiveMap;
    defines['HAS_OCCLUSIONMAP'] = hasOcclusionMap;

    //Material pbr infos
    defines['HAS_BASECOLORMAP'] = hasBaseColorMap;
    defines['HAS_METALROUGHNESSMAP'] = hasMetallicRoughnessMap;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS'] = false;

    return defines;
  }

  Float32List vecData2 = new Float32List(2);
  Float32List vecData3 = new Float32List(3);
  Float32List vecData4 = new Float32List(4);
  Float32List matrixData4 = new Float32List(16);

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    //debugLog.logCurrentFunction();

    for (int i = 0; i < matrixData4.length; ++i) {
      matrixData4[i] = modelMatrix[i];
    }
    setUniform(
        program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4, matrixData4);

    setUniform(
        program, 'u_PVMatrix', ShaderVariableType.FLOAT_MAT4, pvMatrix.storage);

    // > camera
    setUniform(
        program,
        'u_Camera',
        ShaderVariableType.FLOAT_VEC3,
        vecData3
          ..setAll(
              0, [cameraPosition[0], cameraPosition[1], cameraPosition[2]]));

    // > Light
    setUniform(
        program,
        'u_LightDirection',
        ShaderVariableType.FLOAT_VEC3,
        vecData3
          ..setAll(0, [
            directionalLight.direction[0],
            directionalLight.direction[1],
            directionalLight.direction[2]
          ]));

    setUniform(
        program,
        'u_LightColor',
        ShaderVariableType.FLOAT_VEC3,
        vecData3
          ..setAll(0, [
            directionalLight.color[0],
            directionalLight.color[1],
            directionalLight.color[2]
          ]));

    // > Material base

    if (useLod) {
      setUniform(program, 'u_brdfLUT', ShaderVariableType.SAMPLER_2D, 0);
      setUniform(
          program, 'u_DiffuseEnvSampler', ShaderVariableType.SAMPLER_CUBE, 1);
      setUniform(
          program, 'u_SpecularEnvSampler', ShaderVariableType.SAMPLER_CUBE, 2);
    }

    if (hasBaseColorMap) {
//      gl.activeTexture(baseColorSamplerSlot);
//      gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, baseColorMap);
      setUniform(program, 'u_BaseColorSampler', ShaderVariableType.SAMPLER_2D,
          baseColorSamplerSlot);
    }

    if (hasNormalMap) {
      setUniform(program, 'u_NormalSampler', ShaderVariableType.SAMPLER_2D,
          normalSamplerSlot);
      setUniform(
          program, 'u_NormalScale', ShaderVariableType.FLOAT, normalScale);
    }

    if (hasEmissiveMap) {
      setUniform(program, 'u_EmissiveSampler', ShaderVariableType.SAMPLER_2D,
          emissiveSamplerSlot);
      setUniform(
          program,
          'u_EmissiveFactor',
          ShaderVariableType.FLOAT_VEC3,
          vecData3
            ..setAll(
                0, [emissiveFactor[0], emissiveFactor[1], emissiveFactor[2]]));
    }

    if (hasOcclusionMap) {
      setUniform(program, 'u_OcclusionSampler', ShaderVariableType.SAMPLER_2D,
          occlusionSamplerSlot);

      setUniform(program, 'u_OcclusionStrength', ShaderVariableType.FLOAT,
          occlusionStrength);
    }

    if (hasMetallicRoughnessMap) {
      setUniform(program, 'u_MetallicRoughnessSampler',
          ShaderVariableType.SAMPLER_2D, metallicRoughnessSamplerSlot);
    }

    setUniform(
        program,
        'u_MetallicRoughnessValues',
        ShaderVariableType.FLOAT_VEC2,
        vecData2..setAll(0, [metallic, roughness]));

    setUniform(program, 'u_BaseColorFactor', ShaderVariableType.FLOAT_VEC4,
        baseColorFactor);

    // > Debug values => see in pbr fragment shader

    double specularReflectionMask = 0.0;
    double geometricOcclusionMask = 0.0;
    double microfacetDistributionMask = 0.0;
    double specularContributionMask = 0.0;
    setUniform(
        program,
        'u_ScaleFGDSpec',
        ShaderVariableType.FLOAT_VEC4,
        vecData4
          ..setAll(0, [
            specularReflectionMask,
            geometricOcclusionMask,
            microfacetDistributionMask,
            specularContributionMask
          ]));

    double diffuseContributionMask = 0.0;
    double colorMask = 0.0;
    double metallicMask = 0.0;
    double roughnessMask = 0.0;
    setUniform(
        program,
        'u_ScaleDiffBaseMR',
        ShaderVariableType.FLOAT_VEC4,
        vecData4
          ..setAll(0, [
            diffuseContributionMask,
            colorMask,
            metallicMask,
            roughnessMask
          ]));

    double diffuseIBLAmbient = 1.0;
    double specularIBLAmbient = 1.0;
    setUniform(program, 'u_ScaleIBLAmbient', ShaderVariableType.FLOAT_VEC4,
        vecData4..setAll(0, [diffuseIBLAmbient, specularIBLAmbient, 1.0, 1.0]));
  }
}

@reflector
class KronosDefaultMaterial extends RawMaterial {
  KronosDefaultMaterial();

  ShaderSource get shaderSource => ShaderSource.kronosGltfDefault;

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    // Todo (jpu) : enable defines if needed

    Map<String, bool> defines = new Map();

    defines['USE_IBL'] = false;
    defines['USE_TEX_LOD'] = false;

    //primitives infos
    defines['HAS_NORMALS'] = false;
    defines['HAS_TANGENTS'] = false;
    defines['HAS_UV'] = false;

    //Material base infos
    defines['HAS_NORMALMAP'] = false;
    defines['HAS_EMISSIVEMAP'] = false;
    defines['HAS_OCCLUSIONMAP'] = false;

    //Material infos
    defines['HAS_BASECOLORMAP'] = false;
    defines['HAS_METALROUGHNESSMAP'] = false;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS'] = false;

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    //debugLog.logCurrentFunction();

    setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    setUniform(program, 'u_MVPMatrix', ShaderVariableType.FLOAT_MAT4,
        ((projectionMatrix * viewMatrix * modelMatrix) as Matrix4).storage);

    Matrix3 normalMatrix =
        (viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    setUniform(program, 'u_NormalMatrix', ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    setUniform(program, 'u_LightPos', ShaderVariableType.FLOAT_VEC3,
        directionalLight.translation.storage);
  }
}

@reflector
class MaterialDebug extends RawMaterial {
  Vector3 color = new Vector3(0.5, 0.5, 0.5);

  MaterialDebug();

  ShaderSource get shaderSource => ShaderSource.debugShader;

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    Map<String, bool> defines = new Map();

    //primitives infos
    defines['HAS_COLORS'] = false;
    defines['HAS_NORMALS'] = true;
    defines['HAS_TANGENTS'] = false;
    defines['HAS_UV'] = true;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS_POSITION'] = false;
    defines['DEBUG_FS_NORMALS'] = defines['HAS_NORMALS'] && true;
    defines['DEBUG_FS_UV'] = defines['HAS_UV'] && false;

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    setUniform(
        program, 'u_Color', ShaderVariableType.FLOAT_VEC3, color.storage);
  }
}

//>
typedef void SetShaderVariables(
    WebGLProgram program,
    Matrix4 modelMatrix,
    Matrix4 viewMatrix,
    Matrix4 projectionMatrix,
    Vector3 cameraPosition,
    DirectionalLight directionalLight);

@reflector
class MaterialCustom extends RawMaterial {
  SetShaderVariables setShaderUniformsVariables;

  ShaderSource get shaderSource => ShaderSource.materialPoint; // Todo (jpu) : ?

  MaterialCustom();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();
    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setShaderUniformsVariables(program, modelMatrix, viewMatrix,
        projectionMatrix, cameraPosition, directionalLight);
  }
}

@reflector
class MaterialPoint extends RawMaterial {
  num pointSize;
  Vector4 color;

  ShaderSource get shaderSource => ShaderSource.materialPoint;

  MaterialPoint({this.pointSize: 1.0, this.color});

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    defines['USE_COLOR_UNIFORM'] = true;

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    setUniform(program, "u_PointSize", ShaderVariableType.FLOAT, pointSize);
    setUniform(
        program, "u_Color", ShaderVariableType.FLOAT_VEC4, color.storage);
  }
}

@reflector
class MaterialBase extends RawMaterial {
  ShaderSource get shaderSource => ShaderSource.materialBase;

  MaterialBase();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelMatrix", ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    setUniform(program, "u_ViewMatrix", ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
  }
}

@reflector
class MaterialBaseColor extends RawMaterial {
  Vector4 color;

  ShaderSource get shaderSource => ShaderSource.materialBaseColor;

  MaterialBaseColor(this.color);

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    setUniform(
        program, "u_Color", ShaderVariableType.FLOAT_VEC4, color.storage);
  }
}

@reflector
class MaterialBaseVertexColor extends RawMaterial {
  ShaderSource get shaderSource => ShaderSource.materialBaseVertexColor;

  MaterialBaseVertexColor();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
  }
}

@reflector
class MaterialBaseTexture extends RawMaterial {
  WebGLTexture texture;

  ShaderSource get shaderSource => ShaderSource.materialBaseTexture;

  MaterialBaseTexture();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    setUniform(program, "u_TextureMatrix", ShaderVariableType.FLOAT_MAT4,
        texture?.textureMatrix?.storage);

    gl.activeTexture(TextureUnit.TEXTURE7);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
    setUniform(program, "u_Sampler", ShaderVariableType.SAMPLER_2D, 7);
  }
}

@reflector
class MaterialBaseTextureNormal extends RawMaterial {
  WebGLTexture texture;
  Vector3 ambientColor = new Vector3.all(1.0);
  DirectionalLight directionalLight;
  bool useLighting = false;

  ShaderSource get shaderSource => ShaderSource.materialBaseTextureNormal;

  MaterialBaseTextureNormal();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix =
        (viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    setUniform(program, "u_NormalMatrix", ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    setUniform(program, "u_UseLighting", ShaderVariableType.BOOL,
        useLighting ? 1 : 0); // must be int, not bool

    if (useLighting) {
      setUniform(program, "u_AmbientColor", ShaderVariableType.FLOAT_VEC3,
          ambientColor.storage);
      Vector3 adjustedLD = new Vector3.zero();
      directionalLight.direction.normalizeInto(adjustedLD);
      adjustedLD.scale(-1.0);

      setUniform(program, "u_LightingDirection", ShaderVariableType.FLOAT_VEC3,
          adjustedLD.storage);
      setUniform(program, "u_DirectionalColor", ShaderVariableType.FLOAT_VEC3,
          directionalLight.color.storage);
    }

    gl.activeTexture(TextureUnit.TEXTURE7);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
    setUniform(program, "u_Sampler", ShaderVariableType.SAMPLER_2D, 7);
  }
}

@reflector
class MaterialReflection extends RawMaterial {
  WebGLTexture skyboxTexture;

  ShaderSource get shaderSource => ShaderSource.materialReflection;

  MaterialReflection();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    setUniform(program, "u_InverseViewMatrix", ShaderVariableType.FLOAT_MAT4,
        new Matrix4.inverted(viewMatrix).storage);

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix =
        (viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    setUniform(program, "u_NormalMatrix", ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    gl.activeTexture(TextureUnit.TEXTURE7);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture.webGLTexture);
    setUniform(program, "u_EnvMap", ShaderVariableType.SAMPLER_CUBE, 7);
  }
}

@reflector
class MaterialSkyBox extends RawMaterial {
  WebGLTexture skyboxTexture;

  ShaderSource get shaderSource => ShaderSource.materialSkybox;

  MaterialSkyBox();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  /// ! vu ceci, il faut que l'objet qui a ce matériaux soit rendu en premier
  void setupBeforeRender(){
    gl.disable(EnableCapabilityType.DEPTH_TEST);
  }
  void setupAfterRender(){
    gl.enable(EnableCapabilityType.DEPTH_TEST);
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    //removing skybox transform
    setUniform(program, "u_ModelMatrix", ShaderVariableType.FLOAT_MAT4,
        new Matrix4.identity().storage);

    //removing camera translation
    Matrix3 m3 = viewMatrix.getRotation();
    Matrix4 m4 = new Matrix4.identity()..setRotation(m3);
    setUniform(
        program, "u_ViewMatrix", ShaderVariableType.FLOAT_MAT4, m4.storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    // Todo (jpu) : si dans ce matériaux, l'active texture n'est pas TEXTURE0, 0 alors ça plante ! pq ?
    gl.activeTexture(TextureUnit.TEXTURE0);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture.webGLTexture);
    setUniform(program, "u_EnvMap", ShaderVariableType.SAMPLER_CUBE, 0);
  }
}

@reflector
class MaterialDepthTexture extends RawMaterial {
  WebGLTexture texture;

  num near = 1.0;
  num far = 1000.0;

  ShaderSource get shaderSource => ShaderSource.materialDepthTexture;

  MaterialDepthTexture();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    //removing camera translation
    Matrix3 m3 = viewMatrix.getRotation();
    Matrix4 m4 = new Matrix4.identity()..setRotation(m3);
    setUniform(
        program, "u_ViewMatrix", ShaderVariableType.FLOAT_MAT4, m4.storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    gl.activeTexture(TextureUnit.TEXTURE7);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
    setUniform(program, "u_EnvMap", ShaderVariableType.SAMPLER_2D, 7);

    setUniform(program, "u_near", ShaderVariableType.FLOAT, near);
    setUniform(program, "u_far", ShaderVariableType.FLOAT, far);
  }
}

///PBR's
///http://marcinignac.com/blog/pragmatic-pbr-setup-and-gamma/
///module explained can be found here : https://github.com/vorg/pragmatic-pbr/tree/master/local_modules
///base
@reflector
class MaterialPragmaticPBR extends RawMaterial {
  PointLight pointLight;

  ShaderSource get shaderSource => ShaderSource.materialPBR;

  MaterialPragmaticPBR(this.pointLight);

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, "u_ModelViewMatrix", ShaderVariableType.FLOAT_MAT4,
        ((viewMatrix * modelMatrix) as Matrix4).storage);
    setUniform(program, "u_ProjectionMatrix", ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    /// The normal matrix is the transpose inverse of the modelview matrix.
    /// mat4 normalMatrix = transpose(inverse(modelView));
    Matrix3 normalMatrix = (Context.mainCamera.viewMatrix * Context.modelMatrix)
        .getNormalMatrix() as Matrix3;
    setUniform(program, "u_NormalMatrix", ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);
    setUniform(program, "u_LightPos", ShaderVariableType.FLOAT_VEC3,
        pointLight.translation.storage);
  }
}

@reflector
class MaterialDotScreen extends RawMaterial {
  WebGLTexture texture;
  double angle = 0.0;
  double scale = 1.0;
  Vector2 center = new Vector2(0.0, 0.0);
  Vector2 texSize = new Vector2(200.0, 200.0);

  ShaderSource get shaderSource => ShaderSource.dotScreen;

  MaterialDotScreen();

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    if (texture != null) {
      gl.activeTexture(TextureUnit.TEXTURE0);
      gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
      setUniform(program, "texture", ShaderVariableType.SAMPLER_2D, 0);
    }
    setUniform(
        program, "center", ShaderVariableType.FLOAT_VEC2, center.storage);
    setUniform(program, "angle", ShaderVariableType.FLOAT, angle);
    setUniform(program, "scale", ShaderVariableType.FLOAT, scale);
    setUniform(
        program, "texSize", ShaderVariableType.FLOAT_VEC2, texSize.storage);
  }
}

@reflector
class MaterialSAO extends RawMaterial {
  MaterialSAO();

  ShaderSource get shaderSource => ShaderSource.sao;

  int get depthTextureMap => null;
  double get intensity => 100.0;
  double get sampleRadiusWS => 5.0;
  double get bias => 0.0;
  double get zNear => 1.0;
  double get zFar => 1000.0;
  Vector2 get viewportResolution => new Vector2(256.0, 256.0);
  Vector4 get projInfo => new Vector4(1.0, 1.0, 1.0, 0.0);
  double get projScale => 100.0;

  Map<String, bool> getDefines() {
    Map<String, bool> defines = new Map();

    //primitives infos
    defines['HAS_COLORS'] = false;
    defines['HAS_UV'] = true;
    defines['HAS_NORMALS'] = false;
    defines['HAS_TANGENTS'] = false;

    //Fragment shader
    defines['DIFFUSE_TEXTURE'] = false;
    defines['NORMAL_TEXTURE'] = false;
    defines['DEPTH_PACKING'] = false;
    defines['PERSPECTIVE_CAMERA'] = false;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS_POSITION'] = false;
    defines['DEBUG_FS_NORMALS'] = defines['HAS_NORMALS'] && false;
    defines['DEBUG_FS_UV'] = defines['HAS_UV'] && false;

    return defines;
  }

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    setUniform(
        program, 'tDepth', ShaderVariableType.SAMPLER_2D, depthTextureMap);
    setUniform(program, 'intensity', ShaderVariableType.FLOAT, intensity);
    setUniform(
        program, 'sampleRadiusWS', ShaderVariableType.FLOAT, sampleRadiusWS);
    setUniform(program, 'bias', ShaderVariableType.FLOAT, bias);
    setUniform(program, 'zNear', ShaderVariableType.FLOAT, zNear);
    setUniform(program, 'zFar', ShaderVariableType.FLOAT, zFar);
    setUniform(program, 'viewportResolution', ShaderVariableType.FLOAT,
        viewportResolution);
    setUniform(program, 'projInfo', ShaderVariableType.FLOAT, projInfo);
    setUniform(program, 'projScale', ShaderVariableType.FLOAT, projScale);
  }
}

/*

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

  setShaderAttributs(Mesh model) {
    setShaderAttributArrayBuffer(
        'aVertexPosition', model.primitive.vertices, model.primitive.vertexDimensions);
    setShaderAttributElementArrayBuffer('aVertexIndice', model.primitive.indices);
    setShaderAttributArrayBuffer('aNormal', model.primitive.vertexNormals,
        model.primitive.vertexNormalsDimensions);
  }

  setShaderUniforms(Mesh model) {

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

    gl.activeTexture(TextureUnit.TEXTURE0);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, skyboxTexture.webGLTexture);
    setShaderUniform('uEnvMap', 0);
  }
}
 */
