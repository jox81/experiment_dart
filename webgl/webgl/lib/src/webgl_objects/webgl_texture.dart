import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/textures/edit_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';

class WebGLTexture extends EditTexture {
  final WebGL.Texture webGLTexture;
  @override
  final int textureTarget;

  ImageElement _image;
  ImageElement get image => _image;
  set image(ImageElement value){
    _image = value;
//    if(value != null) {
//      _image.onClick.listen(null);
//      _image.onClick.listen((e) {
//
//      });
//    }
    _replaceImage(value);
  }

  /// The textureMatrix can be modifed to adjust mapping
  /// ex:
  ///   WebGLTexture texture;
  ///   //...
  ///   texture.textureMatrix = new Matrix4.columns(
  ///     new Vector4(2.0,1.0,0.0,-2.0),
  ///     new Vector4(0.0,2.0,0.0,-2.0),
  ///     new Vector4(0.0,0.0,1.0,0.0),
  ///     new Vector4(0.0,0.0,0.0,1.0),
  ///   ).transposed()
  Matrix4 textureMatrix = new Matrix4.identity();

  bool get isTexture => gl.isTexture(webGLTexture);

  WebGLTexture.texture2d() : this.textureTarget = TextureTarget.TEXTURE_2D, this.webGLTexture = gl.createTexture();
  WebGLTexture.textureCubeMap() : this.textureTarget = TextureTarget.TEXTURE_CUBE_MAP, this.webGLTexture = gl.createTexture();
  /// TextureTarget textureTarget
  WebGLTexture.fromWebGL(WebGL.Texture webGLTexture, int textureTarget): this.webGLTexture = webGLTexture, this.textureTarget = textureTarget;

  @override
  void delete() => gl.deleteTexture(webGLTexture);

  void logTextureInfos() {
    Debug.log("WebGLTexture Infos", () {

      print('editTextureUnit : ${editTextureUnit}');
      print('webGLTexture : ${webGLTexture}');
      print('textureTarget : ${textureTarget}');
      print('isTexture : ${isTexture}');

//      ActiveTexture.instance.activeUnit = editTextureUnit;
//
//      ActiveTexture.instance
//        ..texture2d.bind(this);

    });
  }

  void edit() {
    int lastTextureUnit = ActiveTexture.instance.activeTexture;

    ActiveTexture.instance.activeTexture = editTextureUnit;

    final v = textureTarget;
    switch(v){
      case TextureTarget.TEXTURE_2D:
        ActiveTexture.instance.texture2d.bind(this);
        break;
      case TextureTarget.TEXTURE_CUBE_MAP:
        ActiveTexture.instance.textureCubeMap.bind(this);
        break;
    }

    ActiveTexture.instance.activeTexture = lastTextureUnit;
  }

  void _replaceImage(ImageElement image) {
    int lastTextureUnit = ActiveTexture.instance.activeTexture;

    ActiveTexture.instance.activeTexture = editTextureUnit;

    GL.activeTexture.texture2d.bind(this);

    GL.activeTexture.texture2d.attachmentTexture2d.texImage2D(
        0,
        TextureInternalFormat.RGBA,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        image);

    GL.activeTexture.texture2d.unBind();

    ActiveTexture.instance.activeTexture = lastTextureUnit;
  }
}

