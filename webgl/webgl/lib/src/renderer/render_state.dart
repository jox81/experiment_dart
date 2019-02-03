import 'package:webgl/src/introspection/introspection.dart';

@reflector
class RenderState {
  int reservedTextureUnits;//units frozen
  int sRGBifAvailable; // else : webgl.RGBA

  bool hasLODExtension;
  bool hasDerivativesExtension;
  bool hasIndexUIntExtension;
}