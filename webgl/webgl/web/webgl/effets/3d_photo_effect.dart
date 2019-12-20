import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/webgl_objects/context.dart';

Future main() async {
  await init();
}

Future init() async {

  //> The shaders

  String vertexShaderSource = '''
    attribute vec2 pos;
    varying vec2 vpos;
    void main(){
        vpos = pos*-0.5 + vec2(0.5);
        gl_Position = vec4(pos, 0.0, 1.0);
    }
  ''';

  String fragmentShaderSource = '''
    precision highp float;
    uniform sampler2D img;
    uniform sampler2D depth;
    uniform vec2 mouse;
    varying vec2 vpos;
    void main(){
      float dp = -0.5 + texture2D(depth, vpos).x;
      gl_FragColor = texture2D(img, vpos + mouse * 0.2 * dp);
    }
  ''';

  //> The images

  ImageElement img = new ImageElement();
  img
    ..src = "https://i.postimg.cc/4dWr7TnV/avo.jpg"
    ..crossOrigin = "anonymous";

  ImageElement depth = new ImageElement();
  depth
    ..src = "https://i.postimg.cc/bv36L98j/avo-depth.jpg"
    ..crossOrigin = "anonymous";

  List<Future> futures = [img.onLoad.first, depth.onLoad.first];
  await Future.wait<dynamic>(futures);

  //> The Canvas

  CanvasElement canvas = document.createElement("canvas") as CanvasElement;
  canvas.height = img.height;
  canvas.width = img.width;
  canvas.style
    ..maxWidth = '100vw'
    ..maxHeight = '100vw'
    ..objectFit = 'contain';
  document.body.children.add(canvas);

  //> Webgl stuffs

  new Context(canvas, preserveDrawingBuffer: false);

  webgl.Buffer buffer = gl.createBuffer();
  gl.bindBuffer(webgl.WebGL.ARRAY_BUFFER, buffer);
  gl.bufferData(
      webgl.WebGL.ARRAY_BUFFER,
      new Float32List.fromList([
        //
        -1, -1, -1, 1,
        1, -1, 1, 1,
      ]),
      webgl.WebGL.STATIC_DRAW);

  gl.vertexAttribPointer(0, 2, webgl.WebGL.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(0);

  webgl.Program program = buildProgram(vertexShaderSource, fragmentShaderSource);
  gl.useProgram(program);

  void setTexture(dynamic im, String name, int num) {
    webgl.Texture texture = gl.createTexture();
    gl.activeTexture(webgl.WebGL.TEXTURE0 + num);
    gl.bindTexture(webgl.WebGL.TEXTURE_2D, texture);

    gl.texParameteri(webgl.WebGL.TEXTURE_2D, webgl.WebGL.TEXTURE_MIN_FILTER,
        webgl.WebGL.LINEAR);
    gl.texParameteri(webgl.WebGL.TEXTURE_2D, webgl.WebGL.TEXTURE_WRAP_S,
        webgl.WebGL.CLAMP_TO_EDGE);
    gl.texParameteri(webgl.WebGL.TEXTURE_2D, webgl.WebGL.TEXTURE_WRAP_T,
        webgl.WebGL.CLAMP_TO_EDGE);

    gl.texImage2D(webgl.WebGL.TEXTURE_2D, 0, webgl.WebGL.RGBA, webgl.WebGL.RGBA,
        webgl.WebGL.UNSIGNED_BYTE, im);
    gl.uniform1i(gl.getUniformLocation(program, name), num);
  }

  setTexture(img, "img", 0);
  setTexture(depth, "depth", 1);

  render({num time}) {
    gl.clearColor(0.25, 0.65, 1, 1);
    gl.clear(webgl.WebGL.COLOR_BUFFER_BIT);
    gl.drawArrays(webgl.WebGL.TRIANGLE_STRIP, 0, 4);

    window.requestAnimationFrame((num time) {
      render(time: time);
    });
  }

  render();

  webgl.UniformLocation mouseLoc = gl.getUniformLocation(program, "mouse");
  canvas.onMouseMove.listen((MouseEvent d) {
    List<double> mpos = [
      -0.5 + d.layer.x / canvas.width,
      0.5 - d.layer.y / canvas.width
    ];
    gl.uniform2fv(mouseLoc, new Float32List.fromList(mpos));
  });
}

webgl.Program buildProgram(String vertexShaderSource, String fragmentShaderSource) {

  webgl.Shader createShader(int type, String shaderSource) {
    webgl.Shader shader = gl.createShader(type);
    gl.shaderSource(shader, shaderSource);
    gl.compileShader(shader);

    bool success =
        gl.getShaderParameter(shader, webgl.WebGL.COMPILE_STATUS) as bool;
    if (!success) {
      print(gl.getShaderInfoLog(shader));
      gl.deleteShader(shader);
    }

    return shader;
  }

  webgl.Shader vertexShader =
      createShader(webgl.WebGL.VERTEX_SHADER, vertexShaderSource);
  webgl.Shader fragmentShader =
      createShader(webgl.WebGL.FRAGMENT_SHADER, fragmentShaderSource);

  webgl.Program createProgram(
      webgl.Shader vertexShader, webgl.Shader fragmentShader) {
    webgl.Program program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    bool success =
        gl.getProgramParameter(program, webgl.WebGL.LINK_STATUS) as bool;
    if (!success) {
      print(gl.getProgramInfoLog(program));
      gl.deleteProgram(program);
    }

    return program;
  }

  webgl.Program program = createProgram(vertexShader, fragmentShader);

  return program;
}
