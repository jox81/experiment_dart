import 'package:angular2/platform/browser.dart';
import 'package:webgl/components/app_component/app_component.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/context.dart' as ctx;
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';

//Giving access from the web console
Application get app => Application.instance;

WebGLRenderingContext get gl => ctx.gl;
Type get context => ctx.Context;

void main() {
  bootstrap(AppComponent, <dynamic>[]);
}