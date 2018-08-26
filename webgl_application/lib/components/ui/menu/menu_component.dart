import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:node_engine/src/node_editor.dart';
import 'package:node_engine/src/nodes/node.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl_application/directives/clickoutside_directive.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_edit.dart';
import 'package:webgl_application/src/application.dart';

// Suivant l'exemple :
// http://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_dropdown_navbar_click

@Component(
    selector: 'menuBase',
    templateUrl: 'menu_component.html',
    styleUrls: const ['menu_component.css'],
    directives: const <dynamic>[ClickOutsideDirective])
class MenuComponent{

  Application get application => Application.instance;

  GLTFScene get currentScene => application.currentScene;
  set currentSelection(CustomEditElement value) => application?.currentSelection = value;

  Map<String, bool> openedMenus = {
    'headerId0' : false,
    'headerId1' : false,
    'headerId2' : false,
    'headerId3' : false,
    'headerId4' : false,
    'headerId5' : false
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
    GLTFProject newProject = new GLTFProject.create(reset: true);
    application.project = newProject;
    closeAllMenus();
    return false;
  }

  bool download(Event event){

    String fileName = 'scene.json';
    String content = Uri.encodeFull(json.encode(new CustomEditElement(currentScene).toJson()));

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
      // Todo (jpu) : replace with GLTF

      throw 'MenuComponent.open not implemented';
//      GLTFProject newProject = new SceneJox.fromJson(JSON.decode(jsonContent) as Map);
//      Context.application.project = newProject;
    });
    closeAllMenus();
  }

  // >> Meshs

  // use enums instead in angular template. can't get enum for now
//   bool createMeshByType(MeshType meshType){
  bool createMeshByType(String meshTypeString){

    MeshType meshType = MeshType.values.firstWhere((MeshType e)=> e.toString() == meshTypeString, orElse: ()=> null);

    if(currentScene != null && meshType != null){
//      throw 'MenuComponent.createMeshByType not implemented';
      currentScene.createMeshByType(meshType);
    }else{
      print('$meshTypeString not created');
    }

    closeAllMenus();
    return false;
  }

  // >> Textures

  bool editTextures(){
    currentSelection = new CustomEditElement(TextureLibrary.instance);
    closeAllMenus();
    return false;
  }

  // >> Materials

  // use enums instead
  // bool assignMaterial(MaterialType materialType){
  bool assignMaterial(String materialTypeString){

    MaterialType materialType = MaterialType.values.firstWhere((MaterialType e)=> e.toString() == materialTypeString, orElse: ()=> null);

    if(currentScene != null && materialType != null){
      throw 'MenuComponent.assignMaterial not implemented';
//      currentScene.assignMaterial(materialType);
    }else{
      print('$materialTypeString not created');
    }

    closeAllMenus();
    return false;
  }

  // >> GL Edit

  bool editCustomSettings(){
    currentSelection = new CustomEditElement(WebglEdit.instance(currentScene));
    closeAllMenus();
    return false;
  }

  bool editRenderingContext(){
    currentSelection = new CustomEditElement(Context.glWrapper);
    closeAllMenus();
    return false;
  }

  bool editContextAttributs(){
    currentSelection = new CustomEditElement(Context.glWrapper.contextAttributes);
    closeAllMenus();
    return false;
  }

  bool editActiveFrameBuffer(){
    currentSelection = new CustomEditElement(Context.glWrapper.activeFrameBuffer);
    closeAllMenus();
    return false;
  }

  bool editCurrentProgram(){
    currentSelection = new CustomEditElement(Context.glWrapper.currentProgram);
    closeAllMenus();
    return false;
  }

  bool editActiveTexture(){
    currentSelection = new CustomEditElement(Context.glWrapper.activeTexture);
    closeAllMenus();
    return false;
  }

  // >> Node Engine

  bool toggleNodeView(){

    Element mainView = querySelector('#mainView');
    new NodeEditor.init(parent: mainView);

    closeAllMenus();
    return false;
  }
  bool createNode(String nodeTypeString){
    NodeItemType nodeItemType = NodeItemType.values.firstWhere((NodeItemType e)=> e.toString() == nodeTypeString, orElse: ()=> null);
    NodeEditor.editor.createNodeByType(nodeItemType);

    closeAllMenus();
    return false;
  }

}