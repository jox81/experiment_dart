import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/asset.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/renderer/material.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_scene.dart';
import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_utils.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';


class LocalState {
  Map<String, GLFunctionCall> uniforms = new Map();
  Map<String, webgl.UniformLocation> uniformLocations = new Map();
  Map<String, AttributInfo> attributes = new Map();
}

class Defines {
  int USE_IBL;
  int HAS_NORMALS;
  int HAS_TANGENTS;
  int HAS_UV;
}

class AttributInfo {
  List<GLFunctionCall> cmds;

  int a_attribute;
}

class KronosMesh {
  final KronosScene scene;
  final String modelPath;

  LocalState localState;
  Map<String, int> defines = new Map();

  String vertSource;
  String fragSource;
  int sRGBifAvailable; // Todo (jpu) : what if not available

  GLTFPBRMaterial material;

  int accessorsLoading;

  Element error;

  webgl.Program program;

  TypedData vertices;
  GLTFAccessor verticesAccessor;

  TypedData normals;
  GLTFAccessor normalsAccessor;

  TypedData tangents;
  GLTFAccessor tangentsAccessor;

  TypedData texcoords;
  GLTFAccessor texcoordsAccessor;

  TypedData indices;
  GLTFAccessor indicesAccessor;

  KronosMesh(webgl.RenderingContext gl, this.scene, GlobalState globalState,
      this.modelPath, GLTFProject gltf, int meshIdx) {
    logCurrentFunction();
    defines['USE_IBL'] = 1;

    localState = new LocalState();

    vertSource = globalState.vertSource;
    fragSource = globalState.fragSource;
    sRGBifAvailable = globalState.sRGBifAvailable;

    ++scene.pendingBuffers;

    List<GLTFMeshPrimitive> primitives = gltf.meshes[meshIdx].primitives;

    // todo:  multiple primitives doesn't work.
    for (int i = 0; i < primitives.length; i++) {
      GLTFMeshPrimitive primitive = primitives[i];

      for (String attribute in primitive.attributes.keys) {
        switch (attribute) {
          case "NORMAL":
            defines['HAS_NORMALS'] = 1;
            break;
          case "TANGENT":
            defines['HAS_TANGENTS'] = 1;
            break;
          case "TEXCOORD_0":
            defines['HAS_UV'] = 1;
            break;
        }
      }

      // Material
      material = primitive.material;

      Map<String, ImageInfo> imageInfos = initTextures(gl, gltf);

      program = initProgram(gl, globalState);

      accessorsLoading = 0;

      // Attributes
      for (int attrIndex = 0;
          attrIndex < primitive.attributes.length;
          attrIndex++) {
        getAccessorData(gl, gltf, modelPath, primitive.attributes.values.toList()[attrIndex],
            primitive.attributes.keys.toList()[attrIndex]);
      }

      // Indices
      getAccessorData(gl, gltf, modelPath, primitive.indices, 'INDEX');

      scene.loadImages(imageInfos, gl);
    }
  }

