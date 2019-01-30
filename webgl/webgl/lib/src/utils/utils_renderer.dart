import 'package:webgl/src/introspection/introspection.dart';

@reflector
class GlobalState {
  int reservedTextureUnits;//units frozen
  int sRGBifAvailable; // else : webgl.RGBA

  bool hasLODExtension;
  bool hasDerivativesExtension;
  bool hasIndexUIntExtension;
}