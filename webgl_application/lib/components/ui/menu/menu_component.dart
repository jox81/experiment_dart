import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:webgl_application/directives/clickoutside_directive.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/textures/texture_library.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_edit.dart';

// Suivant l'exemple :
// http://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_dropdown_navbar_click

@Component(
    selector: 'menuBase',
    templateUrl: 'menu_component.html',
    styleUrls: const ['menu_component.css'],
    directives: const <dynamic>[ClickOutsideDirective])
class MenuComponent{

  Scene get currentScene => Application.instance.currentScene;

  Map<String, bool> openedMenus = {
    'headerId0' : false,
    'headerId1' : false,
    'headerId2' : false,
    'headerId3' : false,
    'headerId4' : false
  };

  bool isMenuVisible(String headerId){
    return openedMenus[headerId];
  }

  void headerClick(String headerId){
    openedMenus[headerId] = !openedMenus[headerId];
//    print('toggle menu $headerId : visible = ${openedMenus[headerId]}');
  }

  void closeAllMenus(){
    openedMenus.forEach((String k, bool v)=> openedMenus[k] = false);
  }

  void closeThisMenus(String headerId){
    openedMenus[headerId] = false;
  }

  // >> Files

  Future<bool> reset(Event event)async {
    Scene newScene = new Scene();
    await newScene.setup();
    Application.instance.currentScene = newScene;
    closeAllMenus();
    return false;
  }

  bool download(Event event){

    String fileName = 'scene.json';
    String content = Uri.encodeFull(JSON.encode(currentScene.toJson()));

    AnchorElement anchor = event.currentTarget as AnchorElement;
    anchor.href = 'data:text/plain;charset=utf-8,' + content;
    anchor.download = fileName;
    closeAllMenus();
    return true; //need to continue link effect
  }

  void open(Event event){
    File file = (event.target as FileUploadInputElement).files[0];
    FileReader reader = new FileReader()..readAsText(file);
    reader.onLoadEnd.listen((_)async {
      String jsonContent = reader.result as String;
      Scene newScene = new Scene.fromJson(JSON.decode(jsonContent) as Map);
      await newScene.setup();
      Application.instance.currentScene = newScene;
    });
    closeAllMenus();
  }

  // >> Meshs

  // use enums instead
  // bool createMeshByType(MeshType modelType){
  bool createMeshByType(String modelTypeString){

    MeshType modelType = MeshType.values.firstWhere((MeshType e)=> e.toString() == modelTypeString, orElse: ()=> null);

    if(currentScene != null && modelType != null){
      currentScene.createMeshByType(modelType);
    }else{
      print('$modelTypeString not created');
    }

    closeAllMenus();
    return false;
  }

  // >> Textures

  bool editTextures(){
    currentScene?.currentSelection = TextureLibrary.instance;
    closeAllMenus();
    return false;
  }

  // >> Materials

  // use enums instead
  // bool assignMaterial(MaterialType materialType){
  bool assignMaterial(String materialTypeString){

    MaterialType materialType = MaterialType.values.firstWhere((MaterialType e)=> e.toString() == materialTypeString, orElse: ()=> null);

    if(currentScene != null && materialType != null){
      currentScene.assignMaterial(materialType);
    }else{
      print('$materialTypeString not created');
    }

    closeAllMenus();
    return false;
  }

  // >> GL Edit

  bool editCustomSettings(){
    currentScene?.currentSelection = WebglEdit.instance(currentScene);
    closeAllMenus();
    return false;
  }

  bool editRenderingContext(){
    currentScene?.currentSelection = glWrapper;
    closeAllMenus();
    return false;
  }

  bool editContextAttributs(){
    currentScene?.currentSelection = glWrapper.contextAttributes;
    closeAllMenus();
    return false;
  }

  bool editActiveFrameBuffer(){
    currentScene?.currentSelection = glWrapper.activeFrameBuffer;
    closeAllMenus();
    return false;
  }

  bool editCurrentProgram(){
    currentScene?.currentSelection = glWrapper.currentProgram;
    closeAllMenus();
    return false;
  }

  bool editActiveTexture(){
    currentScene?.currentSelection = glWrapper.activeTexture;
    closeAllMenus();
    return false;
  }
}