import 'dart:async';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewFrameBuffer extends Scene implements IEditScene{

  Map<String, EditableProperty> get properties =>{};

  final num viewAspectRatio;

  SceneViewFrameBuffer(Application application):this.viewAspectRatio = application.viewAspectRatio,super(application);

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
    Camera camera = await
    Camera.create(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(50.0, 50.0, 50.0)
      ..cameraController = new CameraController(gl.canvas);
    mainCamera = camera;

    //
    DirectionalLight directionalLight = new DirectionalLight();
    light = directionalLight;

    //
    MaterialBaseTextureNormal materialBaseTextureNormal =
    await MaterialBaseTextureNormal.create()
      ..ambientColor = ambientLight.color
      ..directionalLight = directionalLight;
    materials.add(materialBaseTextureNormal);

    Texture newTexture = TextureUtils.createRenderedTexture();

    //Create Cube
    Mesh cube = new Mesh.Cube();
    cube.transform.translate(0.0, 0.0, 0.0);
    materialBaseTextureNormal.texture = newTexture;
    cube.material = materialBaseTextureNormal;
//  cube.material = materialBase;
    meshes.add(cube);

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
