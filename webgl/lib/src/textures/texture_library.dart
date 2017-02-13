import 'dart:async';
import 'dart:html';
import 'package:webgl/src/introspection.dart';
@MirrorsUsed(
    targets: const [
      TextureLibrary,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class TextureLibrary extends IEditElement {

  static TextureLibrary _instance;
  TextureLibrary._init();

  static TextureLibrary get instance{
    if(_instance == null){
      _instance = new TextureLibrary._init();
    }
    return _instance;
  }

  List<ImageElement> get images => TextureUtils.loadImages();

}