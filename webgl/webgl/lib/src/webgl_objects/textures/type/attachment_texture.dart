import 'dart:html';
import 'package:webgl/src/webgl_objects/context.dart';
import 'dart:typed_data' as WebGlTypedData;

class TextureAttachment{

  TextureAttachment(this.textureAttachmentTarget);

  /// TextureAttachmentTarget textureAttachmentTarget;
  final int textureAttachmentTarget;

  // >>> Filling Texture

  /// TextureInternalFormat internalFormat
  /// TextureInternalFormat internalFormat2
  /// TexelDataType texelDataType
  void texImage2DWithWidthAndHeight(int mipMapLevel, int internalFormat, int width, int height, int border, int internalFormat2, int texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(internalFormat == internalFormat2);//in webgl1

    gl.texImage2D(textureAttachmentTarget, mipMapLevel, internalFormat, width, height, border, internalFormat2, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  /// TextureInternalFormat internalFormat2
  /// TexelDataType texelDataType
  void texImage2D(int mipMapLevel, int internalFormat, int internalFormat2, int texelDataType, dynamic pixels) {
    assert(internalFormat == internalFormat2);//in webgl1
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap || pixels == null); //? add is null
    gl.texImage2D(textureAttachmentTarget, mipMapLevel, internalFormat, internalFormat2, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  /// TexelDataType texelDataType
  void texSubImage2DWithWidthAndHeight(int mipMapLevel, int xOffset, int yOffset, int width, int height, int internalFormat, int texelDataType, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.texSubImage2D(textureAttachmentTarget, mipMapLevel, xOffset, yOffset, width, height, internalFormat, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  /// TexelDataType texelDataType
  void texSubImage2D(int mipMapLevel, int xOffset, int yOffset, int internalFormat, int texelDataType, WebGlTypedData.TypedData pixels) {
    assert(pixels is ImageData || pixels is ImageElement || pixels is CanvasElement || pixels is VideoElement || pixels is ImageBitmap); //? add is null
    gl.texSubImage2D(textureAttachmentTarget, mipMapLevel, xOffset, yOffset, internalFormat, texelDataType, pixels);
  }

  /// TextureInternalFormat internalFormat
  void copyTexImage2D(int mipMapLevel, int internalFormat,
      int x, int y, int width, int height, int border) {
    assert(width >= 0);
    assert(height >= 0);
    gl.copyTexImage2D(textureAttachmentTarget, mipMapLevel, internalFormat, x, y, width, height, border);
  }

  ///Copies pixels from the current WebGLFramebuffer into an existing 2D texture sub-image.
  void copyTexSubImage2D(int mipMapLevel, int xOffset, int yOffset,
      int x, int y, int width, int height) {
    assert(width >= 0);
    assert(height >= 0);
    gl.copyTexSubImage2D(textureAttachmentTarget, mipMapLevel, xOffset, yOffset, x, y, width, height);
  }
}