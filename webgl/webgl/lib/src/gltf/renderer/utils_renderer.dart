import 'package:webgl/src/introspection/introspection.dart';

@reflector
class GlobalState {

  int sRGBifAvailable; // else : webgl.RGBA

  dynamic hasLODExtension;
  dynamic hasDerivativesExtension;
  dynamic hasIndexUIntExtension;
}