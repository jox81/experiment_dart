import 'dart:html';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:webgl/src/assets_manager/not_loaded_exception.dart';
import 'package:webgl/src/gltf/camera/camera.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'dart:core';
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/animation/animation.dart';
import 'package:webgl/src/gltf/animation/animation_channel.dart';
import 'package:webgl/src/gltf/animation/animation_sampler.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/pbr_material.dart';
import 'package:webgl/src/gltf/image.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/sampler.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/gltf/project/gltf_load_project.dart';

// Todo (jpu) : synchronize id's list cohérent?
// Todo (jpu) : Ajouter des méthodes de Link reférénce ?
//> remplacer les listes par des Map<HashCode, Object>

// Todo (jpu) : Remplacer la copie complete des donnée par un design de Facade ? (utiliser des getter utilisant la source)?
// Todo (jpu) : UNPACK_COLORSPACE_CONVERSION_WEBGL flag to NONE to ignore colorSpace globaly in runtime
// Todo (jpu) : Acccessor getElement test ?
// 16/10/2017 : reading .bin files as Uint8List

@reflector
class GLTFProject extends Project{

  GLTFProjectDebugger _projectDebugger;

  GLTFProjectDebugger get projectDebugger => _projectDebugger ??= new GLTFProjectDebugger();

  GLTFScene get currentScene =>
      scenes.length > 0 ? scenes[0] : null;

  @override
  GLTFCameraPerspective get mainCamera => super.mainCamera ??=
     new GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

  DirectionalLight _defaultLight;
  DirectionalLight get defaultLight => _defaultLight;
  set defaultLight(DirectionalLight value) {
    _defaultLight = value;
  }

  GLTFProject({bool doReset: true}){
    reset();
  }
  
  factory GLTFProject.create() = GLTFLoadProject;

  ///path of the directory of the gltf file
  String baseDirectory = '';

  List<GLTFCamera> cameras = <GLTFCamera>[];
  List<GLTFPBRMaterial> materials = <GLTFPBRMaterial>[];
  List<GLTFTexture> textures = <GLTFTexture>[];
  List<GLTFImage> images = <GLTFImage>[];
  List<GLTFMesh> meshes = <GLTFMesh>[];
  List<Light> lights = <Light>[];// Todo (jpu) : check how to use gltf extensions

  List<GLTFBuffer> buffers = <GLTFBuffer>[];
  List<GLTFBufferView> bufferViews = <GLTFBufferView>[];
  List<GLTFAccessor> accessors = <GLTFAccessor>[];
  List<GLTFSampler> samplers = <GLTFSampler>[];
  List<GLTFAnimation> animations = <GLTFAnimation>[];
  GLTFAsset asset = new GLTFAsset("2.0");

  final List<GLTFScene> _scenes = <GLTFScene>[];
  List<GLTFScene> get scenes => _scenes.toList(growable: false);
  void addScene(GLTFScene scene){
    assert(scene != null);
    _scenes.add(scene);
  }

  GLTFScene _scene;
  GLTFScene get scene => _scene ?? _scenes[0];
  set scene(GLTFScene value) {
    assert(value != null);
    GLTFScene projectScene = _scenes.firstWhere((s)=>s.sceneId == value.sceneId, orElse: ()=> throw new Exception('Scene can only be bound to an existing project Scene. If you want to add a scene to the project use addScene Method.'));
    _scene = projectScene;
  }

  final List<GLTFNode> _nodes = <GLTFNode>[];
  List<GLTFNode> get nodes => _nodes.toList(growable: false);
  void addNode(GLTFNode value){
    assert(value != null);
    _nodes.add(value);
  }
  void removeNode(GLTFNode value){
    assert(value != null);
    _nodes.remove(value);
  }

