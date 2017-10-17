import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GLTFRenderer{
  GLTFProject gltf;
  webgl.RenderingContext gl;

  String vsSource = "attribute vec3 POSITION;"+
      "void main() {"+
      "	gl_Position = vec4(POSITION, 1.0);"+
      "}";
  String fsSource = "void main() {"+
      "	gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);"+
      "}";

  GLTFRenderer(this.gltf){
    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) { throw "x"; }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }
  }

  void draw() {
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT);

    webgl.Program program = buildProgram(vsSource,fsSource);
    gl.useProgram(program);

    GLTFMeshPrimitive primitive = gltf.meshes[0].primitives[0];

    //>
    DrawMode drawMode = primitive.mode;
    String attributName = primitive.attributes.keys.toList()[0];
    GLTFAccessor accessor = primitive.attributes[attributName];

    //
    int elementsByVertices = accessor.components;
    GLTFBuffer buffer = accessor.bufferView.buffer;

    Float32List vertices = new Float32List.view(buffer.data.buffer);

    //>
    setupAttribut(program, attributName, elementsByVertices, accessor.componentType, vertices);
    gl.drawArrays(drawMode.index, accessor.byteOffset, accessor.count);
  }

  webgl.Program buildProgram(String vsSource, String fsSource) {
    webgl.Program program = gl.createProgram();

    addShader(program, 'vertex', vsSource);
    addShader(program, 'fragment', fsSource);
    gl.linkProgram(program);
    if (gl.getProgramParameter(program, webgl.RenderingContext.LINK_STATUS) == null) {
      throw "Could not link the shader program!";
    }
    return program;
  }

  void addShader(webgl.Program program, String type, String source) {
    webgl.Shader shader = gl.createShader((type == 'vertex') ?
    webgl.RenderingContext.VERTEX_SHADER : webgl.RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (gl.getShaderParameter(shader, webgl.RenderingContext.COMPILE_STATUS) == null) {
      throw "Could not compile " + type +
          " shader:\n\n"+gl.getShaderInfoLog(shader);
    }
    gl.attachShader(program, shader);
  }

  void setupAttribut(webgl.Program program, String attributName, int components, ShaderVariableType componentType, Float32List verticesComponentArray) {
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, verticesComponentArray,
        webgl.RenderingContext.STATIC_DRAW);
    int attrributLocation = gl.getAttribLocation(program, attributName);
    gl.enableVertexAttribArray(attrributLocation);
    gl.vertexAttribPointer(attrributLocation, components, componentType.index, false, 0, 0);
  }

  void render({num time : 0.0}) {
    try {
      draw();
    } catch (ex) {
      print("Error: $ex");
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }
}