import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class SceneViewFrameBuffer extends Scene{

  SceneViewFrameBuffer();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    Camera camera = new Camera(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(5.0, 5.0, 5.0)
      ..cameraController = new CameraController();
    Context.mainCamera = camera;

    //
    DirectionalLight directionalLight = new DirectionalLight();
    light = directionalLight;

    //
    WebGLTexture textureEmpty = TextureUtils.createRenderedTexture();
    WebGLTexture textureCrate =
    await TextureUtils.getTextureFromFile("./images/crate.gif");

    MaterialBaseTextureNormal materialBaseTextureNormal =
    new MaterialBaseTextureNormal()
      ..ambientColor = ambientLight.color
      ..directionalLight = directionalLight
      ..texture = textureEmpty;
    materials.add(materialBaseTextureNormal);

    MaterialBaseTextureNormal materialBaseTextureNormal2 =
    new MaterialBaseTextureNormal()
      ..ambientColor = ambientLight.color
      ..directionalLight = directionalLight
      ..texture = textureCrate;
    materials.add(materialBaseTextureNormal2);

    //Model
    QuadModel quad = new QuadModel()
      ..name = 'Quad'
      ..position = new Vector3(0.0, 0.0, 0.0)
      ..material = materialBaseTextureNormal2;
    models.add(quad);

    CubeModel cube = new CubeModel()
      ..name = "cube"
      ..position = new Vector3(2.0, 0.0, 0.0)
      ..material = materialBaseTextureNormal2;
    models.add(cube);

  }
}
