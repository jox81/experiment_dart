import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
@MirrorsUsed(
    targets: const [
      OES_texture_float_InternalFormat,
    ],
    override: '*')
import 'dart:mirrors';

class OES_texture_float_InternalFormat extends TextureInternalFormat {
  const OES_texture_float_InternalFormat(int index, String name)
      : super(index, name);
  static WebGLEnum getByIndex(int index) =>
      WebGLEnum.findTypeByIndex(OES_texture_float_InternalFormat, index);

  static const OES_texture_float_InternalFormat FLOAT =
  const OES_texture_float_InternalFormat(0x1406, 'FLOAT');

  static const OES_texture_float_InternalFormat HALF_FLOAT_OES =
  const OES_texture_float_InternalFormat(0x8D61, 'HALF_FLOAT_OES');
}