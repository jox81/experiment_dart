import 'dart:async';
import 'package:angular2/core.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl_application/components/ui/canvas_component/canvas_component.dart';
import 'package:webgl_application/components/ui/layout_component/layout_component.dart';
import 'package:webgl_application/components/ui/properties_component/properties_component.dart';
import 'package:webgl_application/components/ui/menu/menu_component.dart';
import 'package:webgl_application/components/ui/toolbar_component/toolbar_component.dart';
import 'package:webgl_application/scene_views/scene_view.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const <dynamic>[ToolBarComponent, CanvasComponent, LayoutComponent, PropertiesComponent, MenuComponent]
)
class AppComponent implements OnInit{

  Application get application => Application.instance;

  GLTFScene get currentScene => application?.currentScene;
  GLTFProject get currentProject => application?.project;

  IEditElement _currentElement;
  IEditElement get currentElement {
    if(application != null) {
      if (application.currentSelection != null) {
        _currentElement = application.currentSelection;
      }else{
        _currentElement = currentProject;
      }
    }

    return _currentElement;
  }

  @ViewChild(CanvasComponent)
  CanvasComponent canvasComponent;

  List<GLTFProject> projects;
//  int sceneId = -1;

  Future switchScene () async {
//    sceneId++;
//    sceneId %= scenes.length;

//    await scenes[sceneId].setup();
    application.project = projects[0];
    application.render();
  }

  void selectElement(IEditElement element){
    application.currentSelection = element;
  }

  void onAxisXChange(bool checked){
//    print('onAxisXChange $checked');
  }

  ToolBar getToolBar(String toolBarName){
    if(application != null) {
      if (ToolBars.instance.toolBars.containsKey(toolBarName)) {
        return ToolBars.instance.toolBars[toolBarName];
      }
    }
    return new ToolBar(ToolBarItemsType.single);
  }
  @override
  Future ngOnInit() async {
    await Application.build(canvasComponent.canvas);
    projects = await ServiceProject.getProjects();
    await switchScene ();
  }

  bool isEditing = true;
}
