import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert' show base64;
import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/light/light.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart' as GLEnum;
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/context.dart' hide gl;
import 'package:webgl/src/context.dart' as ctxWrapper show gl;
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/gltf/mesh_primitive.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/renderer/renderer_utils.dart';
import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/animation.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture.dart';

abstract class Renderer{
  void render();
}

@reflector
class GLTFRenderer extends Renderer {

  // Direction from where the light is coming to origin
  DirectionalLight light;

  GlobalState globalState;

  int _reservedTextureUnits;

  webgl.RenderingContext get gl => ctxWrapper.gl;

  GLTFProject gltfProject;

  GLTFScene get currentScene => gltfProject.scenes.length > 0 ? gltfProject.scenes[0] : null;

  CameraPerspective get mainCamera => Context.mainCamera;

  CanvasElement _canvas;
  CanvasElement get canvas => _canvas;

  WebGLTexture brdfLUTTexture, cubeMapTextureDiffuse, cubeMapTextureSpecular;

  GLTFRenderer(this._canvas) {

    light = new DirectionalLight()
      ..translation = new Vector3(50.0, 50.0, -50.0)
      ..direction = new Vector3(50.0, 50.0, -50.0).normalized()
      ..color =  new Vector3(1.0, 1.0, 1.0);

    Context.init(_canvas);
    Context.resizeCanvas();
  }



  Future _initTextures() async {
    

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
    imageElement = await TextureUtils.loadImage('packages/webgl/images/utils/brdfLUT.png');
    magFilter = TextureFilterType.LINEAR;
    minFilter = TextureFilterType.LINEAR;
    wrapS = TextureWrapType.REPEAT;
    wrapT = TextureWrapType.REPEAT;
    brdfLUTTexture = new WebGLTexture.fromWebGL(createImageTexture(TextureUnit.TEXTURE0 + 0, imageElement, magFilter, minFilter, wrapS, wrapT), TextureTarget.TEXTURE_2D);

    //Environnement
    gl.activeTexture(TextureUnit.TEXTURE0 + 1);
    List<List<ImageElement>> papermill_diffuse =
        await TextureUtils.loadCubeMapImages('papermill_diffuse', webPath: 'packages/webgl/');
    cubeMapTextureDiffuse = TextureUtils.createCubeMapFromImages(papermill_diffuse, flip: false); //, textureInternalFormat: globalState.sRGBifAvailable
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureDiffuse.webGLTexture);

