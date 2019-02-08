import 'dart:async';
import 'dart:html';
import 'package:webgl/asset_library.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_bin_loader.dart';
import 'package:webgl_projects/loader.dart';

Future main() async {
//  test01();
  test02();
}

Future test01() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);
  AssetManager assetManager = Engine.assetManager;
  assetManager.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(loadProgressEvent);
  });

  engine.init();

  String gltf = '/gltf/projects/archi/model_01/model_01.gltf';
  await new GLTFProjectLoader().load(gltf);

  String bin = '/webgl/projects/jerome/projects/maison/maison_ivoz.bin';
  await new GLTFBinLoader().load(bin);

  print('done');

  await new TextLoader().load(gltf);

  print('loadedFiles length: ${assetManager.loadedFiles.values.length}');
  print('loadedFiles size: ${assetManager.loadedFiles.values.map((p)=> p.progressEvent.total).reduce((v,e)=>v+e)}');

  (assetManager.loadedFiles.values.toList()..sort((a, b) => a.progressEvent.total.compareTo(b.progressEvent.total))).forEach((e){
    print('${e.id} : ${e.progressEvent.total} : ${e.name}');
  });
}

Future test02() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  Loader.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(loadProgressEvent);
  });

  //1
  ImageElement brdfLUT = await new ImageLoader().load(AssetLibrary.images.brdfLUTPath);

  //2
  AssetLibrary.images.loadAll();
  ImageElement brdfLUT2 = AssetLibrary.images.brdfLUT;

}