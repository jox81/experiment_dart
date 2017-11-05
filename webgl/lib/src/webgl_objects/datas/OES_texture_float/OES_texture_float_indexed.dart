import 'package:webgl/src/webgl_objects/datas/webgl_enum_indexed.dart';
@MirrorsUsed(
    targets: const [
      OES_texture_float_InternalFormat,
    ],
    override: '*')
import 'dart:mirrors';

class OES_texture_float_InternalFormat extends TextureInternalFormat {
  static const int FLOAT = 0x1406;
  static const int HALF_FLOAT_OES = 0x8D61;
}