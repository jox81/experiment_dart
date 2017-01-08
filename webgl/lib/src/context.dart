import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context/context_attributs.dart';
import 'package:webgl/src/context/webgl_constants.dart';
import 'package:webgl/src/context/webgl_parameters.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';

WebGLRenderingContext gl;

class Context{

  static Camera _mainCamera;
  static Camera get mainCamera => _mainCamera;
  static set mainCamera(Camera value) {
    _mainCamera?.isActive = false;
    _mainCamera = value;
    _mainCamera.isActive = true;
  }

  static Matrix4 mvMatrix = new Matrix4.identity();

  static num get width => gl.drawingBufferWidth;
  static num get height => gl.drawingBufferHeight;

  static num get viewAspectRatio {
    if(gl != null) {
      return width / height;
    }
    return 1;
  }

  static RenderSetting _renderSetting;
  static RenderSetting get renderSettings {
    if(_renderSetting == null){
      _renderSetting = new RenderSetting();
    }
    return _renderSetting;
  }

  static const bool debugging = false;

  static void init(CanvasElement canvas, {bool enableExtensions:false, bool initConstant : false, bool logInfos : false}){
    gl = new WebGLRenderingContext.create(canvas);

    if(initConstant) {
      _initWebglConstants();
    }

    if(enableExtensions){
      renderSettings.enableExtensions(log: logInfos);
    }

    if(logInfos) {
      _logInfos();
    }
  }

  static void _logInfos() {
    Context.contextAttributs.logValues();
    _renderSetting.logSupportedExtensions();
    Context.webglConstants.logConstants();
    Context.webglConstants.logParameters();
    Context.webglParameters.logValues();

    Context.webglParameters.testGetParameter();
  }

  static void _initWebglConstants() {
    webglConstants.initWebglConstants();
  }

  static ContextAttributs get contextAttributs => ContextAttributs.instance();
  static WebglConstants get webglConstants => WebglConstants.instance();
  static WebglParameters get webglParameters => WebglParameters.instance();
}

class RenderSetting{
  RenderSetting();

  void showBackFace(bool visible){
    if(!visible) {
      gl.cullFace = true;
      gl.cullFaceMode = FacingType.BACK;
    }
  }

  void enableDepth(bool enable) {
    if(enable) {
      gl.clear([ClearBufferMask.DEPTH_BUFFER_BIT]);
      gl.depthTest = true;
    }
  }

  void logSupportedExtensions(){
    Utils.log('Supported extensions',(){
      for(String extension in gl.supportedExtensions){
        print(extension);
      }
    });
  }

  void enableExtensions({bool log : false}) {
    List<String> extensionNames = [
      'OES_texture_float',
      'OES_depth_texture',
      'WEBGL_depth_texture',
      'WEBKIT_WEBGL_depth_texture',
    ];

    Map extensions = new Map();
    for(String extensionName in extensionNames){
      var extension = gl.getExtension(extensionName);
      extensions[extensionName] = extension;
    }

    if(log) {
      Utils.log('Enabling extensions', () {
        extensions.forEach((key, value) {
          print('$key : ${(value != null) ? 'enabled' : 'not available'}');
        });
      });
    }
  }
}


