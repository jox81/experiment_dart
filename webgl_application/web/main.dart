import 'dart:async';

import 'package:angular/angular.dart';

import 'package:webgl_application/components/app_component/app_component.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';
import 'main.template.dart' as ng;

//This gives access from the web console
Application get app => Application.instance;

WebGLRenderingContext get gl => Context.glWrapper;
Type get context => Context;

Future main() async {
  
  ProjectService.loader = loadBaseProjects;
  bootstrapStatic<AppComponent>(AppComponent,<dynamic>[ProjectService],ng.initReflector);
}