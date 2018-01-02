import 'package:webgl/src/gltf/accessor_sparse.dart';
import 'package:webgl/src/gltf/accessor_sparse_indices.dart';
import 'package:webgl/src/gltf/accessor_sparse_values.dart';
import 'package:webgl/src/gltf/mesh_primitive.dart';
import 'package:webgl/src/gltf/normal_texture_info.dart';
import 'package:webgl/src/gltf/occlusion_texture_info.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/texture_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/animation.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/image.dart';
import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/sampler.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture.dart';

import 'package:webgl/src/camera/camera.dart';
import 'dart:core';
import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import 'dart:async';
import 'dart:html';
import 'dart:math';
import '../utils/utils_assets.dart';

class GLTFCreation{

  static Future<glTF.Gltf> loadGLTFResource(String url,
      {bool useWebPath: false}) async {
    UtilsAssets.useWebPath = useWebPath;

    Completer completer = new Completer<glTF.Gltf>();
    await UtilsAssets.loadJSONResource(url).then((Map<String, dynamic> result) {
      try {
        glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
        completer.complete(gltf);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future as Future<glTF.Gltf>;
  }

  static Future<Uint8List> loadGltfBinResource (String url, {bool isRelative : true}) {
    Completer completer = new Completer<Uint8List>();

    String assetsPath = UtilsAssets.getWebPath(url);
    print('url : $url | assetsPath : $assetsPath');

    Random random = new Random();
    HttpRequest request = new HttpRequest()
      ..responseType = 'arraybuffer';
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.timeout = 2000;
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        ByteBuffer byteBuffer = request.response as ByteBuffer;
        completer.complete( new Uint8List.view(byteBuffer));
      }
    });
    request.send();

    return completer.future as Future<Uint8List>;
  }

  static Future<GLTFProject> getGLTFProject(glTF.Gltf gltfSource, String baseDirectory) async {
    if (gltfSource == null) return null;

    GLTFProject _gltfProject = new GLTFProject.create()..baseDirectory = baseDirectory;

    GLTFCreation gltf = new GLTFCreation._(_gltfProject, gltfSource);
    gltf._initGLTF();

    await gltf.fillBuffersData();

    return _gltfProject;
  }

  final GLTFProject _gltfProject;
  final glTF.Gltf _gltfSource;

  GLTFCreation._(this._gltfProject, this._gltfSource);

  void _initGLTF() {

    GLTFProject.reset();

    assert(_gltfSource != null);

    _gltfProject.asset = new GLTFAsset(_gltfSource.asset.version);

    //Buffers
    for (glTF.Buffer gltfBuffer in _gltfSource.buffers) {
      _createBuffer(gltfBuffer);
    }

    //BufferViews
    for (glTF.BufferView gltfBufferView in _gltfSource.bufferViews) {
      _createBufferView(gltfBufferView);
    }

    //Images
    for (glTF.Image gltfSource in _gltfSource.images) {
      _createImage(gltfSource);
    }

    //Samplers
    for (glTF.Sampler gltfSource in _gltfSource.samplers) {
      _createSampler(gltfSource);
    }

    //Textures
    for (glTF.Texture gltfTexture in _gltfSource.textures) {
      _createTexture(gltfTexture);
    }

    //Materials
    for (glTF.Material gltfMaterial in _gltfSource.materials) {
      _createMaterial(gltfMaterial);
    }

    //Accessors
    for (glTF.Accessor gltfAccessor in _gltfSource.accessors) {
      _createAccessor(gltfAccessor);
    }

    //Cameras
    for (glTF.Camera gltfCamera in _gltfSource.cameras) {
      _createCamera(gltfCamera);
    }

    //Meshes
    for (glTF.Mesh gltfMesh in _gltfSource.meshes) {
      _createMesh(gltfMesh);
    }

    //Nodes
    for (glTF.Node gltfNode in _gltfSource.nodes) {
      _createNode(gltfNode);
    }

    //Nodes hierarchy parenting
    for (glTF.Node gltfNode in _gltfSource.nodes) {
      if(gltfNode.children != null && gltfNode.children.length > 0){
        GLTFNode node = _getNode(gltfNode);
        node.children = gltfNode.children.map((n) => _getNode(n)).toList();
        node.children.forEach((n)=> n.parent = node);
      }
    }

    //Scenes
    for (glTF.Scene gltfScene in _gltfSource.scenes) {
      _createScene(gltfScene);
    }
    if(_gltfSource.scene != null) {
      _gltfProject.scene = _getScene(_gltfSource.scene);
    }

    //Animation
    for (glTF.Animation gltfAnimation  in _gltfSource.animations) {
      _createAnimation(gltfAnimation);
    }
  }

