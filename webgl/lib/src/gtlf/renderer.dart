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
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/utils/utils_debug.dart' as debug;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

// Uint8List = Byte
// Uint16List = SCALAR : int

class GLTFRenderer {
  GLTFProject gltf;
  GLTFScene get activeScene => gltf.scenes[0];

  webgl.RenderingContext gl;
  GlobalState globalState;

  Camera activeCameraNode;
  Matrix4 viewMatrix = new Matrix4.identity();
  Matrix4 projectionMatrix = new Matrix4.identity();

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
  }

  Future render() async {
    await ShaderSource.loadShaders();

    // Todo (jpu) :
    if(gltf.textures.length > 0) {
      GLTFTexture gltfTexture = gltf.textures[0];
      //load image
      String fileUrl = gltf.baseDirectory + gltfTexture.source.uri.toString();
      ImageElement imageElement = await TextureUtils.loadImage(fileUrl);
      //create texture
      webgl.Texture texture = gl.createTexture();
      //bind it to an active texture unit
      gl.activeTexture(TextureUnit.TEXTURE0.index);
      gl.bindTexture(TextureTarget.TEXTURE_2D.index, texture);
      //fill texture data
      int mipMapLevel = 0;
      gl.texImage2D(TextureAttachmentTarget.TEXTURE_2D.index, mipMapLevel,
          TextureInternalFormat.RGBA.index, TextureInternalFormat.RGBA.index,
          TexelDataType.UNSIGNED_BYTE.index, imageElement);
      //set unit format
      gl.texParameteri(TextureTarget.TEXTURE_2D.index,
          TextureParameter.TEXTURE_MAG_FILTER.index,
          gltfTexture.sampler.magFilter.index);
      gl.texParameteri(TextureTarget.TEXTURE_2D.index,
          TextureParameter.TEXTURE_MIN_FILTER.index,
          gltfTexture.sampler.minFilter
              .index); // //TextureFilterType.LINEAR.index
      gl.texParameteri(
          TextureTarget.TEXTURE_2D.index, TextureParameter.TEXTURE_WRAP_S.index,
          gltfTexture.sampler.wrapS.index);
      gl.texParameteri(
          TextureTarget.TEXTURE_2D.index, TextureParameter.TEXTURE_WRAP_T.index,
          gltfTexture.sampler.wrapT.index);
      gl.generateMipmap(TextureTarget.TEXTURE_2D.index);
    }
    //>
    _init();
    _render();
  }

  num currentTime = 0;
  num deltaTime = 0;
  num timeFps = 0;
  int fps = 0;
  num speedFactor  = 1.0;
  void _render({num time: 0.0}) {
    debug.logCurrentFunction('\n------------------------------------------------');

    deltaTime = time - currentTime;
    timeFps += deltaTime;
    fps++;
    currentTime = time * speedFactor;

    if(fps >= 1000) {
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

    // Enable depth test
    gl.enable(webgl.DEPTH_TEST);

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT.index | ClearBufferMask.DEPTH_BUFFER_BIT.index);

    setupCameras();

    webgl.Program program = setupProgram();

    //draw
    List<GLTFNode> nodes = activeScene.nodes;
    drawNodes(nodes, program);
  }

  void setupCameras() {
    debug.logCurrentFunction();

    Camera currentCamera;

    //find first activeScene camera
    currentCamera = findActiveSceneCamera(activeScene.nodes);
    //or use first in project else default
    if(currentCamera == null){
      currentCamera = findActiveSceneCamera(gltf.nodes);
    }
    if(currentCamera == null){
      if(gltf.cameras.length > 0) {
        currentCamera = gltf.cameras[0];
      }else{
        currentCamera = new GLTFCameraPerspective(0.2, 10000.0, 0.01)
          ..targetPosition = new Vector3(0.0, 0.0, 0.0);
//          ..targetPosition = new Vector3(0.0, .03, 0.0);//Avocado
      }
      currentCamera.position = new Vector3(0.0, 0.0, -1.0);
//      currentCamera.position = new Vector3(.5, 0.0, 0.2);//Avocado
    }

    //>
    activeCameraNode = currentCamera;
    if(activeCameraNode is GLTFCameraPerspective){
      GLTFCameraPerspective camera = activeCameraNode as GLTFCameraPerspective;
      viewMatrix = camera.viewMatrix;
      projectionMatrix = camera.projectionMatrix;
    }else{
      // ortho ?
    }
  }

  Camera findActiveSceneCamera(List<GLTFNode> nodes){
    Camera result;

    for (var i = 0; i < nodes.length && result == null; i++) {
      GLTFNode node = nodes[i];
      if(node.camera != null){
        setupNodeCamera(node);
        result = node.camera;
      }else{
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

  webgl.Program setupProgram() {
    debug.logCurrentFunction();

    GLTFMaterial material = gltf.materials[0];// Todo (jpu) : what if mutliple materials ?
    GLTFPbrMetallicRoughness pbrMaterial;
    ShaderSource shaderSource;
    bool debugWithDefault = false;
    if(material == null || debugWithDefault){
      shaderSource = ShaderSource.sources['kronos_gltf_default'];
    }else{
      pbrMaterial = material.pbrMetallicRoughness;
      shaderSource = ShaderSource.sources['kronos_gltf_pbr_test'];
    }

    // Todo (jpu) : place this elsewhere
    Map<String, bool> defines = new Map();
    defines['HAS_NORMALS'] = false; // Todo (jpu) : => only if gltf primitive has NORMAL attribut
    defines['HAS_TANGENTS'] = false; // Todo (jpu) : => only if gltf primitive has TANGENT attribut
    defines['HAS_UV'] = true; // Todo (jpu) : => only if gltf primitive has TEXCOORD_0 attribut
    defines['HAS_BASECOLORMAP'] = true; // Todo (jpu) : => only if gltf primitive has TEXCOORD_0 attribut and a baseColorTexture
    defines['USE_IBL'] = false; // Todo (jpu) :

    // Todo (jpu) : is this really usefull
    globalState
      ..uniforms = {}
      ..attributes = {};

    webgl.Program program = initProgram(shaderSource, defines);
    gl.useProgram(program);

    setUnifrom(program,'u_ViewMatrix',ShaderVariableType.FLOAT_MAT4,viewMatrix.storage);
    setUnifrom(program,'u_ProjectionMatrix',ShaderVariableType.FLOAT_MAT4,projectionMatrix.storage);

    debug.logCurrentFunction('u_ViewMatrix pos : ${viewMatrix.getTranslation()}');
    debug.logCurrentFunction('activeCameraNode pos : ${activeCameraNode.position}');
    debug.logCurrentFunction('activeCameraNode target pos : ${(activeCameraNode as GLTFCameraPerspective).targetPosition}');
    debug.logCurrentFunction('activeCameraNode target pos : ${(activeCameraNode as GLTFCameraPerspective).viewProjectionMatrix.getTranslation()}');

    if(pbrMaterial != null){
      setUnifrom(program, 'u_MVPMatrix', ShaderVariableType.FLOAT_MAT4,
          ((projectionMatrix * viewMatrix) as Matrix4).storage);

      setUnifrom(program,'u_LightDirection',ShaderVariableType.FLOAT_VEC3, new Float32List.fromList([1.0, 1.0, 1.0]));// Todo (jpu) : define light global if needed. it's the direction from where the light is comming to origin
      setUnifrom(program,'u_LightColor',ShaderVariableType.FLOAT_VEC3, new Float32List.fromList([1.0, 1.0, 0.0]));

      // Todo (jpu) :
      if(pbrMaterial.baseColorTexture != null) {
        setUnifrom(program, 'u_BaseColorSampler', ShaderVariableType.SAMPLER_2D,
            new Int32List.fromList([0])); // Todo (jpu) : textureunit0 ?
      }

      double roughness = material.pbrMetallicRoughness.roughnessFactor;
      double metallic = material.pbrMetallicRoughness.metallicFactor;
      setUnifrom(program,'u_MetallicRoughnessValues',ShaderVariableType.FLOAT_VEC2, new Float32List.fromList([metallic, roughness]));

      setUnifrom(program,'u_BaseColorFactor',ShaderVariableType.FLOAT_VEC4, material.pbrMetallicRoughness.baseColorFactor);

      setUnifrom(program,'u_Camera',ShaderVariableType.FLOAT_VEC3, (activeCameraNode.position).storage);

      //> Debug values => see in pbr fragment shader

      double specularReflectionMask = 0.0;
      double geometricOcclusionMask = 0.0;
      double microfacetDistributionMask = 0.0;
      double specularContributionMask = 0.0;
      setUnifrom(program,'u_ScaleFGDSpec',ShaderVariableType.FLOAT_VEC4, new Float32List.fromList([
        specularReflectionMask,
        geometricOcclusionMask,
        microfacetDistributionMask,
        specularContributionMask
      ]));

      double diffuseContributionMask = 0.0;
      double colorMask = 1.0;
      double metallicMask = 0.0;
      double roughnessMask = 0.0;
      setUnifrom(program,'u_ScaleDiffBaseMR',ShaderVariableType.FLOAT_VEC4, new Float32List.fromList([
        diffuseContributionMask,
        colorMask,
        metallicMask,
        roughnessMask
      ]));

//      setUnifrom(program,'u_ScaleIBLAmbient',ShaderVariableType.FLOAT_VEC4, new Float32List.fromList([1.0, 1.0, 1.0, 1.0]));

    }
    return program;
  }

  void drawNodes(List<GLTFNode> nodes, webgl.Program program) {
    debug.logCurrentFunction();
    for (var i = 0; i < nodes.length; i++) {
      GLTFNode node = nodes[i];
      if(node.mesh != null){
        setupNodeMesh(program, node);
        drawNodeMesh(program, node.mesh.primitives[0]);
      }
      drawNodes(node.children, program);
    }
  }

  void setupNodeMesh(webgl.Program program, GLTFNode node) {
    debug.logCurrentFunction();

    GLTFMeshPrimitive primitive = node.mesh.primitives[0];

    //bind
    for (String attributName in primitive.attributes.keys) {
      bindVertexArrayData(program, attributName, primitive.attributes[attributName]);
    }
    if(primitive.indices != null){
      bindIndices(primitive.indices);
    }

    //uniform
    setUnifrom(program,'u_ModelMatrix',ShaderVariableType.FLOAT_MAT4,node.matrix.storage);
    debug.logCurrentFunction('u_ModelMatrix pos : ${node.matrix.getTranslation()}');
  }

  void drawNodeMesh(webgl.Program program, GLTFMeshPrimitive primitive) {
    debug.logCurrentFunction();

    if (primitive.indices == null) {
      String attributName = 'POSITION';
      GLTFAccessor accessorPosition = primitive.attributes[attributName];
      gl.drawArrays(primitive.mode.index, accessorPosition.byteOffset, accessorPosition.count);
    } else {
      GLTFAccessor accessorIndices = primitive.indices;
      debug.logCurrentFunction('gl.drawElements(${primitive.mode}, ${accessorIndices.count}, ${accessorIndices.componentType}, ${accessorIndices.byteOffset});');
      gl.drawElements(primitive.mode.index, accessorIndices.count,
          accessorIndices.componentType.index, accessorIndices.byteOffset);
    }
  }

  void bindVertexArrayData(webgl.Program program, String attributName, GLTFAccessor accessor) {
    GLTFBuffer bufferData = accessor.bufferView.buffer;
    Float32List verticesInfos = bufferData.data.buffer.asFloat32List(
        accessor.byteOffset + accessor.bufferView.byteOffset,
        accessor.count * (accessor.byteStride ~/ accessor.componentLength));

    //The offset of an accessor into a bufferView and the offset of an accessor into a buffer must be a multiple of the size of the accessor's component type.
    assert((accessor.bufferView.byteOffset + accessor.byteOffset) % accessor.componentLength == 0);

    //Each accessor must fit its bufferView, so next expression must be less than or equal to bufferView.length
    assert(accessor.byteOffset + accessor.byteStride * (accessor.count - 1) + (accessor.components * accessor.componentLength) <= accessor.bufferView.byteLength);

    debug.logCurrentFunction('$attributName');
    debug.logCurrentFunction(verticesInfos.toString());

    //>
    initBuffer(accessor.bufferView.usage, verticesInfos);

    //>
    setAttribut(program, attributName, accessor);
  }

  void initBuffer(BufferType bufferType, TypedData data) {
    debug.logCurrentFunction();

    webgl.Buffer buffer = gl.createBuffer();// Todo (jpu) : Should re-use the created buffer
    gl.bindBuffer(bufferType.index, buffer);
    gl.bufferData(bufferType.index, data, BufferUsageType.STATIC_DRAW.index);
  }

  /// [componentCount] => ex : 3 (x, y, z)
  void setAttribut(webgl.Program program, String attributName, GLTFAccessor accessor) {
    debug.logCurrentFunction('$attributName');

    String shaderAttributName;
    if(attributName == 'TEXCOORD_0')  {
      shaderAttributName = 'a_UV';
    } else {
      shaderAttributName = 'a_${capitalize(attributName)}';
    }

    //>
    int attributLocation = gl.getAttribLocation(program, shaderAttributName);

    //if exist
    if(attributLocation >= 0) {
      int components = accessor.components;
      ShaderVariableType componentType = accessor.componentType;
      bool normalized = accessor.normalized;
      int stride = accessor.byteStride; // how many bytes to move to the next vertex
                                        // 0 = use the correct stride for type and numComponents
      int offset = 0; // start at the beginning of the buffer that contained the sent data in the initBuffer.
                      // Do not take the accesors offset. Actually, one buffer is created by attribut so start at 0

      debug.logCurrentFunction(
          'gl.vertexAttribPointer($attributLocation, $components, $componentType, $normalized, $stride, $offset);');
      debug.logCurrentFunction('$accessor');

      //>
      gl.vertexAttribPointer(
          attributLocation, components, componentType.index, normalized, stride,
          offset);
      gl.enableVertexAttribArray(
          attributLocation); // turn on getting data out of a buffer for this attribute
    }

  }

  void bindIndices(GLTFAccessor accessorIndices) {
    debug.logCurrentFunction();

    Uint16List indices = accessorIndices.bufferView.buffer.data.buffer
        .asUint16List(accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset, accessorIndices.count);
    debug.logCurrentFunction(indices.toString());

    initBuffer(accessorIndices.bufferView.usage, indices);
  }

  void setUnifrom(webgl.Program program,String uniformName, ShaderVariableType componentType, TypedData data){
    debug.logCurrentFunction(uniformName);

    webgl.UniformLocation uniformLocation = gl.getUniformLocation(program, uniformName);

    bool transpose = false;

    switch(componentType){
      case ShaderVariableType.SAMPLER_2D:
        gl.uniform1i(uniformLocation, (data as Int32List)[0]);
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
        throw new Exception('Trying to set a uniform for a not defined component type');
        break;
    }
  }

  webgl.Program initProgram(ShaderSource shaderSource, Map<String, bool> defines) {
    debug.logCurrentFunction();

    globalState
      ..vertSource = shaderSource.vsCode
      ..fragSource = shaderSource.fsCode;

    String definesToString (Map<String, bool> defines) {
      String outStr = '';
      for (String def in defines.keys) {
        if(defines[def]) {
          outStr += '#define $def ${defines[def]}\n';
        }
      }
      return outStr;
    };

    String shaderDefines = "";
    if(shaderSource.shaderType == 'kronos_gltf_pbr_test') {
      shaderDefines = definesToString(defines);
      if (globalState.hasLODExtension != null) {
        shaderDefines += '#define USE_TEX_LOD 1\n';
      }
    }
    webgl.Shader vertexShader = createShader(ShaderType.VERTEX_SHADER, globalState.vertSource, shaderDefines);
    webgl.Shader fragmentShader = createShader(ShaderType.FRAGMENT_SHADER, globalState.fragSource, shaderDefines);

    webgl.Program program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS.index) as bool ==
        false) {
      throw "Could not link the shader program! > ${gl.getProgramInfoLog(program)}";
    }
    gl.validateProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.VALIDATE_STATUS.index) as bool ==
        false) {
      throw "Could not compile program! > ${gl.getProgramInfoLog(program)} > ${gl.getProgramInfoLog(program)}";
    }

    return program;
  }

  webgl.Shader createShader(ShaderType type, String shaderSource, String shaderDefines) {
    debug.logCurrentFunction();

    webgl.Shader shader = gl.createShader(type.index);
    gl.shaderSource(shader, shaderDefines + shaderSource);
    gl.compileShader(shader);
    bool compiled = gl.getShaderParameter(shader, ShaderParameters.COMPILE_STATUS.index) as bool;
    if (!compiled) {
      String compilationLog = gl.getShaderInfoLog(shader);
      throw "Could not compile $type shader:\n\n $compilationLog}";
    }

    return shader;
  }



  //text utils
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();

  void update() {
    debug.logCurrentFunction();

    for (int i = 0; i < gltfProject.animations.length; i++) {
      GLTFAnimation animation = gltfProject.animations[i];
      for (int j = 0; i < animation.channels.length; i++) {
        GLTFAnimationChannel channel = animation.channels[j];

        ByteBuffer byteBuffer = getNextInterpolatedValues(channel.sampler);
        channel.target.node.rotation = new Quaternion.fromBuffer(byteBuffer, 0);
      }
    }
  }

  ByteBuffer getNextInterpolatedValues(GLTFAnimationSampler sampler){
    debug.logCurrentFunction();

    Float32List keyTimes = getKeyTimes(sampler.input);
    Float32List keyValues = getKeyValues(sampler.output);

    num playTime = (currentTime / 1000) % keyTimes.last;// Todo (jpu) : find less cost ?

    //> playtime range
    int previousIndex = 0;
    double previousTime = 0.0;
    while (keyTimes[previousIndex] < playTime){
      previousTime = keyTimes[previousIndex];
      previousIndex++;
    }
    previousIndex--;

    int nextIndex = (previousIndex + 1) % keyTimes.length;
    double nextTime = keyTimes[nextIndex];


    //> values
    Float32List previousValues = keyValues.buffer.asFloat32List(sampler.output.byteOffset + previousIndex * sampler.output.components * sampler.output.componentLength, sampler.output.components);
    Float32List nextValues = keyValues.buffer.asFloat32List(sampler.output.byteOffset + nextIndex * sampler.output.components * sampler.output.componentLength, sampler.output.components);

    double interpolationValue = (playTime - previousTime) / (nextTime - previousTime);

    // Todo (jpu) : add easer ratio interpolation

    Quaternion result = getQuaternionInterpolation(previousValues, nextValues, interpolationValue, previousIndex, previousTime, playTime, nextIndex, nextTime);

    return result.storage.buffer;
  }

  Quaternion getQuaternionInterpolation(Float32List previousValues, Float32List nextValues, double interpolationValue, int previousIndex, double previousTime, num playTime, int nextIndex, double nextTime) {
    debug.logCurrentFunction();

    Quaternion previous = new Quaternion.fromFloat32List(previousValues);
    Quaternion next = new Quaternion.fromFloat32List(nextValues);

    //
    double angle = next.radians - previous.radians;
    if( angle.abs() > PI){
      next[3] *= -1;
    }

    Quaternion result = slerp(previous, next, interpolationValue);

    debug.logCurrentFunction('interpolationValue : $interpolationValue');
    debug.logCurrentFunction('previous : $previousIndex > ${previousTime.toStringAsFixed(3)} \t: ${degrees(previous.radians).toStringAsFixed(3)} ${previousTime.toStringAsFixed(3)} \t| $previous');
    debug.logCurrentFunction('result   : - > ${playTime.toStringAsFixed(3)} \t: ${degrees(result.radians).toStringAsFixed(3)} ${playTime.toStringAsFixed(3)} \t| $result');
    debug.logCurrentFunction('next     : $nextIndex > ${nextTime.toStringAsFixed(3)} \t: ${degrees(next.radians).toStringAsFixed(3)} ${nextTime.toStringAsFixed(3)} \t| $next');
    debug.logCurrentFunction('');

    return result;
  }

  Float32List getInterpolatedValues(Float32List previousValues, Float32List nextValues, num interpolationValue){
    debug.logCurrentFunction();

    Float32List result = new Float32List(previousValues.length);

    for (int i = 0; i < previousValues.length; i++) {
      result[i] = previousValues[i] + interpolationValue * (nextValues[i] - previousValues[i]);
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
    if (cosHalfTheta.abs() >= 1.0){
      qm.w = qa.w;
      qm.x = qa.x;
      qm.y = qa.y;
      qm.z = qa.z;
      return qm;
    }

    // Calculate temporary values.
    double halfTheta = acos(cosHalfTheta);
    double sinHalfTheta = sqrt(1.0 - cosHalfTheta*cosHalfTheta);

    // if theta = 180 degrees then result is not fully defined
    // we could rotate around any axis normal to qa or qb
    if (sinHalfTheta.abs() < 0.001){
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

  Float32List getKeyTimes(GLTFAccessor accessor){
    debug.logCurrentFunction();

    Float32List keyTimes = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.byteOffset, accessor.count * accessor.components);
    return keyTimes;
  }

  // Todo (jpu) : try to return only buffer
  Float32List getKeyValues(GLTFAccessor accessor) {
    debug.logCurrentFunction();

    Float32List keyValues = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.byteOffset,
        accessor.count * accessor.components);
    return keyValues;
  }
}



