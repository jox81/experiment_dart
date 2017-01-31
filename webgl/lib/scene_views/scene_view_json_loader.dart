import 'dart:convert';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      SceneViewJsonLoader,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class SceneViewJsonLoader extends Scene{

  SceneViewJsonLoader();

  @override
  Future setupScene() async {
    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    Context.mainCamera = new
    Camera(radians(25.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0, 10.0, 10.0)
      ..cameraController = new CameraController();

    //
//    Map susanJson = await Utils.loadJSONResource('./objects/susan/susan.json');
//    MaterialBaseTexture susanMaterialBaseTexture = new MaterialBaseTexture()
//      ..texture = await TextureUtils.getTextureFromFile(
//          './objects/susan/susan_texture.png');
//    JsonObject jsonModel = new JsonObject(susanJson)
//      ..transform.translate(0.0, 0.0, 0.0)
//      ..transform.rotateX(radians(-90.0))
//      ..material = susanMaterialBaseTexture;
//    models.add(jsonModel);

//    Map testJson = await Utils.loadJSONResource('./objects/test.json');
//    String result = JSON.encode(testJson);
//    print(result);

    Map testJson = await Utils.loadJSONResource('./objects/test.json');
    bool test = testJson[models][1].type == "QuadModel";

  }
}