  Future fillBuffersData() async {
    for (GLTFBuffer buffer in _gltfProject.buffers) {
      if(buffer.data == null && buffer.uri != null && buffer.uri.path.length > 0){
        String ressourcePath = '${_gltfProject.baseDirectory}${buffer.uri}';
        buffer.data = await loadGltfBinResource(ressourcePath, isRelative : false);
      }
    }
  }

  GLTFBuffer _createBuffer(glTF.Buffer gltfSource){
    if (gltfSource == null) return null;
    GLTFBuffer buffer = new GLTFBuffer(uri : gltfSource.uri,
        byteLength: gltfSource.byteLength,
        data : gltfSource.data,
        name : gltfSource.name);

    if (buffer != null) {
      GLTFProject.instance.buffers.add(buffer);
    }

    return buffer;
  }

  GLTFBuffer _getBuffer(glTF.Buffer buffer) {
    int id = _gltfSource.buffers.indexOf(buffer);
    return _gltfProject.buffers.firstWhere((b)=>b.bufferId == id, orElse: ()=> throw new Exception('Buffer can only be bound to an existing project buffer'));
  }

  GLTFBufferView _createBufferView(glTF.BufferView gltfSource) {
    if (gltfSource == null) return null;

    GLTFBufferView bufferView = new GLTFBufferView(
        buffer : _getBuffer(gltfSource.buffer),
        byteLength: gltfSource.byteLength,
        byteOffset: gltfSource.byteOffset,
        byteStride: gltfSource.byteStride,
        usage: gltfSource.usage != null ? gltfSource.usage.target : null,
        target: gltfSource.usage != null
            ? gltfSource.usage.target
            : null, // Todo (jpu) : bug if -1 and usage == null. What to do ?
        name: gltfSource.name);

    if (bufferView != null) {
      GLTFProject.instance.bufferViews.add(bufferView);
    }

    return bufferView;
  }

  GLTFBufferView _getBufferView(glTF.BufferView bufferView) {
    int id = _gltfSource.bufferViews.indexOf(bufferView);
    return _gltfProject.bufferViews.firstWhere((b) => b.bufferViewId == id,
        orElse: () => throw new Exception(
            'BufferView can only be bound to an existing project bufferView'));
  }

  GLTFAccessor _createAccessor(glTF.Accessor gltfSource) {
    if (gltfSource == null) return null;

    GLTFAccessor accessor = new GLTFAccessor(
        byteOffset : gltfSource.byteOffset,
        byteLength :  gltfSource.byteLength,
        componentType : gltfSource.componentType,
        count : gltfSource.count,
        typeString : gltfSource.type,
//        type : ShaderVariableType.getByComponentAndType(gltfSource.componentType,gltfSource.type),
        elementLength : gltfSource.elementLength,
        components : gltfSource.components,
        normalized : gltfSource.normalized,
        componentLength : gltfSource.componentLength,
        max : gltfSource.max,
        min : gltfSource.min,
        byteStride : gltfSource.byteStride,
        sparse : gltfSource.sparse != null
            ? _createGLTFAccessorSparse(gltfSource.sparse):null,
        isXyzSign : gltfSource.isXyzSign,
        isUnit : gltfSource.isUnit,
        name: gltfSource.name
    );

    if(gltfSource.bufferView != null) {
      GLTFBufferView bufferView = _getBufferView(gltfSource.bufferView);
      assert(bufferView.bufferViewId != null);

      accessor.bufferView = bufferView;
    }

    if (accessor != null) {
      GLTFProject.instance.accessors.add(accessor);
    }

    return accessor;
  }

  GLTFAccessor _getAccessor(glTF.Accessor accessor) {
    int id = _gltfSource.accessors.indexOf(accessor);
    return _gltfProject.accessors.firstWhere((a)=>a.accessorId == id, orElse: ()=> throw new Exception('Attribut accessor can only be bound to an existing project accessor'));
  }

  GLTFSampler _createSampler(glTF.Sampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFSampler sampler = new GLTFSampler(
        magFilter : gltfSource.magFilter != -1 ? gltfSource.magFilter : TextureFilterType.LINEAR,
        minFilter : gltfSource.minFilter != -1 ? gltfSource.minFilter : TextureFilterType.LINEAR,
        wrapS : gltfSource.wrapS,
        wrapT : gltfSource.wrapT,
        name : gltfSource.name
    );

    if (sampler != null) {
      GLTFProject.instance.samplers.add(sampler);
    }

    return sampler;
  }

