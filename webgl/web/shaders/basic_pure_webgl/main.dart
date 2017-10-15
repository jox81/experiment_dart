import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:web_gl' as webgl;
GLTFProject gltf;

Future main() async {
  new Renderer()..render();
}

class Renderer{
  webgl.RenderingContext gl;

  Renderer();

  void draw() {
    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) { throw "x"; }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }
    gl.clearColor(0.8, 0.8, 0.8, 1);
    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT);

    webgl.Program prog = shaderProgram(gl,
        "attribute vec3 pos;"+
            "void main() {"+
            "	gl_Position = vec4(pos, 2.0);"+
            "}",
        "void main() {"+
            "	gl_FragColor = vec4(0.5, 0.5, 1.0, 1.0);"+
            "}"
    );
    gl.useProgram(prog);

    attributeSetFloats(gl, prog, "pos", 3, [
      -1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, -1.0, 0.0,
      1.0, 0.0, 0.0
    ]);

    gl.drawArrays(webgl.RenderingContext.TRIANGLE_STRIP, 0, 4);
  }

  webgl.Program shaderProgram(webgl.RenderingContext gl, String vs, String fs) {
    webgl.Program prog = gl.createProgram();

    addshader(prog, 'vertex', vs);
    addshader(prog, 'fragment', fs);
    gl.linkProgram(prog);
    if (gl.getProgramParameter(prog, webgl.RenderingContext.LINK_STATUS) == null) {
      throw "Could not link the shader program!";
    }
    return prog;
  }

  void addshader(webgl.Program prog, String type, String source) {
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


  void attributeSetFloats(webgl.RenderingContext gl, webgl.Program prog, String attr_name, int rsize, List<double> arr) {
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(arr),
        webgl.RenderingContext.STATIC_DRAW);
    int attr = gl.getAttribLocation(prog, attr_name);
    gl.enableVertexAttribArray(attr);
    gl.vertexAttribPointer(attr, rsize, webgl.RenderingContext.FLOAT, false, 0, 0);
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