import 'dart:html';
import 'dart:async';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:datgui/datgui.dart' as dat;
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/utils.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/primitives.dart';
import 'dart:collection';

Application application;
RenderingContext gl = Application.gl;

main() async {
  CanvasElement canvas = querySelector('#glCanvas');
  canvas.width = document.body.clientWidth;
  canvas.height = document.body.clientHeight;

  //Application
  application = new Application(canvas);
  await setupScene();
  application.renderAnimation();
}

Future setupScene() async {
  application.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  //Cameras
  // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
  Camera camera =
      new Camera(radians(37.0), application.viewAspectRatio, 0.1, 1000.0)
        ..aspectRatio = application.viewAspectRatio
        ..targetPosition = new Vector3.zero()
        ..position = new Vector3(50.0, 50.0, 50.0)
        ..cameraController = new CameraController();
  application.mainCamera = camera;

  //
  DirectionalLight directionalLight = new DirectionalLight();
  application.light = directionalLight;

  //
  MaterialBaseTextureNormal materialBaseTextureNormal =
      await MaterialBaseTextureNormal.create()
        ..ambientColor = application.ambientLight.color
        ..directionalLight = directionalLight;
  application.materials.add(materialBaseTextureNormal);

  Texture newTexture = TextureUtils.createRenderedTexture();

  //Create Cube
  Mesh cube = new Mesh.Cube();
  cube.transform.translate(0.0, 0.0, 0.0);
  materialBaseTextureNormal.texture = newTexture;
  cube.material = materialBaseTextureNormal;
//  cube.material = materialBase;
  application.meshes.add(cube);

  // Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    double animationStep = time - _lastTime;

    _lastTime = time;
  });
}

