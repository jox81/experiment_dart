import 'dart:async';
import 'package:resource/resource.dart';
import 'package:webgl/src/assets_manager/loaders/glsl_loader.dart';
import 'package:webgl/src/utils/utils_http.dart';
import 'package:path/path.dart' as path;

Future main() async {

  UtilsHttp.webPath = Uri.base.origin;

  /// Page de test montrant plusieurs manière de récupérer le contenu de fichier se situant dans un autre package dans le dossier /lib

  String packagesPath = path.join(Uri.base.origin, 'packages/webgl/shaders/material_point/material_point.vs.glsl');
  Resource myResource = new Resource(packagesPath);
  var resourceContents = await myResource.readAsString();
  print(resourceContents);


//  Uri uri = new Uri.file("packages/webgl/shaders/material_point/material_point.vs.glsl");
//  var resource = new Resource(uri);
//  var string = await resource.readAsString(encoding: UTF8);
//  print(string);

//  Uri from other package
  String packagesPath2 = path.join(Uri.base.origin, 'packages/webgl/shaders/material_point/material_point.vs.glsl');
  GLSLLoader loader = new GLSLLoader()
  ..filePath = packagesPath2;
  await loader.load();
  String shaderPackage = loader.result;
  print(shaderPackage);
//
////  Uri from local project in lib
//  String currentPackage = "packages/webgl";
//  String filePath = "/shaders/material_point/material_point.vs.glsl";
//  Uri uriShader = new Uri.file('$currentPackage/$filePath');
//  String shader = await UtilsAssets.loadGlslShader(uriShader.path);
//  print(shader);

}
