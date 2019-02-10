import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_bin_loader.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';

enum LoaderType{
  imageElement,
  gltfProject,
  gltfBin
}

class LoaderFactory {
  Loader create(LoaderType loaderType) {
    Loader loader;

    switch(loaderType){
      case LoaderType.imageElement:
        return new ImageLoader();
        break;
      case LoaderType.gltfProject:
        return new GLTFProjectLoader();
        break;
      case LoaderType.gltfBin:
        return new GLTFBinLoader();
        break;
    }
    return loader;
  }
}