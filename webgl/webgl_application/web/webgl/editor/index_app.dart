import 'dart:async';
import 'package:angular/angular.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';
import 'package:webgl_application/components/app_component/app_component.template.dart' as ng;
import 'index_app.reflectable.dart';
import 'projects/projects.dart';
import 'samples/projects.dart';
import 'package:webgl/src/shaders/shader_source.dart';

//This gives access from the web console
Application get app => Application.instance;

WebGLRenderingContext get gl => GL;
Type get context => Context;

Future main() async {

  await ShaderSource.loadShaders();

  initializeReflectable();
//  test_introspection();

  bool useSample = false;
  if(useSample){
    ProjectService.loader = loadSampleProjects;
  }else{
    ProjectService.loader = loadBaseProjects;
  }
//  bootstrapStatic<AppComponent>(AppComponent,<dynamic>[ProjectService],ng.initReflector);

  runApp(ng.AppComponentNgFactory);
}