  GLTFSampler _getSampler(glTF.Sampler sampler) {
    int id = _gltfSource.samplers.indexOf(sampler);
    return _gltfProject.samplers.firstWhere((s)=>s.samplerId == id, orElse: ()=> throw new Exception('Texture Sampler can only be bound to an existing project sampler'));
  }

  GLTFImage _createImage(glTF.Image gltfSource) {
    if (gltfSource == null) return null;
    GLTFImage image = new GLTFImage(
        uri : gltfSource.uri,
        mimeType : gltfSource.mimeType,
        bufferView : _createBufferView(gltfSource.bufferView),
        data : gltfSource.data,
        name : gltfSource.name
    );

    if (image != null) {
      GLTFProject.instance.images.add(image);
    }

    return image;
  }

  GLTFImage _getImage(glTF.Image image) {
    int id = _gltfSource.images.indexOf(image);
    return _gltfProject.images.firstWhere((i)=>i.sourceId == id, orElse: ()=> throw new Exception('Texture Image can only be bound to an existing project image'));
  }

  GLTFTexture _createTexture(glTF.Texture gltfSource) {
    if (gltfSource == null) return null;

    GLTFSampler sampler;
    if(gltfSource.sampler != null){
      sampler = _getSampler(gltfSource.sampler);
    }

    GLTFImage image;
    if(gltfSource.source != null){
      image = _getImage(gltfSource.source);
    }

    //Check if exist in project first
    GLTFTexture texture = _getTexture(gltfSource);
    if(texture == null) {
      texture = new GLTFTexture(
          sampler : sampler,
          source : image,
          name: gltfSource.name
      );
    }else {
      texture.sampler = sampler;
      texture.source = image;
    }

    if (texture != null) {
      GLTFProject.instance.textures.add(texture);
    }

    return texture;
  }

  GLTFTexture _getTexture(glTF.Texture texture) {
    int id = _gltfSource.textures.indexOf(texture);
    return _gltfProject.textures.firstWhere((t)=>t.textureId == id, orElse: ()=> null);
  }

  GLTFPBRMaterial _createMaterial(glTF.Material gltfSource) {
    if (gltfSource == null) return null;

    GLTFPBRMaterial material = new GLTFPBRMaterial(
        pbrMetallicRoughness : _createGLTFPbrMetallicRoughness(
            gltfSource.pbrMetallicRoughness),
        normalTexture : gltfSource.normalTexture != null
            ? _createGLTFNormalTextureInfo(gltfSource.normalTexture)
            : null,
        occlusionTexture : gltfSource.occlusionTexture != null
            ? _createGLTFOcclusionTextureInfo(
            gltfSource.occlusionTexture)
            : null,
        emissiveTexture : gltfSource.emissiveTexture != null
            ? _createGLTFTextureInfo(gltfSource.emissiveTexture)
            : null,
        emissiveFactor : gltfSource.emissiveFactor,
        alphaMode : gltfSource.alphaMode,
        alphaCutoff : gltfSource.alphaCutoff,
        doubleSided : gltfSource.doubleSided,
        name : gltfSource.name
    );

    if (material != null) {
      GLTFProject.instance.materials.add(material);
    }

    return material;
  }

  GLTFPBRMaterial _getMaterial(glTF.Material material){
    int id = _gltfSource.materials.indexOf(material);
    return _gltfProject.materials.firstWhere((m)=>m.materialId == id, orElse: ()=> throw new Exception('Mesh material can only be bound to an existing project material'));
  }

  Camera _createCamera(glTF.Camera gltfCamera){
    Camera camera;
    if(gltfCamera != null) {
      if (gltfCamera.perspective != null){
        camera = new CameraPerspective(gltfCamera.perspective.yfov, gltfCamera.perspective.znear, gltfCamera.perspective.zfar)
          ..type = CameraType.perspective
          ..aspectRatio = gltfCamera.perspective.aspectRatio;
      } else if (gltfCamera.orthographic != null) {
        camera = new CameraOrthographic()
          ..type = CameraType.orthographic
          ..znear = gltfCamera.orthographic.znear
          ..zfar = gltfCamera.orthographic.zfar
          ..xmag = gltfCamera.orthographic.xmag
          ..ymag = gltfCamera.orthographic.ymag;

        // Todo (jpu) :
//      cameraPerspective.extensions;
//      cameraPerspective.extras;
      }
    }

    if (camera != null) {
      GLTFProject.instance.cameras.add(camera);
    }

    return camera;
  }

