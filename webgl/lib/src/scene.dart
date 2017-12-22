import 'dart:convert';
@MirrorsUsed(
    targets: const [
      Scene,
    ],
    override: '*')
import 'dart:mirrors';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/object3d.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'dart:async';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/material.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/utils/utils_math.dart';

class Scene extends IEditElement implements ISetupScene, IUpdatableScene, IUpdatableSceneFunction{

  @override
  IEditElement currentSelection;

  Vector4 backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  Light light;
  AmbientLight ambientLight = new AmbientLight();

  List<Material> materials = new List();
  List<Model> models = new List();
  List<CameraPerspective> cameras = new List();
  List<Light> lights = new List();

  Material defaultMaterial = new MaterialBase();

  Interaction get interaction => Context.application.interaction;

  Scene(){
    if(Context.mainCamera == null){
      Context.mainCamera = new
      CameraPerspective(radians(25.0), 0.1, 1000.0)
        ..targetPosition = new Vector3.zero()
        ..position = new Vector3(20.0, 20.0, 20.0);
    }
  }

  bool _isSetuped = false;

  // >> setup

  /// Il faut appeler cette fonction juste après l'instanciation
  Future setup() async{

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

  @override
  void setupUserInput() {

    //Lazy init here if null
    if(updateUserInputFunction == null) {
      updateUserInputFunction = () {
        interaction.update();
      };
    }

    //why here ?
    //updateUserInputFunction();
  }

  ///Fonction à surcharger pour setuper la scene
  @override
  void setupScene() {
  }

  // >> Update

  @override
  void update(){
//    window.console.time('02_scene::update');
    updateUserInput();
    updateScene();
//    window.console.timeEnd('02_scene::update');
  }

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  void updateUserInput() {
    updateUserInputFunction();
  }

  ///Fonction à surcharger dans la scene descendante permettant d'indiquer
  ///les updates à réaliser avec les objects qui y sont créés
  @override
  UpdateFunction updateSceneFunction = (){};

  @override
  void updateScene() {
    for (Model model in models) {
      model.update();
    }
    if(updateSceneFunction != null) {
      updateSceneFunction();
    }
  }

  // >>

  @override
  void render(){
//    window.console.time('02_scene::render');
    for (Model model in models) {
      model.render();
    }

    for (Camera camera in cameras) {
      camera.render();
    }
//    window.console.timeEnd('02_scene::render');
  }

  // >>

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
      Materials.assignMaterialTypeToModel(materialType, currentSelection as Model);
    }
  }

  // JSON

  //permet de merger un json à la scene actuelle
  //bug: le controller sur la camera active est perdu
  void mergeJson(String jsonContent) {
    Map json = JSON.decode(jsonContent) as Map;
    Map jsonScene = json['scene'] as Map;

    backgroundColor = new Vector4.fromFloat32List(jsonScene["backgroundColor"] as Float32List);

    for(var item in jsonScene["cameras"] as List){
      CameraPerspective camera = new CameraPerspective.fromJson(item as Map);
      cameras.add(camera);
    }

    for(var item in jsonScene["models"] as List){
      Model model = new Model.fromJson(item as Map);
      models.add(model);
    }
  }

  static Future<Scene> fromJsonFilePath(String jsonFilePath) async {
    Map json = await UtilsAssets.loadJSONResource(jsonFilePath);
    return new Scene.fromJson(json);
  }

  Scene.fromJson(Map json){
    Map jsonScene = json['scene'] as Map;

    backgroundColor = new Vector4.fromFloat32List(new Float32List.fromList(jsonScene["backgroundColor"] as List<double>));

    if(jsonScene["cameras"] != null) {
      for (var item in jsonScene["cameras"] as List) {
        CameraPerspective camera = new CameraPerspective.fromJson(item as Map);
        cameras.add(camera);
      }

      if(cameras.length > 0) {
        Context.mainCamera = cameras[0];
      }
    }

    if(Context.mainCamera == null){
      Context.mainCamera = new
      CameraPerspective(radians(25.0), 0.1, 1000.0)
        ..targetPosition = new Vector3.zero()
        ..position = new Vector3(20.0, 20.0, 20.0);
    }

    if(jsonScene["lights"] != null) {
      for (var item in jsonScene["lights"] as List) {
        Light light = new Light.fromJson(item as Map);
        lights.add(light);
      }
    }

    if(jsonScene["models"] != null) {
      for (var item in jsonScene["models"] as List) {
        Model model = new Model.fromJson(item as Map);
        models.add(model);
      }
    }
  }

  Map toJson(){

    Map jsonScene = new Map<String, Object>();
    jsonScene["backgroundColor"] = backgroundColor.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();

    if(lights.length > 0) {
      jsonScene["cameras"] = cameras;
    }

    if(lights.length > 0) {
      jsonScene["lights"] = lights;
    }

    jsonScene["models"] = models;

    Map json = new Map<String, Object>();
    json['scene'] = jsonScene;
    return json;
  }
}