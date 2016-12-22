import 'package:angular2/core.dart';
import 'package:webgl/directives/clickoutside_directive.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';

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

  Map<String, bool> opendMenus = {
    'headerId1' : false
  };

  bool isMenuVisible(String headerId){
    return opendMenus['headerId1'];
  }

  headerClick(String headerId){
    opendMenus['headerId1'] = !opendMenus['headerId1'];
    print('toggle menu $headerId : visible = ${opendMenus['headerId1']}');
  }

  void closeAllMenus(){
    print('closing all menus');
    opendMenus.forEach((String k, bool v)=> opendMenus[k] = false);
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
}