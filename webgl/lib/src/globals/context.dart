import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';

RenderingContext gl;

class Context{

  static Camera mainCamera;
  static Matrix4 mvMatrix = new Matrix4.identity();

  static num get width => gl.drawingBufferWidth;
  static num get height => gl.drawingBufferHeight;

  static num get viewAspectRatio {
    if(gl != null) {
      return width / height;
    }
    return 1;
  }
}

