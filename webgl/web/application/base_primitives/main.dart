import 'dart:html';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';

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
  MaterialPoint materialPoint = new MaterialPoint();
  application.materials.add(materialPoint);

  //Geom
  Mesh mesh = new Mesh()
  ..mode = GL.POINTS
  ..vertices = [
    0.0,0.0,0.0,
    0.0,1.0,0.0,
    1.0,0.0,0.0,
  ]
  ..material = materialPoint;

  application.meshes.add(mesh);

  //Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    //... animation here
    _lastTime = time;
  });
}

