import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/engine/engine.dart';
import 'dart:core';
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/animation/animation.dart';
import 'package:webgl/src/gltf/animation/animation_channel.dart';
import 'package:webgl/src/gltf/animation/animation_sampler.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
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

// Todo (jpu) : synchronize id's list cohérent?
// Todo (jpu) : Ajouter des méthodes de Link reférénce ?
//> remplacer les listes par des Map<HashCode, Object>

// Todo (jpu) : Remplacer la copie complete des donnée par un design de Facade ? (utiliser des getter utilisant la source)?
// Todo (jpu) : UNPACK_COLORSPACE_CONVERSION_WEBGL flag to NONE to ignore colorSpace globaly in runtime
// Todo (jpu) : Acccessor getElement test ?
// 16/10/2017 : reading .bin files as Uint8List

@reflector
abstract class GLTFProject extends Project{

  DirectionalLight _defaultLight;
  DirectionalLight get defaultLight => _defaultLight;
  set defaultLight(DirectionalLight value) {
    _defaultLight = value;
  }

  GLTFProject({bool doReset: true}){
    Engine.currentEngine.currentProject = this;
    reset();

    setupDefault();
  }

  ///path of the directory of the gltf file
  String baseDirectory = '';

  List<Camera> cameras = <Camera>[];
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

  void setupDefault() {

  }

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
    Camera.nextId = 0;
    GLTFMesh.nextId = 0;
    GLTFNode.nextId = 0;
    GLTFNode.nextId = 0;
    GLTFScene.nextId = 0;
    GLTFAnimation.nextId = 0;
    GLTFAnimationChannel.nextId = 0;
    GLTFAnimationSampler.nextId = 0;
  }

}