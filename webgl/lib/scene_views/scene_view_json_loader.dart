import 'dart:convert';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      SceneViewJsonLoader,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class SceneViewJsonLoader extends Scene{

  String jsonScenePath;

  SceneViewJsonLoader.createWithFilePath(this.jsonScenePath);

  // Json
  static Future<Scene> createFromFilePath(String jsonScenePath) async {
    Map json = await Utils.loadJSONResource('../objects/json_scene.json');
    Scene scene =  new SceneViewJsonLoader.fromMap(json);
    return scene;
  }

  Map json;

  SceneViewJsonLoader.fromMap(this.json){
    buildJsonScene(json['scene']);
  }

  @override
  Future setupScene() async {
    if(json == null && jsonScenePath != null){
      json = await Utils.loadJSONResource('../objects/json_scene.json');
      buildJsonScene(json['scene']);
    }
  }

  void buildJsonScene(Map jsonScene){
    backgroundColor = new Vector4.fromFloat32List(jsonScene["backgroundColor"]);

    for(var item in jsonScene["cameras"] as List){
      Camera camera = Camera.createFromJson(item);
      cameras.add(camera);
    }

    for(var item in jsonScene["models"] as List){
      Model model = Model.createFromJson(item);
      models.add(model);
    }
  }
}
