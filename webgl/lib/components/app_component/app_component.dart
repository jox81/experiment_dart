import 'package:angular2/core.dart';
import 'package:webgl/components/canvas_component/canvas_component.dart';
import 'package:webgl/components/layout_component/layout_component.dart';
import 'package:webgl/components/properties_component/properties_component.dart';
import 'package:webgl/components/toolbar_component/toolbar_component.dart';
import 'package:webgl/components/vector3_component/vector3_component.dart';
import 'package:webgl/scene_views/scene_view.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/scene.dart';


@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [ToolbarComponent, CanvasComponent, LayoutComponent, PropertiesComponent]
)
class AppComponent implements AfterViewInit{

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

  switchScene () async {
    sceneId++;
    sceneId %= scenes.length;

    currentScene = scenes[sceneId];
    await currentScene.setup();
    application.render(currentScene);
  }

  @override
  ngAfterViewInit() async {
    application = await Application.create(canvasComponent.canvas);
    scenes = ServiceScene.getSceneViews();
    switchScene ();

    //Todo : ajouter la selection...
//    currentElement =
  }

}