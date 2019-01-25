import 'dart:async';
import 'package:angular/angular.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl_application/components/ui/canvas_component/canvas_component.dart';
import 'package:webgl_application/components/ui/layout_component/layout_component.dart';
import 'package:webgl_application/components/ui/properties_component/properties_component.dart';
import 'package:webgl_application/components/ui/menu/menu_component.dart';
import 'package:webgl_application/components/ui/toolbar_component/toolbar_component.dart';
import 'package:webgl/introspection.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const <dynamic>[coreDirectives, CanvasComponent, LayoutComponent, MenuComponent, ToolBarComponent, PropertiesComponent],
  providers: [const ClassProvider(ProjectService), CanvasComponent],
)
class AppComponent implements OnInit, AfterViewInit, AfterContentChecked, AfterContentInit, AfterViewChecked, OnChanges, OnDestroy {

  final ProjectService projectService;

  @ViewChild(CanvasComponent)
  CanvasComponent canvasComponent;

  bool isEditing = true;
  List<GLTFProject> projects;

  Application get application => Application.instance;
  GLTFScene get currentScene => application?.currentScene;
  GLTFProject get currentProject => application?.project;

  CustomEditElement _currentElement = new CustomEditElement(new GLTFNode());
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

  AppComponent(this.projectService, this.canvasComponent){
    print('AppComponent.AppComponent');
  }


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
//    print('AppComponent.ngOnChanges');
  }
  @override
  Future ngOnInit() async {
//    print('AppComponent.ngOnInit');
  }
  @override
  void ngAfterContentInit() {
//    print('AppComponent.ngAfterContentInit');
  }
  @override
  void ngAfterContentChecked() {
//    print('AppComponent.ngAfterContentChecked');
  }
  @override
  void ngAfterViewInit() {
    _loadProjects();///place this in init to work ?
//    print('AppComponent.ngAfterViewInit $projects');
  }
  @override
  void ngAfterViewChecked() {
//    print('AppComponent.ngAfterViewChecked');
  }
  @override
  void ngOnDestroy() {
//    print('AppComponent.ngOnDestroy');
  }

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

  Future _loadProjects() async {
    projects = await projectService.getProjects();
    await switchScene ();
  }
}

/*
CanvasComponent.CanvasComponent null

AppComponent.AppComponent
AppComponent.ngOnInit

AppComponent.ngDoCheck
AppComponent.ngAfterContentInit
AppComponent.ngAfterContentChecked
CanvasComponent.CanvasComponent null
CanvasComponent.ngOnInit
CanvasComponent.ngDoCheck
CanvasComponent.ngAfterContentInit
CanvasComponent.ngAfterContentChecked
CanvasComponent.ngAfterViewInit
CanvasComponent.ngAfterViewChecked
AppComponent.ngAfterViewInit
AppComponent.ngAfterViewChecked

AppComponent.ngDoCheck
AppComponent.ngAfterContentChecked
CanvasComponent.ngDoCheck
CanvasComponent.ngAfterContentChecked
CanvasComponent.ngAfterViewChecked
AppComponent.ngAfterViewChecked

AppComponent.ngDoCheck
AppComponent.ngAfterContentChecked
CanvasComponent.ngDoCheck
CanvasComponent.ngAfterContentChecked
CanvasComponent.ngAfterViewChecked
AppComponent.ngAfterViewChecked

...
 */
