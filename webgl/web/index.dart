import 'package:angular2/platform/browser.dart';
import 'package:webgl/components/app_component/app_component.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/context.dart' as ctx;

//Giving access from the web console
Application get app => Application.instance;

get gl => ctx.gl;
get Context => ctx.Context;

void main() {
  bootstrap(AppComponent, []);
}