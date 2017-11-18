import '../camera.dart';
import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import '../utils/utils_assets.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/animation.dart';
import 'package:webgl/src/gtlf/asset.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/renderer/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture.dart';

// Todo (jpu) : synchronize id's list cohérent?
// Todo (jpu) : Ajouter des méthodes de Link reférénce ?
//> remplacer les listes par des Map<HashCode, Object>

// Todo (jpu) : Remplacer la copie complete des donnée par un design de Facade ? (utiliser des getter utilisant la source)?
// Todo (jpu) : UNPACK_COLORSPACE_CONVERSION_WEBGL flag to NONE to ignore colorSpace globaly in runtime
// Todo (jpu) : Acccessor getElement test ?
// 16/10/2017 : reading .bin files as Uint8List

GLTFProject _gltfProject;
GLTFProject get gltfProject => _gltfProject;

class GLTFProject {
  String baseDirectory;

  static Future<glTF.Gltf> loadGLTFResource(String url,
      {bool useWebPath: true}) async {
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

    if(url.startsWith('/')){
      url = url.substring(1);
    }
    if(url.startsWith('./')){
      url = url.substring(2);
    }
    if(url.startsWith('../')){
      url = url.substring(3);
    }

    String _webPath = isRelative ? "" : UtilsAssets.webPath;

    Random random = new Random();
    HttpRequest request = new HttpRequest()
      ..responseType = 'arraybuffer';
    request.open('GET', '${_webPath}${url}?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource: ${_webPath}${url}';
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

  glTF.Gltf _gltfSource;
  glTF.Gltf get gltfSource => _gltfSource;

  List<GLTFBuffer> buffers = new List();
  List<GLTFBufferView> bufferViews = new List();
  List<Camera> cameras = new List();
  List<GLTFImage> images = new List();
  List<GLTFSampler> samplers = new List();
  List<GLTFTexture> textures = new List();
  List<GLTFPBRMaterial> materials = new List();
  List<GLTFAccessor> accessors = new List();
  List<GLTFMesh> meshes = new List();
  List<GLTFAnimation> animations = new List();
  GLTFAsset asset;

  List<GLTFScene> _scenes = new List();
  List<GLTFScene> get scenes => _scenes.toList(growable: false);
  void addScene(GLTFScene scene){
    assert(scene != null);
    _scenes.add(scene);
    scene.sceneId = _scenes.indexOf(scene);
  }

  int _sceneId;
  GLTFScene get scene => _sceneId != null ? scenes[_sceneId] : null;
  set scene(GLTFScene value) {
    assert(value != null);
    GLTFScene projectScene = gltfProject.scenes.firstWhere((s)=>s.gltfSource == value.gltfSource);
    _sceneId = gltfProject.scenes.indexOf(projectScene);
  }

  List<GLTFNode> _nodes = new List();
  List<GLTFNode> get nodes => _nodes.toList(growable: false);
  void addNode(GLTFNode value){
    assert(value != null);

    value.nodeId = nodes.length > 0 ? nodes.last.nodeId + 1 : 0;
    _nodes.add(value);
  }

  @override
  String toString() {
    return 'GLTFProject: {"buffers": $buffers, "bufferViews": $bufferViews, "cameras": $cameras, "images": $images, "samplers": $samplers, "textures": $textures, "materials": $materials, "accessors": $accessors, "meshes": $meshes, "scenes": $scenes, "nodes": $nodes, "sceneId": $_sceneId}';
  }

  void _init([glTF.Gltf _gltfSource]) {

    if(_gltfSource != null) {

      asset = new GLTFAsset.fromGltf(_gltfSource.asset);

      //Buffers
      for (glTF.Buffer gltfBuffer in _gltfSource.buffers) {
        GLTFBuffer buffer = new GLTFBuffer.fromGltf(gltfBuffer);
        if (buffer != null) {
          buffer.bufferId = buffers.length > 0 ? buffers.last.bufferId + 1 : 0;
          buffers.add(buffer);
        }
      }

      //BufferViews
      for (glTF.BufferView gltfBufferView in _gltfSource.bufferViews) {
        GLTFBufferView bufferView = new GLTFBufferView.fromGltf(gltfBufferView);
        if (bufferView != null) {
          bufferView.bufferViewId = bufferViews.length > 0 ? bufferViews.last.bufferViewId + 1 : 0;
          bufferViews.add(bufferView);
        }
      }

      //Images
      for (glTF.Image gltfImage in _gltfSource.images) {
        GLTFImage image = new GLTFImage.fromGltf(gltfImage);
        if (image != null) {
          image.sourceId = images.length > 0 ? images.last.sourceId + 1 : 0;
          images.add(image);
        }
      }

      //Samplers
      for (glTF.Sampler gltfSampler in _gltfSource.samplers) {
        GLTFSampler sampler = new GLTFSampler.fromGltf(gltfSampler);
        if (sampler != null) {
          sampler.samplerId = samplers.length > 0 ? samplers.last.samplerId + 1 : 0;
          samplers.add(sampler);
        }
      }

      //Textures
      for (glTF.Texture gltfTexture in _gltfSource.textures) {
        GLTFTexture texture = new GLTFTexture.fromGltf(gltfTexture);
        if (texture != null) {
          texture.textureId = textures.length > 0 ? textures.last.textureId + 1 : 0;
          textures.add(texture);
        }
      }

      //Materials
      for (glTF.Material gltfMaterial in _gltfSource.materials) {
        GLTFPBRMaterial material = new GLTFPBRMaterial.fromGltf(gltfMaterial);
        if (material != null) {
          material.materialId = materials.length > 0 ? materials.last.materialId + 1 : 0;
          materials.add(material);
        }
      }

      //Accessors
      for (glTF.Accessor gltfAccessor in _gltfSource.accessors) {
        GLTFAccessor accessor = new GLTFAccessor.fromGltf(gltfAccessor);
        if (accessor != null) {
          accessor.accessorId = accessors.length > 0 ? accessors.last.accessorId + 1 : 0;
          accessors.add(accessor);
        }
      }

      //Cameras
      for (glTF.Camera gltfCamera in _gltfSource.cameras) {
        Camera camera = Camera.fromGltf(gltfCamera);
        if (camera != null) {
          camera.cameraId = cameras.length > 0 ? cameras.last.cameraId + 1 : 0;
          cameras.add(camera);
        }
      }

      //Meshes
      for (glTF.Mesh gltfMesh in _gltfSource.meshes) {
        GLTFMesh mesh = new GLTFMesh.fromGltf(gltfMesh);
        if (mesh != null) {
          mesh.meshId = meshes.length > 0 ? meshes.last.meshId + 1 : 0;
          meshes.add(mesh);
        }
      }

      //Nodes
      for (glTF.Node gltfNode in _gltfSource.nodes) {
        GLTFNode node = new GLTFNode.fromGltf(gltfNode);
        if (node != null) {
          addNode(node);
        }
      }
      //Nodes parenting
      for (GLTFNode node in nodes) {
        if(node.gltfSource.children != null && node.gltfSource.children.length > 0){
          for (int i = 0; i < node.gltfSource.children.length; i++) {
            nodes.where((n)=>node.gltfSource.children.contains(n.gltfSource))
            ..forEach((n)=> n.parent = node);
          }
        }
      }

      //Scenes
      for (glTF.Scene gltfScene in _gltfSource.scenes) {
        GLTFScene scene = new GLTFScene.fromGltf(gltfScene);
        if (scene != null) {
          addScene(scene);
        }
      }
      if(_gltfSource.scene != null) {
        scene = new GLTFScene.fromGltf(_gltfSource.scene);
      }

      //Animation
      for (glTF.Animation gltfAnimation  in _gltfSource.animations) {
        GLTFAnimation animation = new GLTFAnimation.fromGltf(gltfAnimation);
        if (animation != null) {
          animation.animationId = animations.length > 0 ? animations.last.animationId + 1 : 0;
          animations.add(animation);
        }
      }

    }
  }

  GLTFProject._();

  factory GLTFProject(){
    _gltfProject = new GLTFProject._();
    _gltfProject._init();
    return _gltfProject;
  }

  factory GLTFProject.fromGltf(glTF.Gltf gltfSource) {
    if (gltfSource == null) return null;
    _gltfProject = new GLTFProject._();
    _gltfProject._gltfSource = gltfSource;
    _gltfProject._init(gltfSource);
    return _gltfProject;
  }

  Future fillBuffersData() async {
    for (GLTFBuffer buffer in buffers) {
      if(buffer.data == null && buffer.uri != null){
        String ressourcePath = '$baseDirectory${buffer.uri}';
        buffer.data = await loadGltfBinResource(ressourcePath, isRelative : false);
      }
    }
  }

}