import 'dart:async';

import 'package:angular2/platform/browser.dart';
import 'package:webgl_application/components/app_component/app_component.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';

//This gives access from the web console
Application get app => Application.instance;

WebGLRenderingContext get gl => Context.glWrapper;
Type get context => Context;

Future main() async {
  ProjectService.loader = loadBaseProjects;
  bootstrap(AppComponent,[ProjectService]);
}