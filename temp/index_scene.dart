import 'dart:async';
import 'dart:html';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl_application/src/application.dart';

Future main() async {
//  GLTFProject project = await ServiceProject.getProjects().then((p) => p[0]);

  String gltfPath = geGltfProjectPath();

  UtilsAssets.webPath = '../';

  GLTFProject project = await loadGLTF(gltfPath, useWebPath : false);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  await Application.build(canvas)
    ..project = project
    ..render();
}

String geGltfProjectPath(){

  String resultGltfPath;

  Map<int, ClientProject> projects = {
    0:  new ClientProject()
    ..projectsPath = {
      0:'./gltf/projects/archi/model_01/model_01.gltf',
    },
    'vanderheyden_nicolas'.hashCode:  new ClientProject() // 225543642
    ..projectsPath = {
      0:'http://www.3d-jox.be/projects/vanderheyden_nicolas/skull/skull.gltf',
    }
  };

  //?token=225543642&project=0

  //Client
  ClientProject clientProject;
  String queryTokenValue = Uri.base.queryParameters['token'];
  if(queryTokenValue != null && isNumeric(queryTokenValue)) {
    clientProject = projects[int.parse(queryTokenValue)];
  }

  if(clientProject != null) {
    //Project
    String queryValue = Uri.base.queryParameters['project'];
    if (queryValue != null && isNumeric(queryValue)) {
      resultGltfPath = clientProject.projectsPath[int.parse(queryValue)];
    }
  }

  if(resultGltfPath == null){
    resultGltfPath = projects[0].projectsPath[0];
  }

  return resultGltfPath;
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return int.parse(s, onError:(e) => null) != null;
}

logQueryStringInfos() {
  print(Uri.base.toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
  print(Uri.base.query);  // id=15&randomNumber=3.14
  print(Uri.base.queryParameters['randomNumber']); // 3.14
  print(Uri.splitQueryString(Uri.base.query)); //{id:15, RandomNumber : 3.14}
}

class ClientProject{
  //<projectId, path>
  Map<int, String> projectsPath;
}