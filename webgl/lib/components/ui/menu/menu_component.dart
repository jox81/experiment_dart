import 'package:angular2/core.dart';
import 'package:webgl/directives/clickoutside_directive.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_edit.dart';

// Suivant l'exemple :
// http://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_dropdown_navbar_click

@Component(
    selector: 'menuBase',
    templateUrl: 'menu_component.html',
    styleUrls: const ['menu_component.css'],
    directives: const [ClickOutsideDirective])
class MenuComponent{

  @Input()
  Scene currentScene;

  Map<String, bool> openedMenus = {
    'headerId1' : false,
    'headerId2' : false
  };

  bool isMenuVisible(String headerId){
    return openedMenus[headerId];
  }

  headerClick(String headerId){
    openedMenus[headerId] = !openedMenus[headerId];
    print('toggle menu $headerId : visible = ${openedMenus[headerId]}');
  }

  void closeAllMenus(){
    openedMenus.forEach((String k, bool v)=> openedMenus[k] = false);
  }

  void closeThisMenus(String headerId){
    openedMenus[headerId] = false;
  }

  // use enums instead
  // bool createModelByType(ModelType modelType){
  bool createModelByType(String modelTypeString){

    ModelType modelType = ModelType.values.firstWhere((ModelType e)=> e.toString() == modelTypeString, orElse: ()=> null);

    if(currentScene != null && modelType != null){
      currentScene.createModelByType(modelType);
    }else{
      print('$modelTypeString not created');
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
    currentScene?.currentSelection = gl;
    closeAllMenus();
    return false;
  }

  bool editContextAttributs(){
    currentScene?.currentSelection = gl.contextAttributes;
    closeAllMenus();
    return false;
  }

  bool editActiveFrameBuffer(){
    currentScene?.currentSelection = gl.activeFrameBuffer;
    closeAllMenus();
    return false;
  }

  bool editCurrentProgram(){
    currentScene?.currentSelection = gl.currentProgram;
    closeAllMenus();
    return false;
  }

  bool editActiveTexture(){
    currentScene?.currentSelection = gl.activeTexture;
    closeAllMenus();
    return false;
  }
}