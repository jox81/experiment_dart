import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/renderer/render_state.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/project/project.dart';

abstract class Renderer{
  Context _context;
  CanvasElement get canvas => _context.canvas;

  Renderer(CanvasElement canvas) {
    _context = new Context(canvas);
  }

  RenderState get renderState => _renderState ??= _getRenderState();
  RenderState _renderState;
  RenderState _getRenderState() {
    //> Init extensions
    //This activate extensions
    bool hasSRGBExt = gl.getExtension('EXT_SRGB') != null;
    bool hasLODExtension = gl.getExtension('EXT_shader_texture_lod') != null;
    bool hasDerivativesExtension = gl.getExtension('OES_standard_derivatives') != null;
    bool hasIndexUIntExtension = gl.getExtension('OES_element_index_uint') != null;

    return new RenderState()
      ..hasLODExtension = hasLODExtension
      ..hasDerivativesExtension = hasDerivativesExtension
      ..hasIndexUIntExtension = hasIndexUIntExtension
      ..sRGBifAvailable =
      hasSRGBExt ? WebGL.EXTsRgb.SRGB_EXT : WebGL.WebGL.RGBA;
  }

  void init(Project project);
  void render({num currentTime: 0.0});
}