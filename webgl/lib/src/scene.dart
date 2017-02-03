@MirrorsUsed(
    targets: const [
      Scene,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'dart:async';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';

abstract class Scene extends IEditElement implements ISetupScene, IUpdatableScene, IUpdatableSceneFunction{

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
      ..position = new Vector3(20.0, 20.0, 20.0)
      ..cameraController = new CameraController();
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
    add(Model.createByType(modelType));
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

  // Json

  static Scene createFromJson(Map json) {
    Scene scene =  new _SceneJson(json);
    return scene;
  }
}

class _SceneJson extends Scene{

  _SceneJson(Map json){
    backgroundColor = new Vector4.fromFloat32List(json["backgroundColor"]);

    for(var item in json["cameras"] as List){
      Camera camera = Camera.createFromJson(item);
      cameras.add(camera);
    }

    for(var item in json["models"] as List){
      Model model = Model.createFromJson(item);
      models.add(model);
    }
  }

  @override
  Future setupScene() {
    // TODO: implement setupScene
    return new Future.value();
  }

}