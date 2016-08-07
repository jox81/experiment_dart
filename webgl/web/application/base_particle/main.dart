import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/camera.dart';
import 'dart:typed_data';
import 'dart:async';

Application application;
RenderingContext gl;

main() {
  CanvasElement canvas = querySelector('#glCanvas');
  canvas.width = document.body.clientWidth;
  canvas.height = document.body.clientHeight;

  //Application
  application = new Application(canvas);
  gl = Application.gl;
  application.setupScene(setupScene);
  application.renderAnimation();
}

setupScene() async {

  application.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  gl.enable(GL.BLEND);
  gl.blendFunc(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA);
  gl.disable(GL.DEPTH_TEST);

  Math.Random random = new Math.Random();
  int nump = 48000;
  var pstart = new Float32List(nump*2);
  var i = pstart.length;
  while (i-- != 0) {
    pstart[i] = 0.0;
    while (pstart[i]*pstart[i] < .3) {
      pstart[i] = random.nextDouble()*2-1;
    }
  }

  var startTime = new DateTime.now();

  //Material
  String vShader = '''
    precision mediump float;

    attribute vec2 Vertex;

    uniform float T;

    varying vec2 V;

    void main(void) {
      gl_PointSize = 2.; V = Vertex;
      vec2 v = Vertex*(mod(T+length(Vertex),1.));
      float ct = (cos(v.x*30.+T*20.)+cos(v.y*30.+T*20.));
      v = mat2(sin(v.x*(10.+ct)),cos(v.x*(10.+ct)),cos(v.y*(10.+ct)),sin(v.y*(10.+ct)))*v;
      gl_Position=vec4(v,0.,1.);
    }
  ''';

  String fShader = '''
    precision mediump float;

    uniform float T;

    varying vec2 V;

    void main(void) {
      gl_FragColor = vec4(.7,.7,1.,.1);
    }
  ''';

  List<String> buffersNames = ['Vertex'];

  SetShaderVariablesFunction setShaderAttributsCustom = (Mesh mesh) {
    setShaderAttributWithName(
        'Vertex',   pstart  );
  };

  SetShaderVariablesFunction setShaderUniformsCustom = (Mesh mesh) {
    setShaderUniformWithName(
        "T", (Date.now()-startTime)/30000.0);
  };

  MaterialCustom materialCustom = new MaterialCustom(vShader, fShader, buffersNames, setShaderAttributsCustom, setShaderUniformsCustom);
  application.materials.add(materialCustom);

  Mesh mesh = new Mesh();
  mesh.material = materialCustom;
  
  //Animation
  num _lastTime = 0.0;

  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    //... animation here
    _lastTime = time;
  });
}
