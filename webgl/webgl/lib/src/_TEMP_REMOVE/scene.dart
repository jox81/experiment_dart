//import 'dart:convert';
//import 'dart:typed_data';
//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/geometry/node.dart';
//import 'package:webgl/src/camera.dart';
//import 'package:webgl/src/context.dart';
//import 'package:webgl/src/introspection/introspection.dart';
//import 'package:webgl/src/light.dart';
//import 'package:webgl/src/interface/IScene.dart';
//import 'dart:async';
//import 'package:webgl/src/utils/utils_assets.dart';
//import 'package:webgl/src/utils/utils_math.dart';
//
//abstract class Sceneimplements ISetupScene, IUpdatableScene, IUpdatableSceneFunction{
//  static int nextId = 0;
//  final int sceneId = nextId++;
//
//  List<Mesh> get meshes;
//
//  List<Camera> get cameras;
//
//  Vector4 get backgroundColor;
//
//  void createMeshByType(MeshType modelType);
//  void assignMaterial(MaterialType materialType);
//}
//
//class SceneJox extends Scene{
//
//  @override
//  IEditElement currentSelection;
//
//  Vector4 backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
//
//  Light light;
//  AmbientLight ambientLight = new AmbientLight();
//
//  List<Material> materials = new List();
//  List<Mesh> meshes = new List();
//  List<CameraPerspective> cameras = new List();
//  List<Light> lights = new List();
//
//  Material defaultMaterial = new MaterialBase();
//
//  SceneJox(){
//    if(Engine.mainCamera == null){
//      Engine.mainCamera = new
//      CameraPerspective(radians(25.0), 0.1, 1000.0)
//        ..targetPosition = new Vector3.zero()
//        ..translation = new Vector3(20.0, 20.0, 20.0);
//    }
//  }
//
//  bool _isSetuped = false;
//
//  // >> setup
//
//  /// Il faut appeler cette fonction juste après l'instanciation
//  Future setup() async{
//
//    if(!_isSetuped){
//      _isSetuped = true;
//      setupUserInput();
//      await setupScene();
//
//      GridMesh grid = new GridMesh();
//      meshes.add(grid);
//
//      AxisMesh axis = new AxisMesh();
//      meshes.add(axis);
//    }
//  }
//
//  @override
//  void setupUserInput() {
//
//    //Lazy init here if null
//    if(updateUserInputFunction == null) {
//      updateUserInputFunction = () {};
//    }
//
//    //why here ?
//    //updateUserInputFunction();
//  }
//
//  ///Fonction à surcharger pour setuper la scene
//  @override
//  void setupScene() {
//  }
//
//  // >> Update
//
//  @override
//  void update(){
////    window.console.time('02_scene::update');
//    updateUserInput();
//    updateScene();
////    window.console.timeEnd('02_scene::update');
//  }
//
//  @override
//  UpdateUserInput updateUserInputFunction;
//
//  @override
//  void updateUserInput() {
//    updateUserInputFunction();
//  }
//
//  ///Fonction à surcharger dans la scene descendante permettant d'indiquer
//  ///les updates à réaliser avec les objects qui y sont créés
//  @override
//  UpdateFunction updateSceneFunction = (){};
//
//  @override
//  void updateScene() {
//    for (Mesh model in meshes) {
//      model.update();
//    }
//    if(updateSceneFunction != null) {
//      updateSceneFunction();
//    }
//  }
//
//  // >>
//
//  @override
//  void render(){
//    for (Mesh model in meshes) {
//      model.render();
//    }
//
//    for (Camera camera in cameras) {
//      camera.render();
//    }
//  }
//
//  // >>
//
//  void add(Node node){
//    if(node is Mesh) {
//      node.primitive.material ??= defaultMaterial;
//      node.name ??= node.runtimeType.toString();
//
//      meshes.add(node);
//      currentSelection = node;
//    }else if(node is Camera){
//
//    }
//  }
//
//  void createMeshByType(MeshType modelType){
//    add(new Mesh.createByType(modelType));
//  }
//
//  void assignMaterial(MaterialType materialType) {
//    if(currentSelection is Mesh){
//      Materials.assignMaterialTypeToModel(materialType, currentSelection as Mesh);
//    }
//  }
//
//  // JSON
//
//  //permet de merger un json à la scene actuelle
//  //bug: le controller sur la camera active est perdu
//  void mergeJson(String jsonContent) {
//    Map json = JSON.decode(jsonContent) as Map;
//    Map jsonScene = json['scene'] as Map;
//
//    backgroundColor = new Vector4.fromFloat32List(jsonScene["backgroundColor"] as Float32List);
//
//    for(var item in jsonScene["cameras"] as List){
//      CameraPerspective camera = new CameraPerspective.fromJson(item as Map);
//      cameras.add(camera);
//    }
//
//    for(var item in jsonScene["models"] as List){
//      Mesh model = new Mesh.fromJson(item as Map);
//      meshes.add(model);
//    }
//  }
//
//  static Future<Scene> fromJsonFilePath(String jsonFilePath) async {
//    Map json = await UtilsAssets.loadJSONResource(jsonFilePath);
//    return new SceneJox.fromJson(json);
//  }
//
//  SceneJox.fromJson(Map json){
//    Map jsonScene = json['scene'] as Map;
//
//    backgroundColor = new Vector4.fromFloat32List(new Float32List.fromList(jsonScene["backgroundColor"] as List<double>));
//
//    if(jsonScene["cameras"] != null) {
//      for (var item in jsonScene["cameras"] as List) {
//        CameraPerspective camera = new CameraPerspective.fromJson(item as Map);
//        cameras.add(camera);
//      }
//
//      if(cameras.length > 0) {
//        Engine.mainCamera = cameras[0];
//      }
//    }
//
//    if(Engine.mainCamera == null){
//      Engine.mainCamera = new
//      CameraPerspective(radians(25.0), 0.1, 1000.0)
//        ..targetPosition = new Vector3.zero()
//        ..translation = new Vector3(20.0, 20.0, 20.0);
//    }
//
//    if(jsonScene["lights"] != null) {
//      for (var item in jsonScene["lights"] as List) {
//        Light light = new Light.fromJson(item as Map);
//        lights.add(light);
//      }
//    }
//
//    if(jsonScene["models"] != null) {
//      for (var item in jsonScene["models"] as List) {
//        Mesh model = new Mesh.fromJson(item as Map);
//        meshes.add(model);
//      }
//    }
//  }
//
//  Map toJson(){
//
//    Map jsonScene = new Map<String, Object>();
//    jsonScene["backgroundColor"] = backgroundColor.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
//
//    if(lights.length > 0) {
//      jsonScene["cameras"] = cameras;
//    }
//
//    if(lights.length > 0) {
//      jsonScene["lights"] = lights;
//    }
//
//    jsonScene["models"] = meshes;
//
//    Map json = new Map<String, Object>();
//    json['scene'] = jsonScene;
//    return json;
//  }
//}