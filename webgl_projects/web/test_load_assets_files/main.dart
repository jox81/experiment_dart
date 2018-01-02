import 'dart:async';
import 'dart:convert';
import 'package:resource/resource.dart';
import 'package:webgl/src/utils/utils_assets.dart';

Future main() async {

  /// Page de test montrant plusieurs manière de récupérer le contenu de fichier se situant dans un autre package dans le dossier /lib

  Uri uri = new Uri.file("packages/webgl/shaders/material_point/material_point.vs.glsl");
  var resource = new Resource(uri);
  var string = await resource.readAsString(encoding: UTF8);
  print(string);

  //Uri from other package
  Uri uriPackageShader = new Uri.file("packages/webgl/shaders/material_point/material_point.vs.glsl");
  String shaderPackage = await UtilsAssets.loadGlslShader(uriPackageShader.path);
  print(shaderPackage);

//  //Uri from local project in lib
//  String currentPackage = "packages/webgl_projects";
//  String filePath = "shaders/kronos_gltf_pbr.vs.glsl";
//  Uri uriShader = new Uri.file('$currentPackage/$filePath');
//  String shader = await UtilsAssets.loadGlslShader(uriShader.path);
//  print(shader);

}