    gl.activeTexture(TextureUnit.TEXTURE0 + 2);
    List<List<ImageElement>> papermill_specular =
        await TextureUtils.loadCubeMapImages('papermill_specular', webPath: 'packages/webgl/');
    cubeMapTextureSpecular = TextureUtils.createCubeMapFromImages(papermill_specular, flip: false); //, textureInternalFormat: globalState.sRGBifAvailable
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureSpecular.webGLTexture);

    _reservedTextureUnits = 3;

    bool useDebugTexture = false;
    for (int i = 0; i < gltfProject.textures.length; i++) {
      int textureUnitId = 0;

      GLTFTexture gltfTexture;
      if (!useDebugTexture) {
        gltfTexture = gltfProject.textures[i];
        if (gltfTexture.source.data == null) {
          //load image
          String fileUrl =
              gltfProject.baseDirectory + gltfTexture.source.uri.toString();
          imageElement = await TextureUtils.loadImage(fileUrl);
          textureUnitId = gltfTexture.textureId;
        } else {
          String base64Encoded = base64.encode(gltfTexture.source.data);
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
      webgl.Texture texture = createImageTexture(TextureUnit.TEXTURE0 + textureUnitId + _reservedTextureUnits, imageElement, magFilter, minFilter, wrapS, wrapT);
      if(gltfTexture != null){
        gltfTexture.webglTexture = texture;
      }
    }
  }

  webgl.Texture createImageTexture(int textureUnitId, ImageElement imageElement, int magFilter, int minFilter, int wrapS, int wrapT) {
    

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

    return texture;
  }

  Future init(GLTFProject gltfProject) async {
    this.gltfProject = gltfProject;

    if(currentScene == null) throw new Exception("currentScene must be set before rendering.");

    await ShaderSource.loadShaders();
    //> Init extensions
    //This activate extensions
    var hasSRGBExt = gl.getExtension('EXT_SRGB');
    var hasLODExtension = gl.getExtension('EXT_shader_texture_lod');
    var hasDerivativesExtension = gl.getExtension('OES_standard_derivatives');
    var hasIndexUIntExtension = gl.getExtension('OES_element_index_uint');

    globalState = new GlobalState()
      ..hasLODExtension = hasLODExtension
      ..hasDerivativesExtension = hasDerivativesExtension
      ..hasIndexUIntExtension = hasIndexUIntExtension
      ..sRGBifAvailable =
      hasSRGBExt != null ? webgl.EXTsRgb.SRGB_EXT : webgl.WebGL.RGBA;

    await _initTextures();
    setupCameras();

    Context.backgroundColor = gltfProject.scene.backgroundColor;
  }

  void render() {
    try {
      Context.resizeCanvas();
      gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);
      drawNodes(currentScene.nodes);
    } catch (ex) {
      print("Error From renderer _render method: $ex ${StackTrace.current}");
    }
  }

  void drawNodes(List<GLTFNode> nodes) {
    
    for (int i = 0; i < nodes.length; i++) {
      GLTFNode node = nodes[i];
      drawNode(node);
      drawNodes(node.children);
    }
  }

  void drawNode(GLTFNode node){
    if (node.mesh != null) {
      GLTFMesh mesh = node.mesh;
      if (mesh.primitives != null) {

        for (int i = 0; i < mesh.primitives.length; i++) {
          GLTFMeshPrimitive primitive = mesh.primitives[i];

          primitive.bindMaterial(globalState?.hasLODExtension != null, _reservedTextureUnits);

          WebGLProgram program = primitive.program;
          gl.useProgram(program.webGLProgram);

          _setupPrimitiveBuffers(program, primitive);

          primitive.material.setupBeforeRender();
          primitive.material.pvMatrix = (mainCamera.projectionMatrix * mainCamera.viewMatrix) as Matrix4;
          primitive.material.setUniforms(
              program, (node.parentMatrix * node.matrix) as Matrix4, mainCamera.viewMatrix, mainCamera.projectionMatrix, mainCamera.translation, light);

          _drawPrimitive(primitive);
          primitive.material.setupAfterRender();
        }
      }
    }
  }

  void _setupPrimitiveBuffers(WebGLProgram program, GLTFMeshPrimitive primitive) {
    

    _bindVertexArrayData(program, primitive);

    if (primitive.indicesAccessor != null) {
      _bindIndices(primitive);
    }
  }

  void _bindVertexArrayData(
      WebGLProgram program, GLTFMeshPrimitive primitive) {
    

    for (String attributName in primitive.attributes.keys) {
      GLTFAccessor accessor = primitive.attributes[attributName];

      if(accessor.bufferView == null) throw 'bufferView must be defined';
      if(accessor.bufferView.buffer == null) throw 'buffer must be defined';

      Float32List verticesInfos = accessor.bufferView.buffer.data.buffer.asFloat32List(
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
          accessor.bufferView.byteLength, '${accessor.byteOffset +
          accessor.byteStride * (accessor.count - 1) +
          (accessor.components * accessor.componentLength)} <= ${accessor.bufferView.byteLength}');

      //debug.logCurrentFunction('$attributName');
      //debug.logCurrentFunction(verticesInfos.toString());

      //>
      _initBuffer(primitive, attributName, accessor.bufferView.usage, verticesInfos);

      //>
      _setAttribut(program, attributName, accessor);
    }
  }

  /// BufferType bufferType
  // Todo (jpu) : is it possible to use only one of the bufferViews
  void _initBuffer(GLTFMeshPrimitive primitive, String bufferName, int bufferType, TypedData data) {
    

    if(primitive.buffers[bufferName] == null) {
      primitive.buffers[bufferName] =
          gl.createBuffer();
      gl.bindBuffer(bufferType, primitive.buffers[bufferName]);
      gl.bufferData(bufferType, data, BufferUsageType.STATIC_DRAW);
    }else{
      gl.bindBuffer(bufferType, primitive.buffers[bufferName]);
    }
  }

  //text utils
  String _capitalize(String s) =>
      s[0].toUpperCase() + s.substring(1).toLowerCase();

  /// [componentCount] => ex : 3 (x, y, z)
  void _setAttribut(
      WebGLProgram program, String attributName, GLTFAccessor accessor) {
    //debug.logCurrentFunction('$attributName');

    String shaderAttributName;
    if (attributName == 'TEXCOORD_0') {
      shaderAttributName = 'a_UV';
    } else if(attributName == "COLOR_0"){
      shaderAttributName = 'a_Color';
    } else {
      shaderAttributName = 'a_${_capitalize(attributName)}';
    }

    //>
    program.attributLocations[attributName] ??= gl.getAttribLocation(program.webGLProgram, shaderAttributName);
    int attributLocation = program.attributLocations[attributName];

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

      //debug.logCurrentFunction(
//          'gl.vertexAttribPointer($attributLocation, $components, $componentType, $normalized, $stride, $offset);');
      //debug.logCurrentFunction('$accessor');

      //>
      gl.vertexAttribPointer(attributLocation, components, componentType,
          normalized, stride, offset);
      gl.enableVertexAttribArray(
          attributLocation); // turn on getting data out of a buffer for this attribute
    }
  }

  void _bindIndices(GLTFMeshPrimitive primitive) {
    
    GLTFAccessor accessorIndices = primitive.indicesAccessor;
    TypedData indices;
    if(accessorIndices.componentType == 5123 || accessorIndices.componentType == 5121) {
      indices = accessorIndices.bufferView.buffer.data.buffer
          .asUint16List(
          accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
          accessorIndices.count);
      //debug.logCurrentFunction(indices.toString());
    }else if(accessorIndices.componentType == 5125){
      if(globalState.hasIndexUIntExtension == null) throw "hasIndexUIntExtension : extension not supported";
      indices = accessorIndices.bufferView.buffer.data.buffer
          .asUint32List(
          accessorIndices.bufferView.byteOffset + accessorIndices.byteOffset,
          accessorIndices.count);
    }else{
      throw "_bindIndices : componentType not implemented ${GLEnum.VertexAttribArrayType.getByIndex(accessorIndices.componentType)}";
    }
    _initBuffer(primitive, 'INDICES', accessorIndices.bufferView.usage, indices);
  }

  int countImage = 0;
  void _drawPrimitive(GLTFMeshPrimitive primitive) {
    if (primitive.indicesAccessor == null || primitive.drawMode == DrawMode.POINTS) {
      GLTFAccessor accessorPosition = primitive.positionAccessor;
      if(accessorPosition == null) throw 'Mesh attribut Position accessor must almost have POSITION data defined :)';
      gl.drawArrays(
          primitive.drawMode, accessorPosition.byteOffset, accessorPosition.count);
    } else {
      GLTFAccessor accessorIndices = primitive.indicesAccessor;
      gl.drawElements(primitive.drawMode, accessorIndices.count,
          accessorIndices.componentType, 0);

//      if(countImage < 10) {
//        String dataUrl = canvas.toDataUrl();
//        ImageElement image = new ImageElement(src: dataUrl);
//        DivElement div = querySelector('#debug') as DivElement;
//        div.children.add(image);
//        countImage++;
//      }
    }
  }

  void setupCameras() {
    

    Camera currentCamera;

    bool debugCamera = false;

    if(debugCamera){
      currentCamera = new CameraPerspective(radians(47.0), 0.1, 1000.0)
        ..targetPosition = new Vector3(0.0, 0.0, 0.0)
        ..translation = new Vector3(10.0, 10.0, 10.0);
    }else {
      //find first activeScene camera
      currentCamera = findActiveSceneCamera(currentScene.nodes);
      //or use first in project else default
      if (currentCamera == null) {
        currentCamera = findActiveSceneCamera(gltfProject.nodes);
      }
      if (currentCamera == null) {
        if (gltfProject.cameras.length > 0) {
          currentCamera = gltfProject.cameras[0];
          GLTFNode node = gltfProject.nodes.firstWhere((n)=> n.name == currentCamera.name, orElse: ()=> null);
          currentCamera.matrix = node.matrix;
//          currentCamera.translation = node.translation;
//          currentCamera.rotation = node.rotation;
//          currentCamera.scale = node.scale;
        } else {
          currentCamera = new CameraPerspective(radians(47.0), 0.1, 100.0)
            ..targetPosition = new Vector3(0.0, 0.03, 0.0);
//          ..targetPosition = new Vector3(0.0, .03, 0.0);//Avocado
          currentCamera.translation = new Vector3(5.0, 5.0, 10.0);
        }

//      currentCamera.position = new Vector3(.5, 0.0, 0.2);//Avocado
      }
    }
    //>
    if (currentCamera is CameraPerspective) {
      Context.mainCamera = currentCamera;
    } else {
      // ortho ?
    }
  }

  Camera findActiveSceneCamera(List<GLTFNode> nodes) {

    Camera result;

    for (var i = 0; i < nodes.length && result == null; i++) {
      GLTFNode node = nodes[i];
      //Correction is from blender export but not yet used
      if (node.camera != null && !node.name.contains('Correction')) {
        setupNodeCamera(node);
        result = node.camera;
      }
    }

    return result;
  }

  void setupNodeCamera(GLTFNode node) {
    CameraPerspective camera = node.camera as CameraPerspective;
    camera.translation = node.translation;
  }

  // > updates

  void update() {
    for (int i = 0; i < gltfProject.animations.length; i++) {
      GLTFAnimation animation = gltfProject.animations[i];
      for (int j = 0; j < animation.channels.length; j++) {
        GLTFAnimationChannel channel = animation.channels[j];

        // Todo (jpu) : is it possible to refacto ByteBuffer outside switch ? see when doing weights
        switch(channel.target.path){
          case ChannelTargetPathType.translation:
            ByteBuffer byteBuffer = getNextInterpolatedValues(channel.sampler, channel.target.path);
            Vector3 result = new Vector3.fromBuffer(byteBuffer, 0);
            channel.target.node.translation = result;
//            channel.target.node.translation += new Vector3(0.0, 0.0, 0.1);
//            print(channel.target.node.translation);
            break;
          case ChannelTargetPathType.rotation:
            if(channel.target.node == null) break;
            ByteBuffer byteBuffer = getNextInterpolatedValues(channel.sampler, channel.target.path);
            Quaternion result = new Quaternion.fromBuffer(byteBuffer, 0);
//            print(result);
            channel.target.node.rotation = result;
            break;
          case ChannelTargetPathType.scale:
            ByteBuffer byteBuffer = getNextInterpolatedValues(channel.sampler, channel.target.path);
            Vector3 result = new Vector3.fromBuffer(byteBuffer, 0);
//            print(result);
            channel.target.node.scale = result;
            break;
          case ChannelTargetPathType.weights:
//            int weightsCount = channel.target.node.mesh.weights.length;
//            throw 'Renderer:update() : switch not implemented yet : ${channel.target.path}';
            // Todo (jpu) :
            break;
        }
      }
    }
  }

  ByteBuffer getNextInterpolatedValues(GLTFAnimationSampler sampler, ChannelTargetPathType targetType) {
    ByteBuffer result;

    Float32List keyTimes = getKeyTimes(sampler.input);
    Float32List keyValues = getKeyValues(sampler.output);

    num playTime =
        (Time.currentTime / 1000) % keyTimes.last; // Todo (jpu) : find less cost ?

    //> playtime range
    int previousIndex = 0;
    double previousTime = 0.0;

    previousTime = keyTimes.lastWhere((e)=> e < playTime, orElse: ()=> null);
    previousIndex = keyTimes.indexOf(previousTime);

//    while (keyTimes[previousIndex] < playTime) {
//      previousTime = keyTimes[previousIndex];
//      previousIndex++;
//    }
//    previousIndex--;

    int nextIndex = (previousIndex + 1) % keyTimes.length;
    double nextTime = keyTimes[nextIndex];

    //> values
    int nextStartIndex =
        nextIndex *
            sampler.output.components;//sampler.output.byteOffset +
    Float32List nextValues = keyValues.sublist(nextStartIndex,nextStartIndex + sampler.output.components);

    Float32List previousValues;
    if(previousIndex == -1){
      previousValues = nextValues;
    }else {
      int previousStartIndex =
          previousIndex *
              sampler.output.components;//sampler.output.byteOffset +
      previousValues =  keyValues.sublist(previousStartIndex,previousStartIndex + sampler.output.components) as Float32List;
    }

    double interpolationValue = nextTime - previousTime != 0.0 ?
        (playTime - previousTime) / (nextTime - previousTime) : 0.0;

    // Todo (jpu) : add easer ratio interpolation
    result = getInterpolationValue(
        previousValues,
        nextValues,
        interpolationValue,
        previousIndex,
        previousTime,
        playTime,
        nextIndex,
        nextTime, targetType);

    return result;
  }

  ByteBuffer getInterpolationValue(
      Float32List previousValues,
      Float32List nextValues,
      double interpolationValue,
      int previousIndex,
      double previousTime,
      num playTime,
      int nextIndex,
      double nextTime,
      ChannelTargetPathType targetType) {

    ByteBuffer result;

    switch(targetType){
      case ChannelTargetPathType.translation:
      case ChannelTargetPathType.scale:
        Vector3 previous = new Vector3.fromFloat32List(previousValues);
        Vector3 next = new Vector3.fromFloat32List(nextValues);

        Vector3 resultVector3 = vector3Lerp(previous, next, interpolationValue);
        result = resultVector3.storage.buffer;
        break;
      case ChannelTargetPathType.rotation:
        Quaternion previous = new Quaternion.fromFloat32List(previousValues);
        Quaternion next = new Quaternion.fromFloat32List(nextValues);

        //
        double angle = next.radians - previous.radians;
        if (angle.abs() > pi) {
          next[3] *= -1;
        }

        Quaternion resultQuaternion = slerp(previous, next, interpolationValue);
        result = resultQuaternion.storage.buffer;
        break;
      case ChannelTargetPathType.weights:
//        throw 'Renderer:getInterpolationValue() : switch not implemented yet : ${targetType}';
        // Todo (jpu) :
        break;
    }

    //debug.logCurrentFunction('interpolationValue : $interpolationValue');
    //debug.logCurrentFunction(
//        'previous : $previousIndex > ${previousTime.toStringAsFixed(3)} \t: ${degrees(previous.radians).toStringAsFixed(3)} ${previousTime.toStringAsFixed(3)} \t| $previous');
    //debug.logCurrentFunction(
//        'result   : - > ${playTime.toStringAsFixed(3)} \t: ${degrees(result.radians).toStringAsFixed(3)} ${playTime.toStringAsFixed(3)} \t| $result');
    //debug.logCurrentFunction(
//        'next     : $nextIndex > ${nextTime.toStringAsFixed(3)} \t: ${degrees(next.radians).toStringAsFixed(3)} ${nextTime.toStringAsFixed(3)} \t| $next');
    //debug.logCurrentFunction('');

    return result;
  }

  Float32List getInterpolatedValues(Float32List previousValues,
      Float32List nextValues, num interpolationValue) {
    

    Float32List result = new Float32List(previousValues.length);

    for (int i = 0; i < previousValues.length; i++) {
      result[i] = previousValues[i] +
          interpolationValue * (nextValues[i] - previousValues[i]);
    }
    return result;
  }

  Quaternion slerp(Quaternion qa, Quaternion qb, double t) {
    bool useSimple = true;

    // quaternion to return
    Quaternion qm;

    if(useSimple){
      qm = qa + (qb - qa).scaled(t);
    }else {
      qm = new Quaternion.identity();

      // Calculate angle between them.
      double cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y +
          qa.z * qb.z;

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
    }
    return qm;
  }

  Float32List getKeyTimes(GLTFAccessor accessor) {
    Float32List keyTimes = accessor.bufferView.buffer.data.buffer
        .asFloat32List(
        accessor.bufferView.byteOffset + accessor.byteOffset,
        accessor.count * accessor.components);
    return keyTimes;
  }

  // Todo (jpu) : try to return only buffer
  Float32List getKeyValues(GLTFAccessor accessor) {
    Float32List keyValues = accessor.bufferView.buffer.data.buffer
        .asFloat32List(
        accessor.bufferView.byteOffset + accessor.byteOffset,
        accessor.count * accessor.components);
    return keyValues;
  }

  Vector3 vector3Lerp(Vector3 v0, Vector3 v1, double t) {
    return v0 + (v1 - v0).scaled(t);
  }
}