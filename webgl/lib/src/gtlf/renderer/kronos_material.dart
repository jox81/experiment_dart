import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/utils/utils_debug.dart' as debug;
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

abstract class KronosRawMaterial{
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
    if(defines == null) return outStr;

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
    webgl.Shader createShader(
        int shaderType, String shaderSource) {
      //debugLog.logCurrentFunction();

      webgl.Shader shader = gl.createShader(shaderType);
      gl.shaderSource(shader, shaderSource);
      gl.compileShader(shader);

      if (debug.isDebug) {
        bool compiled =
        gl.getShaderParameter(shader, ShaderParameters.COMPILE_STATUS) as bool;
        if (!compiled) {
          String compilationLog = gl.getShaderInfoLog(shader);
          throw "Could not compile $shaderType shader:\n\n $compilationLog}";
        }
      }

      return shader;
    }

    webgl.Shader vertexShader = createShader(
        ShaderType.VERTEX_SHADER, vsSource);
    webgl.Shader fragmentShader = createShader(
        ShaderType.FRAGMENT_SHADER, fsSource);

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
      if (gl.getProgramParameter(program, ProgramParameterGlEnum.VALIDATE_STATUS)
      as bool ==
          false) {
        throw "Could not validate program! > ${gl.getProgramInfoLog(program)} > ${gl.getProgramInfoLog(program)}";
      }
    }

    return new WebGLProgram.fromWebGL(program);
  }

  ///Must be called after gl.useProgram
  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix, Vector3 cameraPosition, DirectionalLight directionalLight);

  /// ShaderVariableType componentType
  void _setUniform(WebGLProgram program, String uniformName, int componentType,
      dynamic data) {
    //debugLog.logCurrentFunction(uniformName);

    program.uniformLocations[uniformName] ??= program.getUniformLocation(uniformName);
    WebGLUniformLocation wrappedUniformLocation = program.uniformLocations[uniformName];

    //let's pass if u_Camera, else it won't drow reflection correctly
    if(wrappedUniformLocation.data == data && uniformName != "u_Camera") {
      //      print('same $uniformName > return : $data, ${wrappedUniformLocation.data}');
      return;
    };

    wrappedUniformLocation.data = data;
    webgl.UniformLocation uniformLocation = wrappedUniformLocation.webGLUniformLocation;
    bool transpose = false;

    switch (componentType) {
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
        gl.uniform3fv(uniformLocation,data);
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
}

class KronosPRBMaterial extends KronosRawMaterial{

  ShaderSource get shaderSource => ShaderSource.sources['kronos_gltf_pbr_test'];

  final bool hasNormalAttribut;
  final bool hasTangentAttribut;
  final bool hasUVAttribut;
  final bool hasLODExtension;

  bool get useLod => true;

  KronosPRBMaterial(this.hasNormalAttribut, this.hasTangentAttribut, this.hasUVAttribut, this.hasLODExtension);

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
  double get roughness =>  _roughness;

  double _metallic;
  set metallic(double value) {
    _metallic = value;
  }
  double get metallic =>  _metallic;

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    Map<String, bool> defines = new Map();

    defines['USE_IBL'] = useLod;
    defines['USE_TEX_LOD'] = hasLODExtension;

    //primitives infos
    defines['HAS_NORMALS'] = hasNormalAttribut;
    defines['HAS_TANGENTS'] = hasTangentAttribut;
    defines['HAS_UV'] = hasUVAttribut;

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

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix, Vector3 cameraPosition, DirectionalLight directionalLight) {
    //debugLog.logCurrentFunction();

    for (int i = 0; i < matrixData4.length; ++i) {
      matrixData4[i] = modelMatrix[i];
    }
    _setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        matrixData4);

    _setUniform(program, 'u_PVMatrix', ShaderVariableType.FLOAT_MAT4,
        pvMatrix.storage);

    // > camera
    _setUniform(program, 'u_Camera', ShaderVariableType.FLOAT_VEC3,
        vecData3..setAll(0,[cameraPosition[0], cameraPosition[1], cameraPosition[2]])
    );

    // > Light
    _setUniform(program, 'u_LightDirection', ShaderVariableType.FLOAT_VEC3,
        vecData3..setAll(0,[directionalLight.direction[0], directionalLight.direction[1], directionalLight.direction[2]]));

    _setUniform(program, 'u_LightColor', ShaderVariableType.FLOAT_VEC3,
        vecData3..setAll(0,[directionalLight.color[0], directionalLight.color[1], directionalLight.color[2]]));

    // > Material base

    if (useLod) {
      _setUniform(program, 'u_brdfLUT', ShaderVariableType.SAMPLER_2D,
          0);
      _setUniform(program, 'u_DiffuseEnvSampler', ShaderVariableType.SAMPLER_CUBE,
          1);
      _setUniform(program, 'u_SpecularEnvSampler', ShaderVariableType.SAMPLER_CUBE,
          2);
    }

    if (hasBaseColorMap) {
//      gl.activeTexture(baseColorSamplerSlot);
//      gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, baseColorMap);
      _setUniform(
          program,
          'u_BaseColorSampler',
          ShaderVariableType.SAMPLER_2D,
          baseColorSamplerSlot
      );
    }

    if (hasNormalMap) {
      _setUniform(program, 'u_NormalSampler', ShaderVariableType.SAMPLER_2D, normalSamplerSlot);
      _setUniform(program, 'u_NormalScale', ShaderVariableType.FLOAT,
          normalScale);
    }

    if (hasEmissiveMap) {
      _setUniform(
          program,
          'u_EmissiveSampler',
          ShaderVariableType.SAMPLER_2D, emissiveSamplerSlot);
      _setUniform(program, 'u_EmissiveFactor', ShaderVariableType.FLOAT_VEC3,
          vecData3..setAll(0,[emissiveFactor[0], emissiveFactor[1], emissiveFactor[2]])
      );
    }

    if (hasOcclusionMap) {
      _setUniform(
          program,
          'u_OcclusionSampler',
          ShaderVariableType.SAMPLER_2D,occlusionSamplerSlot);

      _setUniform(program, 'u_OcclusionStrength', ShaderVariableType.FLOAT,
          occlusionStrength);
    }

    if (hasMetallicRoughnessMap) {
      _setUniform(
          program,
          'u_MetallicRoughnessSampler',
          ShaderVariableType.SAMPLER_2D,
          metallicRoughnessSamplerSlot
      );
    }

    _setUniform(
        program,
        'u_MetallicRoughnessValues',
        ShaderVariableType.FLOAT_VEC2,vecData2..setAll(0,[metallic, roughness]));

    _setUniform(program, 'u_BaseColorFactor', ShaderVariableType.FLOAT_VEC4, baseColorFactor);

    // > Debug values => see in pbr fragment shader

    double specularReflectionMask = 0.0;
    double geometricOcclusionMask = 0.0;
    double microfacetDistributionMask = 0.0;
    double specularContributionMask = 0.0;
    _setUniform(
        program,
        'u_ScaleFGDSpec',
        ShaderVariableType.FLOAT_VEC4,vecData4..setAll(0,[
      specularReflectionMask,
      geometricOcclusionMask,
      microfacetDistributionMask,
      specularContributionMask]
    ));

    double diffuseContributionMask = 0.0;
    double colorMask = 0.0;
    double metallicMask = 0.0;
    double roughnessMask = 0.0;
    _setUniform(
        program,
        'u_ScaleDiffBaseMR',
        ShaderVariableType.FLOAT_VEC4,vecData4..setAll(0,[
      diffuseContributionMask,
      colorMask,
      metallicMask,
      roughnessMask
    ]));

    double diffuseIBLAmbient = 1.0;
    double specularIBLAmbient = 1.0;
    _setUniform(program, 'u_ScaleIBLAmbient', ShaderVariableType.FLOAT_VEC4,
        vecData4..setAll(0, [
          diffuseIBLAmbient,
          specularIBLAmbient,
          1.0,
          1.0
        ])

    );
  }
}

