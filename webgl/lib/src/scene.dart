import 'dart:convert';
@MirrorsUsed(
    targets: const [
      Scene,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/object3d.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'dart:async';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/utils_math.dart';

class Scene extends IEditElement implements ISetupScene, IUpdatableScene, IUpdatableSceneFunction{

  @override
  IEditElement currentSelection;

  @override
  Vector4 backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  Light light;
  AmbientLight ambientLight = new AmbientLight();

  List<Material> materials = new List();
  List<Model> models = new List();
  List<Camera> cameras = new List();
  List<Light> lights = new List();

  Material defaultMaterial = new MaterialBase();

  Interaction interaction;

  Scene(){
    Context.mainCamera = new
    Camera(radians(25.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 20.0, 20.0);
  }

  bool _isSetuped = false;

  Future setup() async{

    interaction = new Interaction();

    if(!_isSetuped){
      _isSetuped = true;
      setupUserInput();
      await setupScene();

      GridModel grid = new GridModel();
      models.add(grid);

      AxisModel axis = new AxisModel();
      models.add(axis);
    }
  }

  void add(Object3d object3d){
    if(object3d is Model) {
      object3d.material ??= defaultMaterial;
      object3d.name ??= object3d.runtimeType.toString();

      models.add(object3d);
      currentSelection = object3d;
    }else if(object3d is Camera){

    }
  }

  void createModelByType(ModelType modelType){
    add(new Model.createByType(modelType));
  }

  void assignMaterial(MaterialType materialType) {
    if(currentSelection is Model){
      Material.assignMaterialTypeToModel(materialType, currentSelection as Model);
    }
  }

  @override
  void update(num time) {
    if(updateFunction != null) {
      updateFunction(time);
    }
  }

  @override
  Future setupScene() {
    return new Future.value();
  }

  @override
  void render(){
    for (Model model in models) {
      model.render();
    }
  }

  @override
  void updateUserInput() {
    updateUserInputFunction();
  }

  @override
  setupUserInput() {
    if(updateUserInputFunction == null) {
      updateUserInputFunction = () {
        interaction.update();
      };
    }
    updateUserInputFunction();
  }

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  //permet de merger un json à la scene actuelle
  //bug: le controller sur la camera active est perdu
  void mergeJson(String jsonContent) {
    Map json = JSON.decode(jsonContent);
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

  // JSON

  static Future<Scene> fromJsonFilePath(String jsonFilePath) async {
    Map json = await Utils.loadJSONResource('../objects/json_scene.json');
    return new Scene.fromJson(json);
  }

  Scene.fromJson(Map json){
    Map jsonScene = json['scene'];

    backgroundColor = new Vector4.fromFloat32List(jsonScene["backgroundColor"]);

    if(jsonScene["cameras"] != null) {
      for (var item in jsonScene["cameras"] as List) {
        Camera camera = new Camera.fromJson(item);
        cameras.add(camera);
      }

      if(cameras.length > 0) {
        Context.mainCamera = cameras[0];
      }
    }

    if(jsonScene["lights"] != null) {
      for (var item in jsonScene["lights"] as List) {
        Light light = new Light.fromJson(item);
        lights.add(light);
      }
    }

    for(var item in jsonScene["models"] as List){
      Model model = new Model.fromJson(item);
      models.add(model);
    }
  }

  Map toJson(){

    Map jsonScene = new Map();
    jsonScene["backgroundColor"] = backgroundColor.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();

    if(lights.length > 0) {
      jsonScene["cameras"] = cameras;
    }

    if(lights.length > 0) {
      jsonScene["lights"] = lights;
    }

    jsonScene["models"] = models;

    Map json = new Map();
    json['scene'] = jsonScene;
    return json;
  }
}