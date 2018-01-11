import 'package:webgl/src/introspection.dart';

import 'package:webgl/src/camera/camera.dart';
import 'dart:core';
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
import 'package:webgl/src/light/light.dart';

// Todo (jpu) : synchronize id's list cohérent?
// Todo (jpu) : Ajouter des méthodes de Link reférénce ?
//> remplacer les listes par des Map<HashCode, Object>

// Todo (jpu) : Remplacer la copie complete des donnée par un design de Facade ? (utiliser des getter utilisant la source)?
// Todo (jpu) : UNPACK_COLORSPACE_CONVERSION_WEBGL flag to NONE to ignore colorSpace globaly in runtime
// Todo (jpu) : Acccessor getElement test ?
// 16/10/2017 : reading .bin files as Uint8List

class GLTFProject extends IEditElement{
  static GLTFProject _instance;
  static GLTFProject get instance => new GLTFProject.create();//_instance != null ? _instance : throw "No project instance is created... Make sure a project is created before using this way.";

  ///path of the directory of the gltf file
  String baseDirectory = '';

  List<Camera> cameras = new List();
  List<GLTFPBRMaterial> materials = new List();
  List<GLTFTexture> textures = new List();
  List<GLTFImage> images = new List();
  List<GLTFMesh> meshes = new List();
  List<Light> lights = new List();// Todo (jpu) : check how to use gltf extensions

  List<GLTFBuffer> buffers = new List();
  List<GLTFBufferView> bufferViews = new List();
  List<GLTFAccessor> accessors = new List();
  List<GLTFSampler> samplers = new List();
  List<GLTFAnimation> animations = new List();
  GLTFAsset asset = new GLTFAsset("2.0");

  List<GLTFScene> _scenes = new List();
  List<GLTFScene> get scenes => _scenes.toList(growable: false);
  void addScene(GLTFScene scene){
    assert(scene != null);
    _scenes.add(scene);
  }

  GLTFScene _scene;
  GLTFScene get scene => _scene;
  set scene(GLTFScene value) {
    assert(value != null);
    GLTFScene projectScene = _scenes.firstWhere((s)=>s.sceneId == value.sceneId, orElse: ()=> throw new Exception('Scene can only be bound to an existing project Scene. If you want to add a scene to the project use addScene Method.'));
    _scene = projectScene;
  }

  List<GLTFNode> _nodes = new List();
  List<GLTFNode> get nodes => _nodes.toList(growable: false);
  void addNode(GLTFNode value){
    assert(value != null);
    _nodes.add(value);
  }

  GLTFProject._init(){
    GLTFProject.reset();
  }

  factory GLTFProject.create({bool reset : false}){
    if(_instance == null || reset){
      _instance = new GLTFProject._init();
    }
    return _instance;
  }

  @override
  String toString() {
    return 'GLTFProject: {"buffers": $buffers, "bufferViews": $bufferViews, "cameras": $cameras, "images": $images, "samplers": $samplers, "textures": $textures, "materials": $materials, "accessors": $accessors, "meshes": $meshes, "scenes": $scenes, "nodes": $nodes, "sceneId": ${_scene.sceneId}';
  }

  static void reset({bool fullReset : false}) {
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