import 'dart:html';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'packages/datgui/datgui.dart' as dat;
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/texture.dart';
import 'package:webgl/src/utils.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/utils_shader.dart';

Application application;

main() {
  CanvasElement canvas = querySelector('#glCanvas');
  canvas.width = document.body.clientWidth;
  canvas.height = document.body.clientHeight;

  //Application
  application = new Application(canvas);
  application.setupScene(setupScene);
  application.renderAnimation();
}

setupScene() async {
  application.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  //Material
  String vsSource = """
    attribute vec3 aVertexPosition;

    void main(void) {
        gl_Position = vec4(aVertexPosition, 1.0);
        gl_PointSize = 10.0;
    }
    """;

  String fsSource = """
    void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
    """;

  MaterialCustom materialCustom = new MaterialCustom(vsSource, fsSource);

  //Todo : initBuffers
  //Todo : setShaderAttributs
  //Todo : setShaderUniforms

  //Geom
  Mesh mesh = new Mesh()
  ..mode = GL.POINTS
  ..vertices = [
    -0.5,0.5,0.0,
    0.0,0.5,0.0,
    -0.25,0.25,0.0,
  ];

  application.meshes.add(mesh);

  // Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    //... animation here
    _lastTime = time;
  });
}