  GLTFCamera getCurrentCamera() {
    GLTFCamera currentCamera;

    bool debugCamera = true;

    if (debugCamera) {
      currentCamera = new GLTFCameraPerspective(radians(47.0), 0.1, 1000.0)
        ..targetPosition = new Vector3(0.0, 0.0, 0.0)
        ..translation = new Vector3(10.0, 10.0, 10.0);
    } else {
      //find first activeScene camera
      currentCamera = _findActiveSceneCamera(currentScene.nodes);
      //or use first in project else default
      if (currentCamera == null) {
        currentCamera = _findActiveSceneCamera(nodes);
      }
      if (currentCamera == null) {
        if (cameras.length > 0) {
          currentCamera = cameras[0];
          GLTFNode node = nodes.firstWhere(
                  (n) => n.name == currentCamera.name,
              orElse: () => null);
          currentCamera.matrix = node.matrix;
//          currentCamera.translation = node.translation;
//          currentCamera.rotation = node.rotation;
//          currentCamera.scale = node.scale;
        } else {
          currentCamera = new GLTFCameraPerspective(radians(47.0), 0.1, 100.0)
            ..targetPosition = new Vector3(0.0, 0.03, 0.0);
//          ..targetPosition = new Vector3(0.0, .03, 0.0);//Avocado
          currentCamera.translation = new Vector3(5.0, 5.0, 10.0);
        }

//      currentCamera.position = new Vector3(.5, 0.0, 0.2);//Avocado
      }
    }

    return currentCamera;
  }

  GLTFCamera _findActiveSceneCamera(List<GLTFNode> nodes) {
    GLTFCamera result;

    for (var i = 0; i < nodes.length && result == null; i++) {
      GLTFNode node = nodes[i];
      //Correction is from blender export but not yet used
      if (node.camera != null && !node.name.contains('Correction')) {
        _setupNodeCamera(node);
        result = node.camera;
      }
    }

    return result;
  }

  void _setupNodeCamera(GLTFNode node) {
    GLTFCameraPerspective camera = node.camera as GLTFCameraPerspective;
    camera.translation = node.translation;
  }


  @override
  String toString()=>'GLTFProject: {"buffers": $buffers, "bufferViews": $bufferViews, "cameras": $cameras, "images": $images, "samplers": $samplers, "textures": $textures, "materials": $materials, "accessors": $accessors, "meshes": $meshes, "scenes": $scenes, "nodes": $nodes, "sceneId": ${_scene?.sceneId}';

  void reset({bool fullReset : false}) {
    GLTFBuffer.nextId = 0;
    GLTFBufferView.nextId = 0;
    GLTFImage.nextId = 0;
    GLTFSampler.nextId = 0;
    GLTFTexture.nextId = 0;
    GLTFPBRMaterial.nextId = 0;
    GLTFAccessor.nextId = 0;
    GLTFCamera.nextId = 0;
    GLTFMesh.nextId = 0;
    GLTFNode.nextId = 0;
    GLTFNode.nextId = 0;
    GLTFScene.nextId = 0;
    GLTFAnimation.nextId = 0;
    GLTFAnimationChannel.nextId = 0;
    GLTFAnimationSampler.nextId = 0;
  }

  debug({bool doProjectLog, bool isDebug}) {}

  Map<String, ImageElement> _data = new Map<String, ImageElement>();

  ImageElement getImage(String textureUri) => _data[textureUri] ?? (throw new NotLoadedAssetException());

  Future _loadImage(String textureUri) async {
    String filePath = baseDirectory + textureUri;
    ImageLoader loader = new ImageLoader()..filePath = filePath;
    AssetLibrary.project.addLoader(loader);
    await loader.load();
    ImageElement imageElement = loader.result;
    _data[textureUri] = imageElement;
  }

  Future loadImages() async {
    for (int i = 0; i < textures.length; i++) {
      GLTFTexture gltfTexture = textures[i];
      if (gltfTexture.source.data == null) {
        await _loadImage(gltfTexture.source.uri.toString());// Todo (jpu) : add this to a library auto filled ?
      }
    }
  }
}