  Camera _getCamera(glTF.Camera gltfCamera){
    int id = _gltfSource.cameras.indexOf(gltfCamera);
    return _gltfProject.cameras.firstWhere((c)=>c.cameraId == id, orElse: ()=> throw new Exception('Camera can only be bound to an existing project camera'));
  }

  GLTFMesh _createMesh(glTF.Mesh gltfSource) {
    if (gltfSource == null) return null;

    GLTFMesh mesh = new GLTFMesh(
        weights : gltfSource.weights != null
            ? (<double>[]..addAll(gltfSource.weights))
            : <double>[],
        name : gltfSource.name
    );

    mesh.primitives = gltfSource.primitives
        .map((p) => _createPrimitive(p))
        .toList();

    if (mesh != null) {
      GLTFProject.instance.meshes.add(mesh);
    }

    return mesh;
  }

  GLTFMesh _getMesh(glTF.Mesh mesh){
    int id = _gltfSource.meshes.indexOf(mesh);
    return _gltfProject.meshes.firstWhere((m)=>m.meshId == id, orElse: ()=> throw new Exception('Mesh can only be bound to an existing project mesh'));
  }

  GLTFNode _createNode(glTF.Node gltfSource) {
    if (gltfSource == null) return null;

    GLTFNode node = new GLTFNode(
        name : gltfSource.name
    );

    node.translation = gltfSource.translation;
    node.rotation = gltfSource.rotation;
    node.scale = gltfSource.scale;
    node.matrix = gltfSource.matrix;

    if(gltfSource.mesh != null){
      GLTFMesh mesh = _getMesh(gltfSource.mesh);
      node.mesh = mesh;
    }

    if(gltfSource.camera != null){
      Camera camera = _getCamera(gltfSource.camera);
      node.camera = camera;
    }

    if (node != null) {
      GLTFProject.instance.addNode(node);
    }

    return node;
  }

  GLTFNode _getNode(glTF.Node node)
  {
    int id = _gltfSource.nodes.indexOf(node);
    return _gltfProject.nodes.firstWhere((n)=>n.nodeId == id, orElse: ()=> throw new Exception('Node can only be binded to Nodes existing in project'));
  }

  GLTFScene _createScene(glTF.Scene gltfSource){
    if (gltfSource == null) return null;
    GLTFScene scene = new GLTFScene(name : gltfSource.name);

    //Scenes must be handled after nodes
    for(glTF.Node node in gltfSource.nodes){
      GLTFNode gltfNode = _getNode(node);
      scene.addNode(gltfNode);
    }

    if (scene != null) {
      GLTFProject.instance.addScene(scene);
    }

    return scene;
  }

  GLTFScene _getScene(glTF.Scene scene){
    int id = _gltfSource.scenes.indexOf(scene);
    return _gltfProject.scenes.firstWhere((s)=>s.sceneId == id, orElse: ()=> throw new Exception('SCene can only be bound to Scene existing in project'));
  }

  GLTFPbrMetallicRoughness _createGLTFPbrMetallicRoughness(glTF.PbrMetallicRoughness gltfSource){
    if (gltfSource == null) return null;
    return new GLTFPbrMetallicRoughness(
        baseColorFactor : new Float32List.fromList(gltfSource.baseColorFactor),
        baseColorTexture :_createGLTFTextureInfo(gltfSource.baseColorTexture),
        metallicFactor : gltfSource.metallicFactor,
        roughnessFactor : gltfSource.roughnessFactor,
        metallicRoughnessTexture :
        _createGLTFTextureInfo(gltfSource.metallicRoughnessTexture)
    );
  }

