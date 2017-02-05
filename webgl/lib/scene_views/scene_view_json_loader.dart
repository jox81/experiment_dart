import 'dart:convert';
import 'dart:html';
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

  SceneViewJsonLoader();

  @override
  Future setupScene() async {

  }

  // JSON

  static Future<SceneViewJsonLoader> fromJsonFilePath(String jsonFilePath) async {
    Map json = await Utils.loadJSONResource('../objects/json_scene.json');
    return new SceneViewJsonLoader.fromJson(json);
  }

  SceneViewJsonLoader.fromJson(Map json){
    Map jsonScene = json['scene'];

    backgroundColor = new Vector4.fromFloat32List(jsonScene["backgroundColor"]);

    for(var item in jsonScene["cameras"] as List){
      Camera camera = new Camera.fromJson(item);
      cameras.add(camera);
    }

    for(var item in jsonScene["models"] as List){
      Model model = new Model.fromJson(item);
      models.add(model);
    }
  }

  Map toJson(){

    Map jsonScene = new Map();
    jsonScene["backgroundColor"] = backgroundColor.storage;//.map((v)=>v.toDouble()).toList();
    jsonScene["cameras"] = cameras;
    jsonScene["models"] = models;

    Map json = new Map();
    json['scene'] = jsonScene;
    return json;
  }
}
