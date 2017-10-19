import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

// Uint8List = Byte
// Uint16List = SCALAR : int

class GLTFRenderer {
  GLTFProject gltf;
  GLTFScene get activeScene => gltf.scenes[0];
  List<GLTFNode> get nodes => activeScene.nodes;

  webgl.RenderingContext gl;

  String vsSource =
    '''
      attribute vec3 aPosition;

      uniform mat4 uModelMatrix;
      
      void main(void) {
          gl_Position = uModelMatrix * vec4(aPosition, 1.0);
      }
    ''';
  String fsSource =
    '''
      void main() {
        gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
      }
    ''';

  GLTFRenderer(this.gltf) {
    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) {
        throw "x";
      }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }
  }

  void draw() {
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT.index);

    webgl.Program program = buildProgram(vsSource, fsSource);
    gl.useProgram(program);

    for (var i = 0; i < nodes.length; ++i) {
      GLTFNode node = nodes[i];
      if(node.mesh != null){
        drawNodeMesh(program, node);
      }
    }
  }

  void drawNodeMesh(webgl.Program program, GLTFNode node) {
    GLTFMeshPrimitive primitive = node.mesh.primitives[0];

    //bind
    for (int i = 0; i < primitive.attributes.keys.length; i++) {
      bindVertices(program, primitive);
    }
    if(primitive.indices != null){
      bindIndices(primitive.indices);
    }

    //uniform
    Vector2 offsetScreen = new Vector2(-1.0, -0.5);//temp
    setUnifrom(program,'uModelMatrix',ShaderVariableType.FLOAT_MAT4,(node.matrix..translate(offsetScreen.x, offsetScreen.y)).storage);

    //draw
    if (primitive.indices == null) {
      String attributName = primitive.attributes.keys.toList()[0];//'POSITION'
      GLTFAccessor accessor = primitive.attributes[attributName];
      gl.drawArrays(primitive.mode.index, accessor.byteOffset, accessor.count);
    } else {
      GLTFAccessor accessor = primitive.indices;
      gl.drawElements(primitive.mode.index, accessor.count,
          accessor.componentType.index, accessor.byteOffset);
    }
  }

  void bindVertices(webgl.Program program, GLTFMeshPrimitive primitive) {

    String attributName = primitive.attributes.keys.toList()[0];
    GLTFAccessor accessor = primitive.attributes[attributName];

    GLTFBuffer bufferData = accessor.bufferView.buffer;
    Float32List verticesInfos = bufferData.data.buffer.asFloat32List(
        accessor.bufferView.byteOffset,
        accessor.bufferView.byteLength ~/ Float32List.BYTES_PER_ELEMENT);

    //>
    initBuffer(accessor.bufferView.usage, verticesInfos);

    //>
    setAttribut(
        program, attributName, accessor.count, accessor.componentType);
  }

  void bindIndices(GLTFAccessor accessorIndices) {
    Uint16List indices = accessorIndices.bufferView.buffer.data.buffer
        .asUint16List(accessorIndices.bufferView.byteOffset, accessorIndices.count);

    initBuffer(accessorIndices.bufferView.usage, indices);
  }

  webgl.Program buildProgram(String vsSource, String fsSource) {
    webgl.Program program = gl.createProgram();

    addShader(program, ShaderType.VERTEX_SHADER, vsSource);
    addShader(program, ShaderType.FRAGMENT_SHADER, fsSource);
    gl.linkProgram(program);
    if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS.index) ==
        null) {
      throw "Could not link the shader program!";
    }
    return program;
  }

  void addShader(webgl.Program program, ShaderType type, String source) {
    webgl.Shader shader = gl.createShader(type.index);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (gl.getShaderParameter(shader, ShaderParameters.COMPILE_STATUS.index) ==
        null) {
      throw "Could not compile $type shader:\n\n ${gl.getShaderInfoLog(shader)}";
    }
    gl.attachShader(program, shader);
  }

  /// [componentCount] => 3 (x, y, z)
  void setAttribut(webgl.Program program, String attributName, int componentCount,
      ShaderVariableType componentType) {
    int attributLocation = gl.getAttribLocation(program, 'a${capitalize(attributName)}');

    // turn on getting data out of a buffer for this attribute
    gl.enableVertexAttribArray(attributLocation);

    bool normalize = false;
    int offset = 0;         // start at the beginning of the buffer
    int stride = 0;         // how many bytes to move to the next vertex
                            // 0 = use the correct stride for type and numComponents

    gl.vertexAttribPointer(
        attributLocation, componentCount, componentType.index, normalize, stride, offset);
  }

  void setUnifrom(webgl.Program program,String unifromName, ShaderVariableType componentType, TypedData data){
    webgl.UniformLocation uniformLocation = gl.getUniformLocation(program, unifromName);

    bool transpose = false;

    switch(componentType){
      case ShaderVariableType.FLOAT_MAT4:
        gl.uniformMatrix4fv(uniformLocation, transpose, data);
        break;
      default:
        break;
    }
  }

  void initBuffer(BufferType bufferType, TypedData data) {
    webgl.Buffer buffer = gl.createBuffer();
    gl.bindBuffer(bufferType.index, buffer);
    gl.bufferData(bufferType.index, data, BufferUsageType.STATIC_DRAW.index);
  }

  void render({num time: 0.0}) {
    try {
      draw();
    } catch (ex) {
      print("Error: $ex");
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

  //text utils
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();
}
