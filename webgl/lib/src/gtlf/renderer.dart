import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_utils.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/animation.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/utils/utils_debug.dart' as debug;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart' as Context;
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'dart:convert' show BASE64;

// Uint8List = Byte
// Uint16List = SCALAR : int

class GLTFRenderer {
  GLTFProject gltf;
  GLTFScene get activeScene => gltf.scenes[0];

  webgl.RenderingContext gl;
  GlobalState globalState;

  Interaction interaction;
  GLTFCameraPerspective get mainCamera => Context.Context.mainCamera;
  Matrix4 get viewMatrix => mainCamera.viewMatrix;
  Matrix4 get projectionMatrix => mainCamera.projectionMatrix;
  Matrix4 modelMatrix;

  // Direction from where the light is coming to origin
  Vector3 lightDirection = new Vector3(1.0, -1.0, -1.0);
  Vector3 lightColor = new Vector3(1.0, 1.0, 1.0);

  WebGLTexture cubeMapTextureDiffuse, cubeMapTextureSpecular;
  int skipTexture;

  GLTFRenderer(this.gltf) {
    debug.logCurrentFunction();
    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) {
        throw "x";
      }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }

    //>
    Context.gl = gl;
    interaction = new Interaction();
  }

  Future render() async {
    debug.logCurrentFunction();
    await ShaderSource.loadShaders();
    await _initTextures();

    _init();
    _render();
  }

  Future _initTextures() async {
    debug.logCurrentFunction();
    ImageElement imageElement;
    ///TextureFilterType magFilter;
    int magFilter;
    /// TextureFilterType minFilter;
    int minFilter;
    /// TextureWrapType wrapS;
    int wrapS;
    /// TextureWrapType wrapT;
    int wrapT;

    //brdfLUT
    imageElement = await TextureUtils.loadImage('../images/utils/brdfLUT.png');
    magFilter = TextureFilterType.LINEAR;
    minFilter = TextureFilterType.LINEAR;
    wrapS = TextureWrapType.REPEAT;
    wrapT = TextureWrapType.REPEAT;
    createImageTexture(TextureUnit.TEXTURE0 + 0, imageElement, magFilter, minFilter, wrapS, wrapT);

    //Environnement
    gl.activeTexture(TextureUnit.TEXTURE0 + 1);
    List<ImageElement> papermill_diffuse =
        await TextureUtils.loadCubeMapImages('papermill_diffuse', webPath: '../');
    cubeMapTextureDiffuse = TextureUtils.createCubeMapWithImages(papermill_diffuse, flip: false);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureDiffuse.webGLTexture);

    gl.activeTexture(TextureUnit.TEXTURE0 + 2);
    List<ImageElement> papermill_specular =
        await TextureUtils.loadCubeMapImages('papermill_specular', webPath: '../');
    cubeMapTextureSpecular = TextureUtils.createCubeMapWithImages(papermill_specular, flip: false);
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureSpecular.webGLTexture);

    skipTexture = 3;

    bool useDebugTexture = false;
    for (int i = 0; i < gltf.textures.length; i++) {
      int textureUnitId = 0;

      if (!useDebugTexture) {
        GLTFTexture gltfTexture = gltf.textures[i];
        if (gltfTexture.source.data == null) {
          //load image
          String fileUrl =
              gltf.baseDirectory + gltfTexture.source.uri.toString();
          imageElement = await TextureUtils.loadImage(fileUrl);
          textureUnitId = gltfTexture.textureId;
        } else {
          String base64Encoded = BASE64.encode(gltfTexture.source.data);
          imageElement = new ImageElement(
              src: "data:${gltfTexture.source.mimeType};base64,$base64Encoded");
        }

        magFilter = gltfTexture.sampler != null
            ? gltfTexture.sampler.magFilter
            : TextureFilterType.LINEAR;
        minFilter = gltfTexture.sampler != null
            ? gltfTexture.sampler.minFilter
            : TextureFilterType.LINEAR;
        wrapS = gltfTexture.sampler != null
            ? gltfTexture.sampler.wrapS
            : TextureWrapType.REPEAT;
        wrapT = gltfTexture.sampler != null
            ? gltfTexture.sampler.wrapT
            : TextureWrapType.REPEAT;
      } else {
//        String imagePath = '/images/utils/uv.png';
        String imagePath = '/images/utils/uv_grid.png';
//      String imagePath = '/images/crate.gif';
//      String imagePath = '/gltf/samples/gltf_2_0/BoxTextured/CesiumLogoFlat.png';
//      String imagePath = '/gltf/samples/gltf_2_0/BoxTextured/CesiumLogoFlat_256.png';
        imageElement = await TextureUtils.loadImage(imagePath);

        magFilter = TextureFilterType.LINEAR;
        minFilter = TextureFilterType.LINEAR;
        wrapS = TextureWrapType.CLAMP_TO_EDGE;
        wrapT = TextureWrapType.CLAMP_TO_EDGE;
      }

      //create model texture
      createImageTexture(TextureUnit.TEXTURE0 + textureUnitId + skipTexture, imageElement, magFilter, minFilter, wrapS, wrapT);
    }
  }

  void createImageTexture(int textureUnitId, ImageElement imageElement, int magFilter, int minFilter, int wrapS, int wrapT) {

    //create texture
    webgl.Texture texture = gl.createTexture();

    //bind it to an active texture unit
    gl.activeTexture(textureUnitId);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture);
    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, 0);

    //fill texture data
    int mipMapLevel = 0;
    gl.texImage2D(
        TextureAttachmentTarget.TEXTURE_2D,
        mipMapLevel,
        TextureInternalFormat.RGBA,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        imageElement);
    gl.generateMipmap(TextureTarget.TEXTURE_2D);

    //set textureUnit format
    gl.texParameteri(TextureTarget.TEXTURE_2D,
        TextureParameter.TEXTURE_MAG_FILTER, magFilter);
    gl.texParameteri(TextureTarget.TEXTURE_2D,
        TextureParameter.TEXTURE_MIN_FILTER, minFilter);
    gl.texParameteri(
        TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_S, wrapS);
    gl.texParameteri(
        TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_T, wrapT);
  }

  num currentTime = 0;
  num deltaTime = 0;
  num timeFps = 0;
  int fps = 0;
  num speedFactor = 1.0;
  void _render({num time: 0.0}) {
    debug.logCurrentFunction(
        '\n------------------------------------------------');

    deltaTime = time - currentTime;
    timeFps += deltaTime;
    fps++;
    currentTime = time * speedFactor;

    if (fps >= 1000) {
      timeFps = 0;
      fps = 0;
    }

    try {
      update();
      draw();
    } catch (ex) {
      print("Error: $ex");
    }

    window.requestAnimationFrame((num time) {
      this._render(time: time);
    });
  }

  void _init() {
    setupCameras();

    webgl.EXTsRgb hasSRGBExt = gl.getExtension('EXT_SRGB') as webgl.EXTsRgb;

    globalState = new GlobalState()
//      ..uniforms = {} // in initProgram
//      ..attributes = {}
//      ..vertSource = ''
//      ..fragSource = ''
      ..scene = null
      ..hasLODExtension =
          gl.getExtension('EXT_shader_texture_lod') as webgl.ExtShaderTextureLod
      ..hasDerivativesExtension = gl.getExtension('OES_standard_derivatives')
          as webgl.OesStandardDerivatives
      ..sRGBifAvailable =
          hasSRGBExt != null ? webgl.EXTsRgb.SRGB_EXT : webgl.RGBA;
  }

  void draw() {
    debug.logCurrentFunction();
    gl.enable(webgl.DEPTH_TEST);
    gl.clearColor(.2, 0.2, 0.2, 1.0);
    gl.clear(
        ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);
    gl.frontFace(FrontFaceDirection.CCW);

//    // Enable depth test

    gl.depthFunc(webgl.LESS);
//    gl.enable(webgl.BLEND);
    gl.disable(webgl.CULL_FACE);
//
    gl.cullFace(FacingType.FRONT);


    //draw
    List<GLTFNode> nodes = activeScene.nodes;
    drawNodes(nodes);
  }

  void setupCameras() {
    debug.logCurrentFunction();

    Camera currentCamera;

    //find first activeScene camera
    currentCamera = findActiveSceneCamera(activeScene.nodes);
    //or use first in project else default
    if (currentCamera == null) {
      currentCamera = findActiveSceneCamera(gltf.nodes);
    }
    if (currentCamera == null) {
      if (gltf.cameras.length > 0) {
        currentCamera = gltf.cameras[0];
      } else {
        currentCamera = new GLTFCameraPerspective(radians(47.0), 100.0, 0.01)
          ..targetPosition = new Vector3(0.0, 0.03, 0.0);
//          ..targetPosition = new Vector3(0.0, .03, 0.0);//Avocado
      }
      currentCamera.position = new Vector3(5.0, 5.0, 10.0);
//      currentCamera.position = new Vector3(.5, 0.0, 0.2);//Avocado
    }

    //>
    if (currentCamera is GLTFCameraPerspective) {
      Context.Context.mainCamera = currentCamera;
    } else {
      // ortho ?
    }
  }

  Camera findActiveSceneCamera(List<GLTFNode> nodes) {
    Camera result;

    for (var i = 0; i < nodes.length && result == null; i++) {
      GLTFNode node = nodes[i];
      if (node.camera != null) {
        setupNodeCamera(node);
        result = node.camera;
      } else {
        findActiveSceneCamera(node.children);
      }
    }

    return result;
  }

  void setupNodeCamera(GLTFNode node) {
    debug.logCurrentFunction();

    GLTFCameraPerspective camera = node.camera as GLTFCameraPerspective;
    camera.position = node.translation;
  }

  webgl.Program setupProgram(GLTFMeshPrimitive primitive, Matrix4 nodeTransform) {
    debug.logCurrentFunction();

    GLTFMaterial material = gltf.materials.length > 0
        ? primitive.material
        : null;
    GLTFMaterial pbrMaterial;
    ShaderSource shaderSource;
    bool debugWithDefault = true;
    if (material == null || debugWithDefault) {
      shaderSource = ShaderSource.sources['kronos_gltf_default'];
    } else {
      pbrMaterial = material;
      shaderSource = ShaderSource.sources['kronos_gltf_pbr_test'];
    }

    Map<String, bool> defines = new Map();
    if (pbrMaterial != null) {
      defines['USE_IBL'] = true; // Todo (jpu) :
      defines['USE_TEX_LOD'] = false; // Todo (jpu) :

      //primitives infos
      defines['HAS_NORMALS'] = primitive.attributes['NORMAL'] !=
          null;
      defines['HAS_TANGENTS'] = primitive.attributes['TANGENT'] != null;
      defines['HAS_UV'] = primitive.attributes['TEXCOORD_0'] != null;

      //Material base infos
      defines['HAS_NORMALMAP'] = pbrMaterial.normalTexture != null;
      defines['HAS_EMISSIVEMAP'] = pbrMaterial.emissiveTexture != null;
      defines['HAS_OCCLUSIONMAP'] = pbrMaterial.occlusionTexture != null;

      //Material pbr infos
      defines['HAS_BASECOLORMAP'] =
          pbrMaterial.pbrMetallicRoughness.baseColorTexture != null;
      defines['HAS_METALROUGHNESSMAP'] =
          pbrMaterial.pbrMetallicRoughness.metallicRoughnessTexture != null;

      //debug jpu
      defines['DEBUG_VS'] = false;
      defines['DEBUG_FS'] = false;
    }

    webgl.Program program = initProgram(shaderSource, defines);
    gl.useProgram(program);

//    bool forceTwoSided = true;
//    if (material != null && material.doubleSided || forceTwoSided) {
//      gl.disable(webgl.CULL_FACE); //Two sided
//    } else {
//      gl.enable(webgl.CULL_FACE);
//    }

    //uniform
    modelMatrix = nodeTransform;
    setUnifrom(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        nodeTransform.storage);
    setUnifrom(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    setUnifrom(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    debug.logCurrentFunction(
        'u_ViewMatrix pos : ${viewMatrix.getTranslation()}');
    debug.logCurrentFunction('mainCamera pos : ${mainCamera.position}');
    debug.logCurrentFunction(
        'mainCamera target pos : ${mainCamera.targetPosition}');
    debug.logCurrentFunction(
        'mainCamera target pos : ${mainCamera.viewProjectionMatrix.getTranslation()}');

    if (pbrMaterial != null) {
      setUnifrom(program, 'u_MVPMatrix', ShaderVariableType.FLOAT_MAT4,
          ((projectionMatrix * viewMatrix * modelMatrix) as Matrix4).storage);

      // > camera
      setUnifrom(program, 'u_Camera', ShaderVariableType.FLOAT_VEC3,
          mainCamera.position.storage);

      // > Light
      setUnifrom(program, 'u_LightDirection', ShaderVariableType.FLOAT_VEC3,
          lightDirection.storage);

      setUnifrom(program, 'u_LightColor', ShaderVariableType.FLOAT_VEC3,
          (lightColor * 2.0).storage);

      // > Material base

      if (defines['USE_IBL']) {
        setUnifrom(program, 'u_brdfLUT', ShaderVariableType.SAMPLER_2D,
            new Int32List.fromList([0]));
        setUnifrom(program, 'u_DiffuseEnvSampler', ShaderVariableType.SAMPLER_CUBE,
            new Int32List.fromList([1]));
        setUnifrom(program, 'u_SpecularEnvSampler', ShaderVariableType.SAMPLER_CUBE,
            new Int32List.fromList([2]));
      }

      if (defines['HAS_NORMALMAP']) {
        setUnifrom(program, 'u_NormalSampler', ShaderVariableType.SAMPLER_2D,
            new Int32List.fromList([material.normalTexture.texture.textureId + skipTexture]));
        double normalScale = material.normalTexture.scale != null
            ? material.normalTexture.scale
            : 1.0;
        setUnifrom(program, 'u_NormalScale', ShaderVariableType.FLOAT,
            new Float32List.fromList([normalScale]));
      }

      if (defines['HAS_EMISSIVEMAP']) {
        setUnifrom(
            program,
            'u_EmissiveSampler',
            ShaderVariableType.SAMPLER_2D,
            new Int32List.fromList(
                [material.emissiveTexture.texture.textureId + skipTexture]));
        setUnifrom(program, 'u_EmissiveFactor', ShaderVariableType.FLOAT_VEC3,
            new Float32List.fromList(material.emissiveFactor));
      }

      if (defines['HAS_OCCLUSIONMAP']) {
        setUnifrom(
            program,
            'u_OcclusionSampler',
            ShaderVariableType.SAMPLER_2D,
            new Int32List.fromList(
                [material.occlusionTexture.texture.textureId + skipTexture]));
        double occlusionStrength = material.occlusionTexture.strength != null
            ? material.occlusionTexture.strength
            : 1.0;
        setUnifrom(program, 'u_OcclusionStrength', ShaderVariableType.FLOAT,
            new Float32List.fromList([occlusionStrength]));
      }

      // > Material pbr

      if (defines['HAS_BASECOLORMAP']) {
        setUnifrom(
            program,
            'u_BaseColorSampler',
            ShaderVariableType.SAMPLER_2D,
            new Int32List.fromList([
              material.pbrMetallicRoughness.baseColorTexture.texture.textureId + skipTexture
            ]));
      }

      if (defines['HAS_METALROUGHNESSMAP']) {
        setUnifrom(
            program,
            'u_MetallicRoughnessSampler',
            ShaderVariableType.SAMPLER_2D,
            new Int32List.fromList([
              material.pbrMetallicRoughness.metallicRoughnessTexture.texture
                  .textureId + skipTexture
            ]));
      }

      double roughness = material.pbrMetallicRoughness.roughnessFactor;
      double metallic = material.pbrMetallicRoughness.metallicFactor;
      setUnifrom(
          program,
          'u_MetallicRoughnessValues',
          ShaderVariableType.FLOAT_VEC2,
          new Float32List.fromList([metallic, roughness]));

      setUnifrom(program, 'u_BaseColorFactor', ShaderVariableType.FLOAT_VEC4,
          material.pbrMetallicRoughness.baseColorFactor);

      // > Debug values => see in pbr fragment shader

      double specularReflectionMask = 0.0;
      double geometricOcclusionMask = 0.0;
      double microfacetDistributionMask = 0.0;
      double specularContributionMask = 0.0;
      setUnifrom(
          program,
          'u_ScaleFGDSpec',
          ShaderVariableType.FLOAT_VEC4,
          new Float32List.fromList([
            specularReflectionMask,
            geometricOcclusionMask,
            microfacetDistributionMask,
            specularContributionMask
          ]));

      double diffuseContributionMask = 0.0;
      double colorMask = 0.0;
      double metallicMask = 0.0;
      double roughnessMask = 0.0;
      setUnifrom(
          program,
          'u_ScaleDiffBaseMR',
          ShaderVariableType.FLOAT_VEC4,
          new Float32List.fromList([
            diffuseContributionMask,
            colorMask,
            metallicMask,
            roughnessMask
          ]));

      double diffuseIBLAmbient = 1.0;
      double specularIBLAmbient = 1.0;
      setUnifrom(program, 'u_ScaleIBLAmbient', ShaderVariableType.FLOAT_VEC4,
          new Float32List.fromList([
            diffuseIBLAmbient,
            specularIBLAmbient,
            1.0,
            1.0
          ]));
    }
    return program;
  }

  void drawNodes(List<GLTFNode> nodes) {
    debug.logCurrentFunction();
    for (var i = 0; i < nodes.length; i++) {
      GLTFNode node = nodes[i];
      if (node.mesh != null) {
        GLTFMeshPrimitive primitive = node.mesh.primitives[0];
        webgl.Program program = setupProgram(primitive, node.matrix);
        setupNodeMesh(program, node);
        drawNodeMesh(program, primitive);
      }
      drawNodes(node.children);
    }
  }

  void setupNodeMesh(webgl.Program program, GLTFNode node) {
    debug.logCurrentFunction();

    GLTFMeshPrimitive primitive = node.mesh.primitives[0];

    //bind
    for (String attributName in primitive.attributes.keys) {
      bindVertexArrayData(
          program, attributName, primitive.attributes[attributName]);
    }
    if (primitive.indices != null) {
      bindIndices(primitive.indices);
    }
  }

  void drawNodeMesh(webgl.Program program, GLTFMeshPrimitive primitive) {
    debug.logCurrentFunction();

    if (primitive.indices == null) {
      String attributName = 'POSITION';
      GLTFAccessor accessorPosition = primitive.attributes[attributName];
      gl.drawArrays(
          primitive.mode, accessorPosition.byteOffset, accessorPosition.count);
    } else {
      GLTFAccessor accessorIndices = primitive.indices;
      debug.logCurrentFunction(
          'gl.drawElements(${primitive.mode}, ${accessorIndices.count}, ${accessorIndices.componentType}, ${accessorIndices.byteOffset});');
      gl.drawElements(primitive.mode, accessorIndices.count,
          accessorIndices.componentType, accessorIndices.byteOffset);
    }
  }

  void bindVertexArrayData(
      webgl.Program program, String attributName, GLTFAccessor accessor) {
    GLTFBuffer bufferData = accessor.bufferView.buffer;
    Float32List verticesInfos = bufferData.data.buffer.asFloat32List(
        accessor.byteOffset + accessor.bufferView.byteOffset,
        accessor.count * (accessor.byteStride ~/ accessor.componentLength));

    //The offset of an accessor into a bufferView and the offset of an accessor into a buffer must be a multiple of the size of the accessor's component type.
    assert((accessor.bufferView.byteOffset + accessor.byteOffset) %
            accessor.componentLength ==
        0);

    //Each accessor must fit its bufferView, so next expression must be less than or equal to bufferView.length
    assert(accessor.byteOffset +
            accessor.byteStride * (accessor.count - 1) +
            (accessor.components * accessor.componentLength) <=
        accessor.bufferView.byteLength);

    debug.logCurrentFunction('$attributName');
    debug.logCurrentFunction(verticesInfos.toString());

    //>
    initBuffer(accessor.bufferView.usage, verticesInfos);
    //>
    setAttribut(program, attributName, accessor);
  }

  /// BufferType bufferType
  void initBuffer(int bufferType, TypedData data) {
    debug.logCurrentFunction();

    webgl.Buffer buffer =
        gl.createBuffer(); // Todo (jpu) : Should re-use the created buffer
    gl.bindBuffer(bufferType, buffer);
    gl.bufferData(bufferType, data, BufferUsageType.STATIC_DRAW);
  }

  /// [componentCount] => ex : 3 (x, y, z)
  void setAttribut(
      webgl.Program program, String attributName, GLTFAccessor accessor) {
    debug.logCurrentFunction('$attributName');

    String shaderAttributName;
    if (attributName == 'TEXCOORD_0') {
      shaderAttributName = 'a_UV';
    } else {
      shaderAttributName = 'a_${capitalize(attributName)}';
    }

    //>
    int attributLocation = gl.getAttribLocation(program, shaderAttributName);

    //if exist
    if (attributLocation >= 0) {
      int components = accessor.components;

      /// ShaderVariableType componentType
      int componentType = accessor.componentType;
      bool normalized = accessor.normalized;

      // how many bytes to move to the next vertex
      // 0 = use the correct stride for type and numComponents
      int stride = accessor.byteStride;

      // start at the beginning of the buffer that contains the sent data in the initBuffer.
      // Do not take the accesors offset. Actually, one buffer is created by attribut so start at 0
      int offset = 0;

      debug.logCurrentFunction(
          'gl.vertexAttribPointer($attributLocation, $components, $componentType, $normalized, $stride, $offset);');
      debug.logCurrentFunction('$accessor');

      //>
      gl.vertexAttribPointer(attributLocation, components, componentType,
          normalized, stride, offset);
      gl.enableVertexAttribArray(
          attributLocation); // turn on getting data out of a buffer for this attribute
    }
  }

  void bindIndices(GLTFAccessor accessorIndices) {
    debug.logCurrentFunction();

    Uint16List indices = accessorIndices.bufferView.buffer.data.buffer
        .asUint16List(
            accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
            accessorIndices.count);
    debug.logCurrentFunction(indices.toString());

    initBuffer(accessorIndices.bufferView.usage, indices);
  }

  /// ShaderVariableType componentType
  void setUnifrom(webgl.Program program, String uniformName, int componentType,
      TypedData data) {
    debug.logCurrentFunction(uniformName);

    webgl.UniformLocation uniformLocation =
        gl.getUniformLocation(program, uniformName);

    bool transpose = false;

    switch (componentType) {
      case ShaderVariableType.SAMPLER_CUBE:
      case ShaderVariableType.SAMPLER_2D:
        gl.uniform1i(uniformLocation, (data as Int32List)[0]);
        break;
      case ShaderVariableType.FLOAT:
        gl.uniform1f(uniformLocation, (data as Float32List)[0]);
        break;
      case ShaderVariableType.FLOAT_VEC2:
        gl.uniform2fv(uniformLocation, data as Float32List);
        break;
      case ShaderVariableType.FLOAT_VEC3:
        gl.uniform3fv(uniformLocation, data as Float32List);
        break;
      case ShaderVariableType.FLOAT_VEC4:
        gl.uniform4fv(uniformLocation, data as Float32List);
        break;
      case ShaderVariableType.FLOAT_MAT4:
        gl.uniformMatrix4fv(uniformLocation, transpose, data);
        break;
      default:
        throw new Exception(
            'renderer setUnifrom exception : Trying to set a uniform for a not defined component type');
        break;
    }
  }

  webgl.Program initProgram(
      ShaderSource shaderSource, Map<String, bool> defines) {
    debug.logCurrentFunction();

    globalState
      ..vertSource = shaderSource.vsCode
      ..fragSource = shaderSource.fsCode;

    String definesToString(Map<String, bool> defines) {
      String outStr = '';
      for (String def in defines.keys) {
        if (defines[def]) {
          outStr += '#define $def ${defines[def]}\n';
        }
      }
      return outStr;
    }

    ;

    String shaderDefines = "";
    if (shaderSource.shaderType == 'kronos_gltf_pbr_test') {
      shaderDefines = definesToString(defines);
//      if (globalState.hasLODExtension != null) {
//        shaderDefines += '#define USE_TEX_LOD 1\n';
//      }
    }
    webgl.Shader vertexShader = createShader(
        ShaderType.VERTEX_SHADER, globalState.vertSource, shaderDefines);
    webgl.Shader fragmentShader = createShader(
        ShaderType.FRAGMENT_SHADER, globalState.fragSource, shaderDefines);

    webgl.Program program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS)
            as bool ==
        false) {
      throw "Could not link the shader program! > ${gl.getProgramInfoLog(program)}";
    }
    gl.validateProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.VALIDATE_STATUS)
            as bool ==
        false) {
      throw "Could not validate program! > ${gl.getProgramInfoLog(program)} > ${gl.getProgramInfoLog(program)}";
    }

    return program;
  }

  /// ShaderType type
  webgl.Shader createShader(
      int type, String shaderSource, String shaderDefines) {
    debug.logCurrentFunction();

    webgl.Shader shader = gl.createShader(type);
    gl.shaderSource(shader, shaderDefines + shaderSource);
    gl.compileShader(shader);
    bool compiled =
        gl.getShaderParameter(shader, ShaderParameters.COMPILE_STATUS) as bool;
    if (!compiled) {
      String compilationLog = gl.getShaderInfoLog(shader);
      throw "Could not compile $type shader:\n\n $compilationLog}";
    }

    return shader;
  }

  //text utils
  String capitalize(String s) =>
      s[0].toUpperCase() + s.substring(1).toLowerCase();

  void update() {
    debug.logCurrentFunction();

    interaction.update();

    for (int i = 0; i < gltfProject.animations.length; i++) {
      GLTFAnimation animation = gltfProject.animations[i];
      for (int j = 0; i < animation.channels.length; i++) {
        GLTFAnimationChannel channel = animation.channels[j];

        ByteBuffer byteBuffer = getNextInterpolatedValues(channel.sampler);
        channel.target.node.rotation = new Quaternion.fromBuffer(byteBuffer, 0);
      }
    }
  }

  ByteBuffer getNextInterpolatedValues(GLTFAnimationSampler sampler) {
    debug.logCurrentFunction();

    Float32List keyTimes = getKeyTimes(sampler.input);
    Float32List keyValues = getKeyValues(sampler.output);

    num playTime =
        (currentTime / 1000) % keyTimes.last; // Todo (jpu) : find less cost ?

    //> playtime range
    int previousIndex = 0;
    double previousTime = 0.0;
    while (keyTimes[previousIndex] < playTime) {
      previousTime = keyTimes[previousIndex];
      previousIndex++;
    }
    previousIndex--;

    int nextIndex = (previousIndex + 1) % keyTimes.length;
    double nextTime = keyTimes[nextIndex];

    //> values
    Float32List previousValues = keyValues.buffer.asFloat32List(
        sampler.output.byteOffset +
            previousIndex *
                sampler.output.components *
                sampler.output.componentLength,
        sampler.output.components);
    Float32List nextValues = keyValues.buffer.asFloat32List(
        sampler.output.byteOffset +
            nextIndex *
                sampler.output.components *
                sampler.output.componentLength,
        sampler.output.components);

    double interpolationValue =
        (playTime - previousTime) / (nextTime - previousTime);

    // Todo (jpu) : add easer ratio interpolation

    Quaternion result = getQuaternionInterpolation(
        previousValues,
        nextValues,
        interpolationValue,
        previousIndex,
        previousTime,
        playTime,
        nextIndex,
        nextTime);

    return result.storage.buffer;
  }

  Quaternion getQuaternionInterpolation(
      Float32List previousValues,
      Float32List nextValues,
      double interpolationValue,
      int previousIndex,
      double previousTime,
      num playTime,
      int nextIndex,
      double nextTime) {
    debug.logCurrentFunction();

    Quaternion previous = new Quaternion.fromFloat32List(previousValues);
    Quaternion next = new Quaternion.fromFloat32List(nextValues);

    //
    double angle = next.radians - previous.radians;
    if (angle.abs() > PI) {
      next[3] *= -1;
    }

    Quaternion result = slerp(previous, next, interpolationValue);

    debug.logCurrentFunction('interpolationValue : $interpolationValue');
    debug.logCurrentFunction(
        'previous : $previousIndex > ${previousTime.toStringAsFixed(3)} \t: ${degrees(previous.radians).toStringAsFixed(3)} ${previousTime.toStringAsFixed(3)} \t| $previous');
    debug.logCurrentFunction(
        'result   : - > ${playTime.toStringAsFixed(3)} \t: ${degrees(result.radians).toStringAsFixed(3)} ${playTime.toStringAsFixed(3)} \t| $result');
    debug.logCurrentFunction(
        'next     : $nextIndex > ${nextTime.toStringAsFixed(3)} \t: ${degrees(next.radians).toStringAsFixed(3)} ${nextTime.toStringAsFixed(3)} \t| $next');
    debug.logCurrentFunction('');

    return result;
  }

  Float32List getInterpolatedValues(Float32List previousValues,
      Float32List nextValues, num interpolationValue) {
    debug.logCurrentFunction();

    Float32List result = new Float32List(previousValues.length);

    for (int i = 0; i < previousValues.length; i++) {
      result[i] = previousValues[i] +
          interpolationValue * (nextValues[i] - previousValues[i]);
    }
    return result;
  }

  Quaternion slerp(Quaternion qa, Quaternion qb, double t) {
    debug.logCurrentFunction();

    // quaternion to return
    Quaternion qm = new Quaternion.identity();

    // Calculate angle between them.
    double cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

    // if qa=qb or qa=-qb then theta = 0 and we can return qa
    if (cosHalfTheta.abs() >= 1.0) {
      qm.w = qa.w;
      qm.x = qa.x;
      qm.y = qa.y;
      qm.z = qa.z;
      return qm;
    }

    // Calculate temporary values.
    double halfTheta = acos(cosHalfTheta);
    double sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta);

    // if theta = 180 degrees then result is not fully defined
    // we could rotate around any axis normal to qa or qb
    if (sinHalfTheta.abs() < 0.001) {
      qm.w = (qa.w * 0.5 + qb.w * 0.5);
      qm.x = (qa.x * 0.5 + qb.x * 0.5);
      qm.y = (qa.y * 0.5 + qb.y * 0.5);
      qm.z = (qa.z * 0.5 + qb.z * 0.5);
      return qm;
    }
    double ratioA = sin((1 - t) * halfTheta) / sinHalfTheta;
    double ratioB = sin(t * halfTheta) / sinHalfTheta;

    //calculate Quaternion.
    qm.w = (qa.w * ratioA + qb.w * ratioB);
    qm.x = (qa.x * ratioA + qb.x * ratioB);
    qm.y = (qa.y * ratioA + qb.y * ratioB);
    qm.z = (qa.z * ratioA + qb.z * ratioB);

    return qm;
  }

  Float32List getKeyTimes(GLTFAccessor accessor) {
    debug.logCurrentFunction();

    Float32List keyTimes = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.byteOffset, accessor.count * accessor.components);
    return keyTimes;
  }

  // Todo (jpu) : try to return only buffer
  Float32List getKeyValues(GLTFAccessor accessor) {
    debug.logCurrentFunction();

    Float32List keyValues = accessor.bufferView.buffer.data.buffer
        .asFloat32List(
            accessor.byteOffset, accessor.count * accessor.components);
    return keyValues;
  }
}
