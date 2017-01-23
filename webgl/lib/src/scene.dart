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
import 'package:webgl/src/webgl_objects/datas/webgl_edit.dart';

abstract class Scene extends IEditElement implements ISetupScene, IUpdatableScene, IUpdatableSceneFunction{

  @override
  IEditElement currentSelection;

  @override
  Vector4 backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  Light light;
  AmbientLight ambientLight = new AmbientLight();

  List<Material> materials = new List();
  List<Model> models = new List();

  List<Camera> get cameras => models.where((m)=> m is Camera).toList();
  List<Light> get lights => models.where((m)=> m is Light).toList();

  Material defaultMaterial = new MaterialBase();

  Interaction interaction;

  Scene(){
    Context.mainCamera = new
    Camera(radians(25.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 20.0, 20.0)
      ..cameraController = new CameraController();

    GridModel grid = new GridModel();
    models.add(grid);

    AxisModel axis = new AxisModel();
    models.add(axis);
  }

  bool _isSetuped = false;

  Future setup() async{

    Future future = new Future.value();

    interaction = new Interaction();

    if(!_isSetuped){
      _isSetuped = true;
      setupUserInput();
      future = setupScene();
    }

    return future;
  }

  void addModel(Model model){
    model.material ??= defaultMaterial;
    model.name ??= model.runtimeType.toString();

    models.add(model);
    currentSelection = model;
  }

  void createModelByType(ModelType modelType){
    addModel(Model.createByType(modelType));
  }

  void assignMaterial(MaterialType materialType) {
    if(currentSelection is Model){
      Material.assignMaterialTypeToModel(materialType, currentSelection as Model);
    }
  }

  @override
  void updateUserInput() {
    updateUserInputFunction();
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
  setupUserInput() {
    updateUserInputFunction = (){
      interaction.update();
    };

    updateUserInputFunction();
  }

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;



}