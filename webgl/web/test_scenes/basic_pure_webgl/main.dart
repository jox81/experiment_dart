import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

import 'package:webgl/src/context.dart' as Context;
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/utils/utils_debug.dart' as debugLog;

Future main() async {
  debugLog.isDebug = false;
  new Renderer()..render();
}

class Renderer{
  webgl.RenderingContext gl;
  Interaction interaction;

  List<double> vertices;
  int elementsByVertices;
//
//  String fsSource = '''
//    void main() {
//      gl_FragColor = vec4(0.5, 0.5, 1.0, 1.0);
//    }
//    ''';

  String vsSource = '''
    attribute vec3 pos;

    void main() {
      gl_Position = vec4(pos, 3.0);
    }
  ''';
  String fsSource = '''
    void main() {
      gl_FragColor = vec4(0.5, 0.5, 1.0, 1.0);
    }
  ''';

  webgl.Program program;

  Renderer(){
    //debugLog.logCurrentFunction();
    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) { throw "x"; }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }

    //>
//    Context.gl = gl;
//    interaction = new Interaction();

    //>

    gl.clearColor(0.8, 0.8, 0.8, 1);

    program = buildProgram(vsSource,fsSource);
    gl.useProgram(program);

    elementsByVertices = 3;
    vertices = [
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0
    ];

    setupAttribut(program, "pos", elementsByVertices , vertices);
  }

  void draw() {
    //debugLog.logCurrentFunction();
    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT);

    gl.drawArrays(webgl.RenderingContext.TRIANGLE_STRIP, 0, vertices.length ~/ elementsByVertices);
  }

  webgl.Program buildProgram(String vs, String fs) {
    //debugLog.logCurrentFunction();
    webgl.Program prog = gl.createProgram();

    addShader(prog, 'vertex', vs);
    addShader(prog, 'fragment', fs);
    gl.linkProgram(prog);
    if (gl.getProgramParameter(prog, webgl.RenderingContext.LINK_STATUS) == null) {
      throw "Could not link the shader program!";
    }
    return prog;
  }

  void addShader(webgl.Program prog, String type, String source) {
    //debugLog.logCurrentFunction();
    webgl.Shader s = gl.createShader((type == 'vertex') ?
    webgl.RenderingContext.VERTEX_SHADER : webgl.RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(s, source);
    gl.compileShader(s);
    if (gl.getShaderParameter(s, webgl.RenderingContext.COMPILE_STATUS) == null) {
      throw "Could not compile " + type +
          " shader:\n\n"+gl.getShaderInfoLog(s);
    }
    gl.attachShader(prog, s);
  }

  void setupAttribut(webgl.Program prog, String attributName, int rsize, List<double> arr) {
    //debugLog.logCurrentFunction();
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(arr),
        webgl.RenderingContext.STATIC_DRAW);
    int attr = gl.getAttribLocation(prog, attributName);
    gl.enableVertexAttribArray(attr);
    gl.vertexAttribPointer(attr, rsize, webgl.RenderingContext.FLOAT, false, 0, 0);
  }

  void render({num time : 0.0}) {
//    debugLog.logCurrentFunction(
//        '\n------------------------------------------------');

      draw();
//    try {
////      update();
//    } catch (ex) {
//      print("Error: $ex");
//    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

  void update() {
    //debugLog.logCurrentFunction();
    interaction?.update();
  }
}
