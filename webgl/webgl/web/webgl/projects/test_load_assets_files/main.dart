//import 'dart:async';
//import 'package:resource/resource.dart';
//import 'package:webgl/src/utils/utils_assets.dart';
//import 'package:path/path.dart' as path;
//import 'dart:convert';
//
/////to work, the file must be in a folder with the same nomenclature in the lib folder and in the web folder
//String baseShaderPath = 'shaders/material_base/material_base.vs.glsl';
//
//Future main() async {
//
//  assetManager.webPath = Uri.base.origin;
//  print('UtilsAssets.webPath : ${assetManager.webPath}');
//
//  /// Page de test montrant plusieurs manière de récupérer le contenu de fichier se situant dans un autre package dans le dossier /lib
//
//  /// > Local to web/package folder
//
//  await loadFileFromOtherPackagePathWithResource();
//  await loadFileFromOtherPackageUriWithResource();
//
//  await loadFileFromOtherPackagePathWithUtils();
//  await loadFileFromOtherPackageUriWithUtils();
//
//  /// > Local to web folder
//
//  await loadFileFromWebUriWithResource();
//  await loadFileFromWebUriWithUtils();
//}
//
///// > Local to web/package folder
//
////Path
////Package
////Resource
//Future loadFileFromOtherPackagePathWithResource() async {
//  print('loadFileFromOtherPackagePathWithResource');
//  String packagesPath = path.join(Uri.base.origin, 'packages/webgl/$baseShaderPath');
//  Resource myResource = new Resource(packagesPath);
//  String shader = await myResource.readAsString();
//  print(shader);
//}
//
////Uri
////Package
////Resource
//Future loadFileFromOtherPackageUriWithResource() async {
//  print('loadFileFromOtherPackageUriWithResource');
//  Uri uri = new Uri.file("packages/webgl/$baseShaderPath");
//  Resource resource = new Resource(uri);
//  String string = await resource.readAsString(encoding: utf8);
//  print(string);
//}
//
////Path
////Package
////Utils
//Future loadFileFromOtherPackagePathWithUtils() async {
//  print('loadFileFromOtherPackagePathWithUtils');
//  String packagesPath = path.join(Uri.base.origin, 'packages/webgl/$baseShaderPath');
//  String shader = await assetManager.loadGlslShader(packagesPath);
//  print(shader);
//}
//
////Uri
////Package
////Resource
//Future loadFileFromOtherPackageUriWithUtils() async {
//  print('loadFileFromOtherPackageUriWithUtils');
//  String currentPackage = "packages/webgl";
//  String filePath = "/$baseShaderPath";
//  Uri uriShader = new Uri.file('$currentPackage/$filePath');
//  String shader = await assetManager.loadGlslShader(uriShader.path);
//  print(shader);
//}
//
///// > Local to web folder
//
////Uri
////Web relative url
////Resource
//Future loadFileFromWebUriWithResource() async {
//  print('loadFileFromWebUriWithResource');
//  Uri uri = new Uri.file("./$baseShaderPath");
//  Resource resource = new Resource(uri);
//  String string = await resource.readAsString(encoding: utf8);
//  print(string);
//}
//
////String path
////Web absolute url
////Utils
//Future loadFileFromWebUriWithUtils() async {
//  print('loadFileFromWebUriWithUtils');
//  String filePath = "webgl/projects/test_load_assets_files/$baseShaderPath";
//  String packagesPath = path.join(Uri.base.origin, filePath);
//  String shader = await assetManager.loadGlslShader(packagesPath);
//  print(shader);
//}