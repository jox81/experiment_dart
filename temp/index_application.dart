import 'dart:async';
import 'package:angular2/platform/browser.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/utils/utils_assets.dart';
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
  ProjectService.projects = await ProjectsLoader.loadBaseProjects();
  bootstrap(AppComponent, <dynamic>[ProjectService]);
}

class ProjectsLoader{

  static Future<List<GLTFProject>> loadBaseProjects() async => [
    await model01()
  ];

  static Future<GLTFProject> model01() async {

    List<String> gltfSamplesPaths = [
//      './gltf/projects/archi/model_01/model_01.gltf',
    './gltf/projects/archi/model_02/model_02.gltf',
    ];

    UtilsAssets.webPath = './';

    return await loadGLTF(gltfSamplesPaths.first, useWebPath : false);
  }
}
