import 'dart:async';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewFrameBuffer extends Scene{

  SceneViewFrameBuffer();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  setupUserInput() {

    updateUserInputFunction = (){
      interaction.update();
    };

    updateUserInputFunction();

  }

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    Camera camera = new Camera(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(50.0, 50.0, 50.0)
      ..cameraController = new CameraController();
    Context.mainCamera = camera;

    //
    DirectionalLight directionalLight = new DirectionalLight();
    light = directionalLight;

    //
    MaterialBaseTextureNormal materialBaseTextureNormal =
    new MaterialBaseTextureNormal()
      ..ambientColor = ambientLight.color
      ..directionalLight = directionalLight;
    materials.add(materialBaseTextureNormal);

    Texture newTexture = TextureUtils.createRenderedTexture();

    //Create Cube
    CubeModel cube = new CubeModel();
    cube.transform.translate(0.0, 0.0, 0.0);
    materialBaseTextureNormal.texture = newTexture;
    cube.material = materialBaseTextureNormal;
//  cube.material = materialBase;
    models.add(cube);

    // Animation
    num _lastTime = 0.0;

    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //Do Animation here

      //..
      //
      _lastTime = time;
    };


  }


}
