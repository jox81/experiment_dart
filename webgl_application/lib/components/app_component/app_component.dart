import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl_application/components/ui/canvas_component/canvas_component.dart';
import 'package:webgl_application/components/ui/layout_component/layout_component.dart';
import 'package:webgl_application/components/ui/properties_component/properties_component.dart';
import 'package:webgl_application/components/ui/menu/menu_component.dart';
import 'package:webgl_application/components/ui/toolbar_component/toolbar_component.dart';
import 'package:webgl_application/src/introspection.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const <dynamic>[coreDirectives, ToolBarComponent, CanvasComponent, LayoutComponent, PropertiesComponent, MenuComponent],
  providers: [const ClassProvider(ProjectService), CanvasComponent],
)
class AppComponent implements OnInit, AfterViewInit{

  final ProjectService projectService;
  List<GLTFProject> projects;

  AppComponent(this.projectService, this.canvasComponent);

  Application get application => Application.instance;

  GLTFScene get currentScene => application?.currentScene;
  GLTFProject get currentProject => application?.project;

  CustomEditElement _currentElement;
  CustomEditElement get currentElement {
    if(application != null) {
      if (application.currentSelection != null) {
        _currentElement = application.currentSelection;
      }else{
        _currentElement = new CustomEditElement(currentProject);
      }
    }

    return _currentElement;
  }

  @ViewChild(CanvasComponent)
  CanvasComponent canvasComponent;


//  int sceneId = -1;

  Future switchScene () async {
//    sceneId++;
//    sceneId %= scenes.length;

//    await scenes[sceneId].setup();
    if(projects[0] is Future) {
      application.project = await projects[0];
    }else {
      application.project = projects[0];
    }
    application.render();
  }

  void selectElement(CustomEditElement element){
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
  }

  @override
  Future ngAfterViewInit() async {
    print("");
    await Application.build(canvasComponent.canvas);
    projects = await projectService.getProjects();
    await switchScene ();
  }

  bool isEditing = true;


}