class KronosDefaultMaterial extends KronosRawMaterial{
  KronosDefaultMaterial();

  ShaderSource get shaderSource => ShaderSource.sources['kronos_gltf_default'];

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

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix, Vector3 cameraPosition, DirectionalLight directionalLight) {
    //debugLog.logCurrentFunction();

    _setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    _setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    _setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    _setUniform(program, 'u_MVPMatrix', ShaderVariableType.FLOAT_MAT4,
        ((projectionMatrix * viewMatrix * modelMatrix) as Matrix4).storage);

    Matrix3 normalMatrix = (viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    _setUniform(program, 'u_NormalMatrix', ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    _setUniform(program, 'u_LightPos', ShaderVariableType.FLOAT_VEC3,
        directionalLight.translation.storage);
  }

}

class KronosDebugMaterial extends KronosRawMaterial{
  Vector3 color = new Vector3(0.5, 0.5, 0.5);

  KronosDebugMaterial();

  ShaderSource get shaderSource => ShaderSource.sources['debug_shader'];

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

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix, Vector3 cameraPosition, DirectionalLight directionalLight) {
    _setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix .storage);
    _setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    _setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    _setUniform(program, 'u_Color', ShaderVariableType.FLOAT_VEC3,
        color.storage);
  }
}

