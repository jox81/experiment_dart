import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:typed_data';

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

  Mesh mesh = await experiment(Application.gl);
  application.materials.add(mesh.material);
  application.meshes.add(mesh);

  //Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    double animationStep = time - _lastTime;
    //... custom animation here
    mesh.animation(time);
    _lastTime = time;
  });
}

Mesh experiment(RenderingContext gl) {

  num shaderTime = 0.0;

  //Material
  String vShader = '''
    precision mediump float;

    attribute vec2 a_vertex;

    uniform float u_time;

    varying vec2 v_vertex;

    void main(void) {
      gl_PointSize = 2.;
      v_vertex = a_vertex;

      vec2 v = a_vertex*(mod(u_time+length(a_vertex),1.));
      float ct = (cos(v.x*30.+u_time*20.)+cos(v.y*30.+u_time*20.));
      v = mat2(sin(v.x*(10.+ct)),cos(v.x*(10.+ct)),cos(v.y*(10.+ct)),sin(v.y*(10.+ct)))*v;

      gl_Position=vec4(v,0.,1.);
    }
  ''';

  String fShader = '''
    precision mediump float;

    uniform float u_time;

    varying vec2 v_vertex;

    void main(void) {
      gl_FragColor = vec4(.3,.7,1.,.1);
    }
  ''';

  List<String> buffersNames = ['a_vertex'];

  MaterialCustom materialCustom = new MaterialCustom(vShader, fShader, buffersNames);
  materialCustom
    ..setShaderAttributsVariables = (Mesh mesh) {
      materialCustom.setShaderAttributWithName('a_vertex', mesh.vertices, mesh.vertexDimensions);
    }
    ..setShaderUniformsVariables = (Mesh mesh) {
      materialCustom.setShaderUniformWithName('u_time', shaderTime);
    };
  application.materials.add(materialCustom);


  Math.Random random = new Math.Random();

  int nump = 4800;
  Float32List pstart = new Float32List(nump*2);
  var i = pstart.length;
  while (i-- != 0) {
    pstart[i] = 0.0;
    while (pstart[i]*pstart[i] < .3) {
      pstart[i] = random.nextDouble()*2-1;
    }
  }
  Mesh mesh = new Mesh()
    ..mode = GL.POINTS
    ..vertexDimensions = 2
    ..vertices = pstart
    ..material = materialCustom;

  mesh.animation = (num time){
    shaderTime = time / 20000;
  };

  return mesh;
}
