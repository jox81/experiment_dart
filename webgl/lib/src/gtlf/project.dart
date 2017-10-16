import '../camera.dart';
import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import '../utils/utils_assets.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

export 'package:webgl/src/gtlf/debug_gltf.dart';

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

  GLTFAsset asset;
  List<GLTFBuffer> buffers = new List();
  List<GLTFBufferView> bufferViews = new List();
  List<Camera> cameras = new List();
  List<GLTFImage> images = new List();
  List<GLTFSampler> samplers = new List();
  List<GLTFTexture> textures = new List();
  List<GLTFMaterial> materials = new List();
  List<GLTFAccessor> accessors = new List();
  List<GLTFMesh> meshes = new List();

  //>
  List<GLTFScene> _scenes = new List();
  List<GLTFScene> get scenes => _scenes.toList(growable: false);

  void addScene(GLTFScene scene){
    assert(scene != null);
    _scenes.add(scene);
    scene.sceneId = _scenes.indexOf(scene);
  }

  List<GLTFNode> _nodes = new List();
  List<GLTFNode> get nodes => _nodes.toList(growable: false);

  void addNode(GLTFNode node){
    assert(node != null);
    _nodes.add(node);
    node.nodeId = _nodes.indexOf(node);
  }

  int _sceneId;
  GLTFScene get scene => _sceneId != null ? scenes[_sceneId] : null;
  set scene(GLTFScene value) {
    _sceneId = scenes.indexOf(value);
  }
  //<

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
          buffers.add(buffer);
        }
      }

      //BufferViews
      for (glTF.BufferView gltfBufferView in _gltfSource.bufferViews) {
        GLTFBufferView bufferView = new GLTFBufferView.fromGltf(gltfBufferView);
        if (bufferView != null) {
          bufferViews.add(bufferView);
        }
      }

      //Cameras
      for (glTF.Camera gltfCamera in _gltfSource.cameras) {
        Camera camera = Camera.fromGltf(gltfCamera);
        if (camera != null) {
          cameras.add(camera);
        }
      }

      //Images
      for (glTF.Image gltfImage in _gltfSource.images) {
        GLTFImage image = new GLTFImage.fromGltf(gltfImage);
        if (image != null) {
          images.add(image);
        }
      }

      //Samplers
      for (glTF.Sampler gltfSampler in _gltfSource.samplers) {
        GLTFSampler sampler = new GLTFSampler.fromGltf(gltfSampler);
        if (sampler != null) {
          samplers.add(sampler);
        }
      }

      //Textures
      for (glTF.Texture gltfTexture in _gltfSource.textures) {
        GLTFTexture texture = new GLTFTexture.fromGltf(gltfTexture);
        if (texture != null) {
          textures.add(texture);
        }
      }

      //Materials
      for (glTF.Material gltfMaterial in _gltfSource.materials) {
        GLTFMaterial material = new GLTFMaterial.fromGltf(gltfMaterial);
        if (material != null) {
          materials.add(material);
        }
      }

      //Accessors
      for (glTF.Accessor gltfAccessor in _gltfSource.accessors) {
        GLTFAccessor accessor = new GLTFAccessor.fromGltf(gltfAccessor);
        if (accessor != null) {
          accessors.add(accessor);
        }
      }

      //Meshes
      for (glTF.Mesh gltfMesh in _gltfSource.meshes) {
        GLTFMesh mesh = new GLTFMesh.fromGltf(gltfMesh);
        if (mesh != null) {
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

      //Scenes
      for (glTF.Scene gltfScene in _gltfSource.scenes) {
        GLTFScene scene = new GLTFScene.fromGltf(gltfScene);
        if (scene != null) {
          addScene(scene);
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
        buffer.data = await loadGltfBinResource(buffer.uri.toString(), isRelative : true);
      }
    }
  }

}