class KronosMaterialPoint extends KronosRawMaterial {
  num pointSize;
  Vector4 color;

  ShaderSource get shaderSource => ShaderSource.sources['material_point'];

  KronosMaterialPoint({this.pointSize : 1.0, this.color});

  Map<String, bool> getDefines() {

    Map<String, bool> defines = new Map();

    defines['USE_COLOR_UNIFORM'] = true;

    return defines;
  }

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix, Vector3 cameraPosition, DirectionalLight directionalLight) {
    _setUniform(program, "uModelViewMatrix", ShaderVariableType.FLOAT_MAT4, ((viewMatrix * modelMatrix)as Matrix4).storage);
    _setUniform(program, "uProjectionMatrix", ShaderVariableType.FLOAT_MAT4, projectionMatrix.storage);
    _setUniform(program, "pointSize", ShaderVariableType.FLOAT, pointSize);
    _setUniform(program, "uColor", ShaderVariableType.FLOAT_VEC4, color.storage);
  }
}

class SAOMaterial extends KronosRawMaterial{

  SAOMaterial();

  ShaderSource get shaderSource => ShaderSource.sources['sao'];

  int get depthTextureMap => null;
  double get intensity => 100.0;
  double get sampleRadiusWS => 5.0;
  double get bias => 0.0;
  double get zNear => 1.0;
  double get zFar => 1000.0;
  Vector2 get viewportResolution => new Vector2(256.0, 256.0);
  Vector4 get projInfo => new Vector4(1.0,1.0,1.0,0.0);
  double get projScale => 100.0;

  Map<String, bool> getDefines() {

    Map<String, bool> defines = new Map();

    //primitives infos
    defines['HAS_COLORS'] = false;
    defines['HAS_UV'] = true;
    defines['HAS_NORMALS'] = false;
    defines['HAS_TANGENTS'] = false;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS_POSITION'] = false;
    defines['DEBUG_FS_NORMALS'] = defines['HAS_NORMALS'] && false;
    defines['DEBUG_FS_UV'] = defines['HAS_UV'] && false;

    return defines;
  }

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix, Vector3 cameraPosition, DirectionalLight directionalLight) {

    _setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix .storage);
    _setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    _setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);


    _setUniform(program, 'tDepth', ShaderVariableType.SAMPLER_2D,
        depthTextureMap);
    _setUniform(program, 'intensity', ShaderVariableType.FLOAT,
        intensity);
    _setUniform(program, 'sampleRadiusWS', ShaderVariableType.FLOAT,
        sampleRadiusWS);
    _setUniform(program, 'bias', ShaderVariableType.FLOAT,
        bias);
    _setUniform(program, 'zNear', ShaderVariableType.FLOAT,
        zNear);
    _setUniform(program, 'zFar', ShaderVariableType.FLOAT,
        zFar);
    _setUniform(program, 'viewportResolution', ShaderVariableType.FLOAT,
        viewportResolution);
    _setUniform(program, 'projInfo', ShaderVariableType.FLOAT,
        projInfo);
    _setUniform(program, 'projScale', ShaderVariableType.FLOAT,
        projScale);
  }

}