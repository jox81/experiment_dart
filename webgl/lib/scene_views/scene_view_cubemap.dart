import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      SceneViewCubeMap,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewCubeMap extends Scene{

  SceneViewCubeMap();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    Camera camera = new Camera(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(0.0, 0.0, -5.0);
    Context.mainCamera = camera;

    List<ImageElement> cubeMapImages = await TextureUtils.loadCubeMapImages('pisa');
    WebGLTexture cubeMapTexture = TextureUtils.createCubeMapWithImages(cubeMapImages, flip:false);

    MaterialSkyBox materialSkyBox = new MaterialSkyBox();
    materialSkyBox.skyboxTexture = cubeMapTexture;

    SkyBoxModel skyBoxModel = new SkyBoxModel()
      ..material = materialSkyBox
      ..transform.scale(1.0);
    models.add(skyBoxModel);

    MaterialReflection materialReflection = new MaterialReflection()
      ..skyboxTexture = cubeMapTexture;

    GridModel grid = new GridModel();
    models.add(grid);

    SphereModel sphere = new SphereModel(radius: 5.0, segmentV: 32, segmentH: 32)
      ..transform.translate(0.0, 0.0, 0.0)
      ..transform.scale(0.1)
      ..material = materialReflection;
    models.add(sphere);

    QuadModel plane = new QuadModel()
      ..transform.translate(0.0, 0.0, 0.0)
      ..transform.scale(1.0)
      ..transform.rotateX(radians(-90.0))
      ..material = materialReflection;
    models.add(plane);

//    CubeModel cube = new CubeModel()
//      ..transform.translate(0.0, 0.0, 0.0)
//      ..transform.scale(1.0)
//      ..material = materialReflection;
//    models.add(cube);
  }
}
