import 'dart:html' hide Node;

import 'package:webgl/src/camera.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/geometry/node.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/material/material.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class Project{
  List<Camera> cameras = new List();
  List<Material> materials = new List();
  List<WebGLTexture> textures = new List();
  List<ImageElement> images = new List();
  List<Mesh> meshes = new List();

  List<Scene> _scenes = new List();
  List<Scene> get scenes => _scenes.toList(growable: false);
  void addScene(Scene scene){
    assert(scene != null);
    _scenes.add(scene);
  }

  Scene _scene;
  Scene get scene => _scene;
  set scene(Scene value) {
    assert(value != null);
    Scene projectScene = _scenes.firstWhere((s)=>s.sceneId == value.sceneId, orElse: ()=> throw new Exception('Scene can only be bound to an existing project Scene. If you want to add a scene to the project use addScene Method.'));
    _scene = projectScene;
  }

  List<Node> _nodes = new List();
  List<Node> get nodes => _nodes.toList(growable: false);
  void addNode(Node value){
    assert(value != null);
    _nodes.add(value);
  }
  
  Project();
}