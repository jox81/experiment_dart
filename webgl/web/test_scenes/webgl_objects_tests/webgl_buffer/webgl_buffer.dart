import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.setup();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {
    TriangleModel triangleModel = new TriangleModel();
    print('triangleModel.mesh.vertices.length : ${triangleModel.mesh.vertices.length}');
    print('triangleModel.mesh.indices.length : ${triangleModel.mesh.indices.length}');

    WebGLBuffer vertexBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBuffer.webGLBuffer);
    gl.bufferData(
        BufferType.ARRAY_BUFFER, new Float32List.fromList(triangleModel.mesh.vertices), BufferUsageType.DYNAMIC_DRAW);

    WebGLBuffer indiceBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indiceBuffer.webGLBuffer);
    gl.bufferData(
        BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(triangleModel.mesh.indices), BufferUsageType.STATIC_DRAW);


    vertexBuffer.logBufferInfos();

  }

}
