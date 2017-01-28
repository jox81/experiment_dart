import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      SceneViewTexturing,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewTexturing extends Scene{

  SceneViewTexturing();

  @override
  Future setupScene() async {

//    bool useLighting = true;
//    Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
    Vector3 ambientColor = new Vector3.all(0.0);
    Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    Context.mainCamera = new
    Camera(radians(25.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 20.0, 20.0)
      ..cameraController = new CameraController();

    //Lights
    ambientLight.color.setFrom(ambientColor);

    DirectionalLight directionalLight = new DirectionalLight()
      ..color.setFrom(directionalColor)
      ..direction.setFrom(directionalColor);
    models.add(directionalLight);

    PointLight pointLight = new PointLight()
      ..color.setFrom(directionalColor)
      ..position = new Vector3(20.0, 20.0, 20.0);
    models.add(pointLight);

    //Materials
    WebGLTexture texture = await TextureUtils.getTextureFromFile("./images/crate.gif")
        ..textureWrapS = TextureWrapType.REPEAT
        ..textureWrapT = TextureWrapType.REPEAT
        ..textureMatrix = new Matrix4.columns(
          new Vector4(2.0,1.0,0.0,-2.0),
          new Vector4(0.0,2.0,0.0,-2.0),
          new Vector4(0.0,0.0,1.0,0.0),
          new Vector4(0.0,0.0,0.0,1.0),
          ).transposed();
    MaterialBaseTexture materialBaseTexture = new MaterialBaseTexture()
    ..texture = texture;
    materials.add(materialBaseTexture);

    //Meshes

    // create triangle
    TriangleModel triangle = new TriangleModel()
      ..name = 'triangle'
      ..transform.translate(-5.0, 0.0, 5.0)
      ..material = materialBaseTexture;
    models.add(triangle);

    // create square
    QuadModel square = new QuadModel()
      ..transform.translate(0.0, 0.0, 0.0)
      ..transform.rotateX(radians(90.0))
      ..material = materialBaseTexture;
    models.add(square);

    // create square
    QuadModel squareX = new QuadModel()
      ..transform.translate(0.0, 0.0, 5.0)
      ..material = materialBaseTexture;
    models.add(squareX);

    //create Pyramide
    PyramidModel pyramid = new PyramidModel()
      ..transform.translate(5.0, 1.0, 0.0)
      ..material = materialBaseTexture;
    models.add(pyramid);

    //Create Cube
    CubeModel cube = new CubeModel();
    cube.transform.translate(-5.0, 1.0, 0.0);
    cube.material = materialBaseTexture;
    models.add(cube);

    //Sphere
    SphereModel sphere = new SphereModel(radius: 1.5, segmentV: 48, segmentH: 48)
      ..transform.translate(0.0, 0.0, -5.0)
      ..material = materialBaseTexture;
    models.add(sphere);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //Do Animation here

      triangle.transform.rotateZ((radians(60.0) * animationStep) / 1000.0);
      squareX.transform.rotateX((radians(180.0) * animationStep) / 1000.0);
      pyramid..transform.rotateY((radians(90.0) * animationStep) / 1000.0);
      cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);

      //
      _lastTime = time;
    };

  }
}
