import 'dart:async';
import 'dart:html';
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

class SceneViewCubeMap extends Scene{

  SceneViewCubeMap();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    Camera camera = new Camera(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(5.0, 5.0, 5.0)
      ..cameraController = new CameraController();
    Context.mainCamera = camera;

    List<ImageElement> cubeMapImages = await TextureUtils.loadCubeMapImages('test');
    WebGLTexture cubeMapTexture = TextureUtils.createCubeMapFromElements(cubeMapImages, flip:false);

    MaterialSkyBox materialSkyBox = new MaterialSkyBox();
    materialSkyBox.skyboxTexture = cubeMapTexture;

    SkyBoxModel skyBoxModel = new SkyBoxModel()
    ..transform.scale(1.0);
    skyBoxModel.material = materialSkyBox;
    models.add(skyBoxModel);
  }

}
