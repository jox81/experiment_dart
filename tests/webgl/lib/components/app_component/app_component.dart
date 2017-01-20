import 'dart:async';
import 'package:angular2/core.dart';
import 'package:webgl/components/canvas_component/canvas_component.dart';
import 'package:webgl/components/layout_component/layout_component.dart';
import 'package:webgl/components/properties_component/properties_component.dart';
import 'package:webgl/components/ui/menu/menu_component.dart';
import 'package:webgl/components/ui/toolbar_component/toolbar_component.dart';
import 'package:webgl/scene_views/scene_view.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/ui_models/toolbar.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [ToolBarComponent, CanvasComponent, LayoutComponent, PropertiesComponent, MenuComponent]
)
class AppComponent implements OnInit{

  Application application;
  Scene currentScene;

  IEditElement _currentElement;
  IEditElement get currentElement {
    if(currentScene != null) {
      if (currentScene.currentSelection != null) {
        _currentElement = currentScene.currentSelection;
      }else{
        _currentElement = currentScene;
      }
    }

    return _currentElement;
  }

  @ViewChild(CanvasComponent)
  CanvasComponent canvasComponent;

  List<Scene> scenes;
  int sceneId = -1;

  Future switchScene () async {
    sceneId++;
    sceneId %= scenes.length;

    currentScene = scenes[sceneId];
    await currentScene.setup();
    application.render(currentScene);
  }

  void selectElement(IEditElement element){
    currentScene.currentSelection = element;
  }

  void onAxisXChange(bool checked){
//    print('onAxisXChange $checked');
  }

  ToolBar getToolBar(String toolBarName){
    if(application != null) {
      if (application.toolBars.containsKey(toolBarName)) {
        return application.toolBars[toolBarName];
      }
    }
    return null;
  }
  @override
  ngOnInit() async {
    application = await Application.create(canvasComponent.canvas);
    scenes = ServiceScene.getSceneViews();
    switchScene ();
  }
}
