import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.test();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  void test(){
//    test01();
    test02();
  }

  void test01() {
    GLTFMesh triangleMesh = new GLTFMesh.triangle();
    print('triangleModel.mesh.vertices.length : ${triangleMesh.primitives[0].vertices.length}');
    print('triangleModel.mesh.indices.length : ${triangleMesh.primitives[0].indices.length}');

    WebGLBuffer vertexBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBuffer.webGLBuffer);
    gl.bufferData(
        BufferType.ARRAY_BUFFER, new Float32List.fromList(triangleMesh.primitives[0].vertices), BufferUsageType.DYNAMIC_DRAW);

    WebGLBuffer indiceBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indiceBuffer.webGLBuffer);
    gl.bufferData(
        BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(triangleMesh.primitives[0].indices), BufferUsageType.STATIC_DRAW);

    vertexBuffer.logBufferInfos();
  }

  // Todo (jpu) : test multiple buffer bind. Ther's not much info about bound buffers
  void test02() {
    GLTFMesh triangleMesh = new GLTFMesh.triangle();

    WebGLBuffer vertexBufferTriangle = new WebGLBuffer();
    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBufferTriangle.webGLBuffer);
    gl.bufferData(
        BufferType.ARRAY_BUFFER, new Float32List.fromList(triangleMesh.primitives[0].vertices), BufferUsageType.DYNAMIC_DRAW);

    WebGLBuffer indiceBufferTriangle = new WebGLBuffer();
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indiceBufferTriangle.webGLBuffer);
    gl.bufferData(
        BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(triangleMesh.primitives[0].indices), BufferUsageType.STATIC_DRAW);

    print('triangleModel.mesh.vertices.length : ${triangleMesh.primitives[0].vertices.length}');
    print('triangleModel.mesh.indices.length : ${triangleMesh.primitives[0].indices.length}');
    vertexBufferTriangle.logBufferInfos();

    //>

//    CubeModel cubeModel = new CubeModel();
//
//    WebGLBuffer vertexBufferCube = new WebGLBuffer();
//    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBufferCube.webGLBuffer);
//    gl.bufferData(
//        BufferType.ARRAY_BUFFER, new Float32List.fromList(triangleModel.mesh.vertices), BufferUsageType.DYNAMIC_DRAW);
//
//    WebGLBuffer indiceBufferCube = new WebGLBuffer();
//    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indiceBufferCube.webGLBuffer);
//    gl.bufferData(
//        BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(triangleModel.mesh.indices), BufferUsageType.STATIC_DRAW);
//
//    //>
//
//    print('///////////////////////');
//    print('cubeModel.mesh.vertices.length : ${cubeModel.mesh.vertices.length}');
//    print('cubeModel.mesh.indices.length : ${cubeModel.mesh.indices.length}');
//    vertexBufferCube.logBufferInfos();
  }

}