  webgl.Program initProgram(
      webgl.RenderingContext gl, GlobalState globalState) {
    logCurrentFunction();

    String definesToString (Map<String, int> defines) {
      String outStr = '';
      for (String def in defines.keys) {
        outStr += '#define $def ${defines[def]}\n';
      }
      return outStr;
    };

    String shaderDefines = definesToString(defines);
    if (globalState.hasLODExtension != null) {
      shaderDefines += '#define USE_TEX_LOD 1\n';
    }

    webgl.Shader vertexShader = createShader(gl, ShaderType.VERTEX_SHADER, vertSource, shaderDefines);
    webgl.Shader fragmentShader = createShader(gl, ShaderType.FRAGMENT_SHADER, fragSource, shaderDefines);

    webgl.Program program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS) as bool ==
        false) {
      throw "Could not link the shader program! > ${gl.getProgramInfoLog(program)}";
    }
    gl.validateProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.VALIDATE_STATUS) as bool ==
        false) {
      throw "Could not compile program! > ${gl.getProgramInfoLog(program)} > ${gl.getProgramInfoLog(program)}";
    }

    return program;
  }

  /// ShaderType type
  webgl.Shader createShader(webgl.RenderingContext gl,int type, String shaderSource, String shaderDefines) {
    logCurrentFunction();

    webgl.Shader shader = gl.createShader(type);
    gl.shaderSource(shader, shaderDefines + shaderSource);
    gl.compileShader(shader);
    bool compiled = gl.getShaderParameter(shader, webgl.COMPILE_STATUS) as bool;
    if (!compiled) {
      error.innerHtml += 'Failed to compile $type shader<br>';
      String compilationLog = gl.getShaderInfoLog(shader);
      error.innerHtml += 'Shader compiler log: ' + compilationLog + '<br>';
      throw "Could not compile $type shader:\n\n $compilationLog}";
    }

    return shader;
  }
  void drawMesh(webgl.RenderingContext gl, Matrix4 transform, Matrix4 view,
      Matrix4 projection, GlobalState globalState) {
    logCurrentFunction();
    // Update model matrix
    Matrix4 modelMatrix = new Matrix4.identity();
    modelMatrix.multiply(transform);

    if (material != null && material.doubleSided) {
      gl.disable(webgl.CULL_FACE);
    } else {
      gl.enable(webgl.CULL_FACE);
    }

    // Update mvp matrix
    Matrix4 mvMatrix = new Matrix4.identity();
    mvMatrix = (view * modelMatrix) as Matrix4;

    Matrix4 mvpMatrix = new Matrix4.identity();
    mvpMatrix = (projection * mvMatrix) as Matrix4;

    // these should actually be local to the mesh (not in global)
    globalState.uniforms['u_MVPMatrix'].vals = <dynamic>[false, mvpMatrix.storage];

    // Update normal matrix
    globalState.uniforms['u_ModelMatrix'].vals = <dynamic>[false, modelMatrix.storage];

    applyState(gl, globalState);

    // Draw
    if (indicesAccessor != null) {
      gl.drawElements(webgl.TRIANGLES, indicesAccessor.count,
          webgl.UNSIGNED_SHORT, indicesAccessor.byteOffset);
    }

    disableState(gl);
  }

  ///Créer un Buffer
  bool initArrayBuffer(webgl.RenderingContext gl, TypedData data, int num, int type,
      String attributeName, int stride, int offset) {
    logCurrentFunction();
    webgl.Buffer buffer = gl.createBuffer();
    if (buffer == null) {
      error = document.getElementById('error');
      error.innerHtml += 'Failed to create the buffer object<br>';
      return false;
    }

    gl.useProgram(program);

    gl.bindBuffer(webgl.ARRAY_BUFFER, buffer);
    gl.bufferData(webgl.ARRAY_BUFFER, data, webgl.STATIC_DRAW);

    int a_attribute = gl.getAttribLocation(program, attributeName);

    localState.attributes[attributeName] = new AttributInfo()
      ..cmds = [
        new GLFunctionCall()
          ..function = gl.bindBuffer
          ..vals = <dynamic>[webgl.ARRAY_BUFFER, buffer],
        new GLFunctionCall()
          ..function = gl.vertexAttribPointer
          ..vals = <dynamic>[a_attribute, num, type, false, stride, offset],
        new GLFunctionCall()
          ..function = gl.enableVertexAttribArray
          ..vals = <dynamic>[a_attribute]
      ]
      ..a_attribute = a_attribute;
    return true;
  }

  ///Crée un buffer
  bool initBuffers(webgl.RenderingContext gl, GLTFProject gltf) {
    logCurrentFunction();
    Element error = document.getElementById('error');

    webgl.Buffer indexBuffer = gl.createBuffer();
    if (indexBuffer == null) {
      error.innerHtml += 'Failed to create the buffer object<br>';
      return false;
    }

    if (!initArrayBuffer(gl, vertices, 3, webgl.FLOAT, 'a_Position',
        verticesAccessor.byteStride, verticesAccessor.byteOffset)) {
      error.innerHtml += 'Failed to initialize position buffer<br>';
    }

    if (normalsAccessor != null) {
      if (!initArrayBuffer(gl, normals, 3, webgl.FLOAT, 'a_Normal',
          normalsAccessor.byteStride, normalsAccessor.byteOffset)) {
        error.innerHtml += 'Failed to initialize normal buffer<br>';
      }
    }

    if (tangentsAccessor != null) {
      if (!initArrayBuffer(gl, tangents, 4, webgl.FLOAT, 'a_Tangent',
          tangentsAccessor.byteStride, tangentsAccessor.byteOffset)) {
        error.innerHtml += 'Failed to initialize tangent buffer<br>';
      }
    }

    if (texcoordsAccessor != null) {
      if (!initArrayBuffer(gl, texcoords, 2, webgl.FLOAT, 'a_UV',
          texcoordsAccessor.byteStride, texcoordsAccessor.byteOffset)) {
        error.innerHtml += 'Failed to initialize texture buffer<br>';
      }
    }

    gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(webgl.ELEMENT_ARRAY_BUFFER, indices, webgl.STATIC_DRAW);

    --scene.pendingBuffers;
    scene.drawScene(gl);

    return true;
  }

  ///int colorSpace : ie : webgl.RGBA
  ImageInfo getImageInfo(webgl.RenderingContext gl, GLTFProject gltf,
      GLTFTextureInfo textureInfo, Function function, String uniformName, int colorSpace) {
    logCurrentFunction();

    String uri = '${modelPath}${textureInfo.texture.source.uri}';
    int samplerIndex = scene.getNextSamplerIndex();
    localState.uniforms[uniformName] = new GLFunctionCall()
      ..function = function
      ..vals = <dynamic>[samplerIndex];

    return new ImageInfo()
      ..uri = uri
      ..samplerId = samplerIndex
      ..colorSpace = colorSpace;
  }

  Map<String, ImageInfo> initTextures(webgl.RenderingContext gl, GLTFProject gltf) {
    logCurrentFunction();
    Map<String, ImageInfo> imageInfos = new Map<String, ImageInfo>();

    GLTFPbrMetallicRoughness pbrMat =
        material != null ? material.pbrMetallicRoughness : null;

    // Base Color
    Float32List baseColorFactor =
        pbrMat != null && pbrMat.baseColorFactor != null
            ? pbrMat.baseColorFactor
            : new Float32List.fromList([1.0, 1.0, 1.0, 1.0]);
    localState.uniforms['u_BaseColorFactor'] = new GLFunctionCall()
      ..function = gl.uniform4f
      ..vals = baseColorFactor;

    if (pbrMat != null &&
        pbrMat.baseColorTexture != null) {
      imageInfos['baseColor'] = getImageInfo(
          gl,
          gltf,
          pbrMat.baseColorTexture,
          gl.uniform1i,
          'u_BaseColorSampler',
          sRGBifAvailable);
      defines['HAS_BASECOLORMAP'] = 1;
    } else if (localState.uniforms['u_BaseColorSampler'] != null) {
      localState.uniforms.remove('u_BaseColorSampler');
    }

    // Metallic-Roughness
    double metallic = (pbrMat != null && pbrMat.metallicFactor != null)
        ? pbrMat.metallicFactor
        : 1.0;
    double roughness = (pbrMat != null && pbrMat.roughnessFactor != null)
        ? pbrMat.roughnessFactor
        : 1.0;
    localState.uniforms['u_MetallicRoughnessValues'] = new GLFunctionCall()
      ..function = gl.uniform2f
      ..vals = <dynamic>[metallic, roughness];

    if (pbrMat != null &&
        pbrMat.metallicRoughnessTexture != null) {
      imageInfos['metalRoughness'] = getImageInfo(
          gl,
          gltf,
          pbrMat.metallicRoughnessTexture,
          gl.uniform1i,
          'u_MetallicRoughnessSampler',
          webgl.RGBA);
      defines['HAS_METALROUGHNESSMAP'] = 1;
    } else if (localState.uniforms['u_MetallicRoughnessSampler'] != null) {
      localState.uniforms.remove('u_MetallicRoughnessSampler');
    }

    // Normals
    if (material != null &&
        material.normalTexture != null) {
      imageInfos['normal'] = getImageInfo(
          gl,
          gltf,
          material.normalTexture,
          gl.uniform1i,
          'u_NormalSampler',
          webgl.RGBA);
      double normalScale = material.normalTexture.scale != null
          ? material.normalTexture.scale
          : 1.0;
      localState.uniforms['u_NormalScale'] = new GLFunctionCall()
        ..function = gl.uniform1f
        ..vals = <dynamic>[normalScale];
      defines['HAS_NORMALMAP'] = 1;
    } else if (localState.uniforms['u_NormalSampler'] != null) {
      localState.uniforms.remove('u_NormalSampler');
    }

    int samplerIndex;

    // brdfLUT
    String brdfLUT = 'textures/brdfLUT.png';
    samplerIndex = scene.getNextSamplerIndex();
    imageInfos['brdfLUT'] = new ImageInfo()
      ..uri = brdfLUT
      ..samplerId = samplerIndex
      ..colorSpace = webgl.RGBA
      ..clamp = true;
    localState.uniforms['u_brdfLUT'] = new GLFunctionCall()
      ..function = gl.uniform1i
      ..vals = <dynamic>[samplerIndex];

    // Emissive
    if (material != null && material.emissiveTexture != null) {
      imageInfos['emissive'] = getImageInfo(
          gl,
          gltf,
          material.emissiveTexture,
          gl.uniform1i,
          'u_EmissiveSampler',
          sRGBifAvailable);
      defines['HAS_EMISSIVEMAP'] = 1;
      List<double> emissiveFactor = material.emissiveFactor != null
          ? material.emissiveFactor
          : [0.0, 0.0, 0.0];
      localState.uniforms['u_EmissiveFactor'] = new GLFunctionCall()
        ..function = gl.uniform3f
        ..vals = <dynamic>[emissiveFactor[0], emissiveFactor[1], emissiveFactor[2]];
    } else if (localState.uniforms['u_EmissiveSampler'] != null) {
      localState.uniforms.remove('u_EmissiveSampler');
    }

    // AO
    if (material != null && material.occlusionTexture != null) {
      imageInfos['occlusion'] = getImageInfo(
          gl,
          gltf,
          material.occlusionTexture,
          gl.uniform1i,
          'u_OcclusionSampler',
          webgl.RGBA);
      double occlusionStrength = material.occlusionTexture.strength != null
          ? material.occlusionTexture.strength
          : 1.0;
      localState.uniforms['u_OcclusionStrength'] = new GLFunctionCall()
        ..function = gl.uniform1f
        ..vals = <dynamic>[occlusionStrength];
      defines['HAS_OCCLUSIONMAP'] = 1;
    } else if (localState.uniforms['u_OcclusionSampler'] != null) {
      localState.uniforms.remove('u_OcclusionSampler');
    }

    return imageInfos;
  }

  void getAccessorData(webgl.RenderingContext gl, GLTFProject gltf,
      String modelPath, GLTFAccessor accessor, String attributeName) {
    logCurrentFunction();
    KronosMesh mesh = this;
    accessorsLoading++;
    GLTFBufferView bufferView = accessor.bufferView;
    GLTFBuffer buffer = bufferView.buffer;
    Uri bin = buffer.uri;

    FileReader reader = new FileReader();

    reader.onLoadEnd.listen((e) {
      ByteBuffer arrayBuffer = (reader.result as Uint8List).buffer;
      int start = bufferView.byteOffset != null ? bufferView.byteOffset : 0;

      TypedData data;
      if (accessor.componentType == ShaderVariableType.FLOAT) {
        data = arrayBuffer.asByteData(start, bufferView.byteLength);
      } else if (accessor.componentType ==
          ShaderVariableType.UNSIGNED_SHORT) {
        data = arrayBuffer.asByteData(start, bufferView.byteLength);
      }

      switch (attributeName) {
        case "POSITION":
          mesh.vertices = data;
          mesh.verticesAccessor = accessor;
          break;
        case "NORMAL":
          mesh.normals = data;
          mesh.normalsAccessor = accessor;
          break;
        case "TANGENT":
          mesh.tangents = data;
          mesh.tangentsAccessor = accessor;
          break;
        case "TEXCOORD_0":
          mesh.texcoords = data;
          mesh.texcoordsAccessor = accessor;
          break;
        case "INDEX":
          mesh.indices = data;
          mesh.indicesAccessor = accessor;
          break;
        default:
          print('Unknown attribute semantic: ' + attributeName);
      }

      mesh.accessorsLoading--;
      if (mesh.accessorsLoading == 0) {
        mesh.initBuffers(gl, gltf);
      }
    });

    GLTFAsset assets = mesh.scene.assets;
    String assetUrl = '$modelPath$bin'; // Todo (jpu) : combine uri ?
    Future<Blob> promise;
    if (assets.hasOwnProperty(assetUrl)) {
      // We already requested this, and a promise already exists.
      promise = new Future.value(assets[assetUrl]);
    } else {
      Completer<Blob> completer = new Completer<Blob>();
      promise = completer.future;

      Future<Blob> getBlob(){
        logCurrentFunction('getBlob');
        HttpRequest request = new HttpRequest();
        request.open("GET", assetUrl, async:true);
        request.responseType = "blob";
        request.onLoadEnd.listen((e) {
          if (request.status < 200 || request.status > 299) {
            String fsErr = 'Error: HTTP Status ${request.status} on resource: $assetUrl';
            window.alert('Fatal error getting ressource (see console)');
            print(fsErr);
            return completer.completeError(fsErr);
          } else {
            completer.complete(request.response as Blob);
          }
        });
        request.send();

        return completer.future;
      }

      // We didn't request this yet, create a promise for it.

      getBlob().then((Blob blob){
        assets[assetUrl] = blob;
        promise = new Future.value(assets[assetUrl]);
      });
    }

    // This will fire when the promise is resolved, or immediately if the promise has previously resolved.
    promise.then((Blob blob) {
      reader.readAsArrayBuffer(blob);
    });
  }

  void applyState(webgl.RenderingContext gl, GlobalState globalState) {
    logCurrentFunction();

    gl.useProgram(program);

    void applyUniform(GLFunctionCall uniformCall, String uniformName) {
      logCurrentFunction('applyUniform : $uniformName');
      if (localState.uniformLocations[uniformName] == null) {
        localState.uniformLocations[uniformName] =
            gl.getUniformLocation(program, uniformName);
      }

      if (uniformCall.function != null &&
          localState.uniformLocations[uniformName] != null &&
          uniformCall.vals != null) {
        Function.apply(uniformCall.function, <dynamic>[]
          ..add(localState.uniformLocations[uniformName])
          ..addAll(uniformCall.vals));
      }
    };

    void applyAttribut(AttributInfo attributInfo, String attribName){
      logCurrentFunction('applyAttribut : $attribName');
      for (GLFunctionCall cmd in attributInfo.cmds) {
        Function.apply(cmd.function, <dynamic>[]
          ..addAll(cmd.vals));
      }
    }

    for (String uniformName in globalState.uniforms.keys) {
      applyUniform(globalState.uniforms[uniformName], uniformName);
    }

    for (String uniformName in localState.uniforms.keys) {
      applyUniform(localState.uniforms[uniformName], uniformName);
    }

    for (String attribName in localState.attributes.keys) {
      applyAttribut(localState.attributes[attribName], attribName);
    }

//    WebGLProgram.logProgramFromWebGL(program);
  }

  void disableState(webgl.RenderingContext gl) {
    logCurrentFunction();
    for (String attrib in localState.attributes.keys) {
      // do something.
      gl.disableVertexAttribArray(localState.attributes[attrib].a_attribute);
    }
  }
}
