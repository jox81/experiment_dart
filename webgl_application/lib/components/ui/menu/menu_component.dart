import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angular2/core.dart';
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
  set currentSelection(IEditElement value) => application?.currentSelection = value;

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
      // Todo (jpu) : replace with GLTF

      throw 'MenuComponent.open not implemented';
//      GLTFProject newProject = new SceneJox.fromJson(JSON.decode(jsonContent) as Map);
//      Context.application.project = newProject;
    });
    closeAllMenus();
  }

  // >> Meshs

  // use enums instead
  // bool createMeshByType(MeshType modelType){
  bool createMeshByType(String modelTypeString){

    MeshType modelType = MeshType.values.firstWhere((MeshType e)=> e.toString() == modelTypeString, orElse: ()=> null);

    if(currentScene != null && modelType != null){
      throw 'MenuComponent.createMeshByType not implemented';
//      currentScene.createMeshByType(modelType);
    }else{
      print('$modelTypeString not created');
    }

    closeAllMenus();
    return false;
  }

  // >> Textures

  bool editTextures(){
    currentSelection = TextureLibrary.instance;
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
    currentSelection = WebglEdit.instance(currentScene);
    closeAllMenus();
    return false;
  }

  bool editRenderingContext(){
    currentSelection = Context.glWrapper;
    closeAllMenus();
    return false;
  }

  bool editContextAttributs(){
    currentSelection = Context.glWrapper.contextAttributes;
    closeAllMenus();
    return false;
  }

  bool editActiveFrameBuffer(){
    currentSelection = Context.glWrapper.activeFrameBuffer;
    closeAllMenus();
    return false;
  }

  bool editCurrentProgram(){
    currentSelection = Context.glWrapper.currentProgram;
    closeAllMenus();
    return false;
  }

  bool editActiveTexture(){
    currentSelection = Context.glWrapper.activeTexture;
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
    NodeType nodeType = NodeType.values.firstWhere((NodeType e)=> e.toString() == nodeTypeString, orElse: ()=> null);
    NodeEditor.editor.createNodeByType(nodeType);

    closeAllMenus();
    return false;
  }

  void fullExemple() {


//
//    NodeItem nodeInt01 = new NodeInt(2)..position = new Point<int>(20, 160);
//    NodeItem nodeInt02 = new NodeInt(3)..position = new Point<int>(20, 240);
//    NodeItem nodeInt03 = new NodeInt(4)..position = new Point<int>(420, 360);
//    NodeItem nodeDivide = new NodeDivide()..position = new Point<int>(250, 120);
//    NodeItem nodeAdd = new NodeAdd()..position = new Point<int>(480, 200);
//    NodeItem nodeMultiply = new NodeMultiply()..position = new Point<int>(690, 280);
//    NodeItem nodeLog = new NodeLog()..position = new Point<int>(900, 300);
//
//    // Connect Nodes
//    nodeInt01.outputFields[0].connectTo(nodeDivide.inputFields[0]);
//    nodeInt02.outputFields[0].connectTo(nodeAdd.inputFields[1]);
//    nodeInt02.outputFields[0].connectTo(nodeDivide.inputFields[1]);
//    nodeDivide.outputFields[0].connectTo(nodeAdd.inputFields[0]);
//    nodeAdd.outputFields[0].connectTo(nodeMultiply.inputFields[0]);
//    nodeInt03.outputFields[0].connectTo(nodeMultiply.inputFields[1]);
//    nodeMultiply.outputFields[0].connectTo(nodeLog.inputFields[0]);
  }
}