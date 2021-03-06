import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/asset_library.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/library.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/assets_manager/loaders/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_bin_loader.dart';
import 'package:webgl/src/widgets/loader.dart';

Future main() async {
//  test_getSingleFileSize();
//  test_singleLoader();
//  test_loadCustomLibrary();
//  test_loadMultipleFiles();
  test_loadFromBaseImageLibrary();
}

Future test_getSingleFileSize() async {
  String bin = '/webgl/projects/gltf/projects/archi/model_01/model_01.bin';
  ByteBufferLoader loader = new ByteBufferLoader()
  ..filePath = bin;

  var size = await loader.getFileSize();
  print(size);

  await loader.load();

  ByteBuffer byteBuffer = loader.result;
  assert(byteBuffer != null);
}

/// utilisation d'un loader directement. C'est lui qui fournit sa progression de chargement
Future test_singleLoader() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  ImageLoader imageLoader = new ImageLoader()
    ..filePath = 'images/uv.png'
    ..onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
      loaderWidget.showProgress(loadProgressEvent.progressEvent.loaded, loadProgressEvent.progressEvent.total, 1);
    });
  await imageLoader.load();
  ImageElement uv = imageLoader.result;
  document.body.children.add(uv);
}

/// il est possible d'ajouter des loaders individuelement pour tenir compte du chargement en ajoutant les loader à une [Library]
Future test_loadMultipleFiles() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);

  Library library = new Library();

  // Todo (jpu) : faut-il vraiment chercher à regrouper les loading individuels en dehors d'une library ?
  library.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(library.loadedFileSize, library.totalFileSize, library.totalFileCount);
  });

  engine.init(null);

  String gltf = '/webgl/projects/gltf/projects/archi/model_01/model_01.gltf';
  GLTFProjectLoader gLTFProjectLoader = new GLTFProjectLoader()..filePath = gltf;
  library.addLoader(gLTFProjectLoader);
  await gLTFProjectLoader.load();
  GLTFProject project = gLTFProjectLoader.result;
  assert(project!=null);

  String bin = '/webgl/projects/gltf/projects/archi/model_01/model_01.bin';
  GLTFBinLoader gLTFBinLoader = new GLTFBinLoader()..filePath = bin;
  library.addLoader(gLTFBinLoader);

  await gLTFBinLoader.load();
  Uint8List uint8List = gLTFBinLoader.result;
  assert(uint8List != null);

  TextLoader textLoader = new TextLoader()..filePath = gltf;
  library.addLoader(textLoader);
  await textLoader.load();
  String text = textLoader.result;
  assert(text != null);

  print('done');

  print('loadedFiles length: ${library.loadedFiles.values.length}');
  print('loadedFiles size: ${library.loadedFiles.values.map((p)=> p.progressEvent.total).reduce((v,e)=>v+e)}');

  (library.loadedFiles.values.toList()..sort((a, b) => a.progressEvent.total.compareTo(b.progressEvent.total))).forEach((e){
    print('${e.progressEvent.total} : ${e.filePath}');
  });
}

/// ou crée une [Library] à part
Future test_loadCustomLibrary() async {
  LoaderWidget loaderWidget = new LoaderWidget();

  CanvasElement canvas = new CanvasElement();
  new GLTFEngine(canvas);//needed to test GLTFProject loading which add nodes to Engine+, // Todo (jpu) :

  MyLibrary myLibrary = new MyLibrary();
  myLibrary.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
    loaderWidget.showProgress(myLibrary.loadedFileSize, myLibrary.totalFileSize, myLibrary.totalFileCount);
  });
  await myLibrary.loadAll();

  ImageElement uv = myLibrary.uv;
  document.body.children.add(uv);
}

Future test_loadFromBaseImageLibrary() async {
  LoaderWidget loaderWidget = new LoaderWidget();
  AssetLibrary.project
    ..onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
      loaderWidget.showProgress(AssetLibrary.project.loadedFileSize, AssetLibrary.project.totalFileSize, AssetLibrary.project.totalFileCount);
    });

  //1 add loader to defaultImageLibrary
  ImageLoader imageLoader = new ImageLoader()
    ..filePath = 'packages/webgl/images/crate.gif';
  AssetLibrary.project.addLoader(imageLoader);

  await imageLoader.load();

  ImageElement crate = imageLoader.result;
  assert(crate != null);
  document.body.children.add(crate);

  //2 : utilisation de la libraire par défault
  await AssetLibrary.project.loadAll();

  ImageElement brdfLUT2 = AssetLibrary.project.brdfLUT;
  assert(brdfLUT2 != null);
  document.body.children.add(brdfLUT2);
}

class MyLibrary extends Library{
  String _uvFilePath = 'images/uv.png';
  ImageElement get uv => getImageElement(_uvFilePath);

  String _model01Path = '/webgl/projects/gltf/projects/archi/model_01/model_01.gltf';
  GLTFProject get model01 => getGLTFProject(_model01Path);

  String _model01BinPath = '/webgl/projects/gltf/projects/archi/model_01/model_01.bin';
  Uint8List get model01Bin => getGLTFBin(_model01BinPath);

  MyLibrary(){
    addImageElementPath(_uvFilePath);
    addGLTFProjectPath(_model01Path);// Todo (jpu) :  calculate full loaded file size with images and bin ?
    addGLTFBinPath(_model01BinPath);
  }
}