  GLTFMeshPrimitive _createPrimitive(glTF.MeshPrimitive gltfSource) {
    if (gltfSource == null) return null;
    GLTFMeshPrimitive meshPrimitive = new GLTFMeshPrimitive(
        drawMode: gltfSource.mode != null ? gltfSource.mode : DrawMode.TRIANGLES,
        hasPosition: gltfSource.hasPosition,
        hasNormal: gltfSource.hasNormal,
        hasTangent: gltfSource.hasTangent,
        colorCount: gltfSource.colorCount,
        jointsCount: gltfSource.jointsCount,
        weigthsCount: gltfSource.weigthsCount,
        texcoordCount: gltfSource.texcoordCount);

    //attributs
    for (String key in gltfSource.attributes.keys) {
      GLTFAccessor accessor =
      _getAccessor(gltfSource.attributes[key]);
      meshPrimitive.attributes[key] = accessor;
    }

    //indices
    if (gltfSource.indices != null) {
      GLTFAccessor accessorIndices =
      _getAccessor(gltfSource.indices);
      assert(accessorIndices.accessorId != null);
      meshPrimitive.indicesAccessor = accessorIndices;
    }

    //material
    if (gltfSource.material != null) {
      GLTFPBRMaterial material = _getMaterial(gltfSource.material);
      meshPrimitive.baseMaterial = material;
    }
    return meshPrimitive;
  }

  GLTFOcclusionTextureInfo _createGLTFOcclusionTextureInfo(
      glTF.OcclusionTextureInfo gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFOcclusionTextureInfo(
        gltfSource.texCoord,
        _createTexture(gltfSource.texture),
        gltfSource.strength
    );
  }

  GLTFNormalTextureInfo _createGLTFNormalTextureInfo(
      glTF.NormalTextureInfo gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFNormalTextureInfo(
        gltfSource.texCoord,
        _createTexture(gltfSource.texture),
        gltfSource.scale
    );
  }

  GLTFTextureInfo _createGLTFTextureInfo(glTF.TextureInfo gltfSource){
    if (gltfSource == null) return null;

    GLTFTextureInfo textureInfo =  new GLTFTextureInfo(
        gltfSource.texCoord
    );

    if(gltfSource.texture != null){
      GLTFTexture texture = _getTexture(gltfSource.texture);
      textureInfo.texture = texture;
    }

    return textureInfo;
  }

  GLTFAnimationSampler _createGLTFAnimationSampler(glTF.AnimationSampler gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationSampler sampler = new GLTFAnimationSampler(gltfSource.interpolation);

    GLTFAccessor projectAccessorInput = _getAccessor(gltfSource.input);
    sampler.input = projectAccessorInput;

    GLTFAccessor projectAccessorOutput = _getAccessor(gltfSource.output);
    sampler.output = projectAccessorOutput;

    return sampler;
  }

  GLTFAnimationChannelTarget _createGLTFAnimationChannelTarget(
      glTF.AnimationChannelTarget gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationChannelTarget channelTarget =
    new GLTFAnimationChannelTarget(gltfSource.path);
    GLTFNode projectNode =
    _getNode(gltfSource.node);
    channelTarget.node = projectNode;

    return channelTarget;
  }

  GLTFAnimationChannel _createGLTFAnimationChannel(glTF.AnimationChannel gltfSource) {
    if (gltfSource == null) return null;
    GLTFAnimationChannel channel = new GLTFAnimationChannel(
        _createGLTFAnimationChannelTarget(gltfSource.target)
    );
    return channel;
  }

  GLTFAnimation _createAnimation(glTF.Animation gltfSource) {
    if (gltfSource == null) return null;

    //>
    List<GLTFAnimationSampler> samplers = new List();
    for (int i = 0; i < gltfSource.samplers.length; i++) {
      GLTFAnimationSampler sampler = _createGLTFAnimationSampler(gltfSource.samplers[i]);
      samplers.add(sampler);
    }

    //>
    List<GLTFAnimationChannel> channels = new List();
    for (int i = 0; i < gltfSource.channels.length; i++) {
      GLTFAnimationChannel channel = _createGLTFAnimationChannel(gltfSource.channels[i]);
      int id = gltfSource.samplers.indexOf(gltfSource.channels[i].sampler);

      channel
        ..sampler = samplers.firstWhere((s)=> s.samplerId == id, orElse: () => throw new Exception("can't get a corresponding sampler"));
      channels.add(channel);
    }

    GLTFAnimation animation = new GLTFAnimation(name:gltfSource.name)
      ..samplers = samplers
      ..channels = channels;

    if (animation != null) {
      GLTFProject.instance.animations.add(animation);
    }

    return animation;
  }

  GLTFAccessorSparse _createGLTFAccessorSparse(
      glTF.AccessorSparse gltfSource){
    return new GLTFAccessorSparse(
        gltfSource.count,
        new GLTFAccessorSparseIndices(
          gltfSource.indices.byteOffset,
          gltfSource.indices.componentType,
        ),
        new GLTFAccessorSparseValues(
            gltfSource.values.byteOffset,
            _getBufferView( gltfSource.values.bufferView)
        ));
  }
}