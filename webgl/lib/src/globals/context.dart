import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';

RenderingContext gl;
Camera mainCamera;
Matrix4 mvMatrix = new Matrix4.identity();