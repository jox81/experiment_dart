import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:http/http.dart';


import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/introspection/base/base.dart';
import 'package:webgl_application/src/services/in_memory_data_service.dart';
import 'package:webgl_application/src/services/projects.dart';

import 'package:webgl_application/components/app_component/app_component.template.dart' as ng;

import 'index_app.reflectable.dart';
import 'index_app.template.dart' as self;

//This gives access from the web console
Application get app => Application.instance;

WebGLRenderingContext get gl => Context.glWrapper;
Type get context => Context;

Future main() async {

  initializeReflectable();
//  test_introspection();

  ProjectService.loader = loadBaseProjects;
//  bootstrapStatic<AppComponent>(AppComponent,<dynamic>[ProjectService],ng.initReflector);

  runApp(ng.AppComponentNgFactory);
}