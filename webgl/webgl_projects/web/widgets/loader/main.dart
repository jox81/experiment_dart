import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/asset_library.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/library.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_bin_loader.dart';
import 'package:webgl_projects/loader.dart';

Future main() async {
//  test_getSize();
//  test_showProgress();
//  test_LoadFromBaseLibrayr();
//  test_LoadLocal();
  test_LoadLibraryLocal();
}

Future test_getSize() async {
  LoaderWidget loaderWidget = new LoaderWidget();
  Loader.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(loadProgressEvent);
  });

  String bin = '/webgl/projects/jerome/projects/maison/maison_ivoz.bin';
  var size = await new ByteBufferLoader().getFileSize(bin);
  print(size);
}

Future test_showProgress() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);
  Loader.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(loadProgressEvent);
  });

  engine.init();

  String gltf = '/gltf/projects/archi/model_01/model_01.gltf';
  await new GLTFProjectLoader().load(gltf);

  String bin = '/webgl/projects/jerome/projects/maison/maison_ivoz.bin';
  await new GLTFBinLoader().load(bin);

  print('done');

  await new TextLoader().load(gltf);

  print('loadedFiles length: ${Loader.loadedFiles.values.length}');
  print('loadedFiles size: ${Loader.loadedFiles.values.map((p)=> p.progressEvent.total).reduce((v,e)=>v+e)}');

  (Loader.loadedFiles.values.toList()..sort((a, b) => a.progressEvent.total.compareTo(b.progressEvent.total))).forEach((e){
    print('${e.id} : ${e.progressEvent.total} : ${e.name}');
  });
}

Future test_LoadFromBaseLibrayr() async {
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

Future test_LoadLocal() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  Loader.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(loadProgressEvent);
  });

  ImageElement uv = await new ImageLoader().load('images/uv.png');
  document.body.children.add(uv);
}

Future test_LoadLibraryLocal() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);

  Loader.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(loadProgressEvent);
  });

  MyLibrary myLibrary = new MyLibrary();
  await myLibrary.loadAll();

//  ImageElement uv = myLibrary.uv;

//  document.body.children.add(uv);
}

class MyLibrary extends Library{
  String _uvFilePath = 'images/uv.png';
  ImageElement get uv => getImageElement(_uvFilePath);

  String _model01Path = '/webgl/projects/jerome/projects/maison/maison_ivoz.gltf';
  GLTFProject get model01 => getGLTFProject(_model01Path);

  String _model01BinPath = '/webgl/projects/jerome/projects/maison/maison_ivoz.bin';
  Uint8List get model01Bin => getGLTFBin(_model01BinPath);

  MyLibrary(){
    addImageElementPath(_uvFilePath);
    addGLTFProjectPath(_model01Path);// Todo (jpu) :  calculate full loaded file size with images and bin ?
    addGLTFBinPath(_model01BinPath);
  }
}