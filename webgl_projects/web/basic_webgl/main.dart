import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'dart:developer';
import 'package:logging/logging.dart';

  Logger devLog;
Future main() async {

  devLog = new Logger('dev');
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    log('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  new Renderer()..render();
}

class Renderer{
  webgl.RenderingContext gl;

  List<double> vertices;
  int elementsByVertices;

  String fsSource = '''
    void main() {
      gl_FragColor = vec4(0.5, 0.5, 1.0, 1.0);
    }
  ''';

  String vsSource = '''
    attribute vec3 pos;

    void main() {
      gl_Position = vec4(pos, 3.0);
    }
  ''';

  webgl.Program program;

  Renderer(){
    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) { throw "x"; }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }

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

    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT);
    gl.drawArrays(webgl.RenderingContext.TRIANGLE_STRIP, 0, vertices.length ~/ elementsByVertices);


  }

  webgl.Program buildProgram(String vs, String fs) {
    webgl.Program prog = gl.createProgram();

    devLog.fine('test');
    UserTag customTag = new UserTag('MyTag');
    // Save the previous tag when installing the custom tag.
    var previousTag = customTag.makeCurrent();

    addShader(prog, 'vertex', vs);
    addShader(prog, 'fragment', fs);

    // Restore the previous tag.
    previousTag.makeCurrent();

    gl.linkProgram(prog);
    if (gl.getProgramParameter(prog, webgl.RenderingContext.LINK_STATUS) == null) {
      throw "Could not link the shader program!";
    }
    return prog;
  }

  void addShader(webgl.Program prog, String type, String source) {
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
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(arr),
        webgl.RenderingContext.STATIC_DRAW);
    int attr = gl.getAttribLocation(prog, attributName);
    gl.enableVertexAttribArray(attr);
    gl.vertexAttribPointer(attr, rsize, webgl.RenderingContext.FLOAT, false, 0, 0);
  }

  void render({num time : 0.0}) {
      draw();
    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }
}