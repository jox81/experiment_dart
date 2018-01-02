import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/context.dart';

import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      SceneViewCubeMap,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewCubeMap extends SceneJox{

  SceneViewCubeMap();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    CameraPerspective camera = new CameraPerspective(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(0.0, 5.0, -10.0);
    Context.mainCamera = camera;

    List<List<ImageElement>> cubeMapImages = await TextureUtils.loadCubeMapImages('pisa');
    WebGLTexture cubeMapTexture = TextureUtils.createCubeMapWithImages(cubeMapImages, flip:false);

    MaterialSkyBox materialSkyBox = new MaterialSkyBox();
    materialSkyBox.skyboxTexture = cubeMapTexture;

    SkyBoxMesh skyBoxMesh = new SkyBoxMesh()
      ..material = materialSkyBox
      ..matrix.scale(1.0);
    meshes.add(skyBoxMesh);


    Material material;

//    material = new MaterialPoint();
//    material = new MaterialBase();
    material = new MaterialReflection()..skyboxTexture = cubeMapTexture;

    GridMesh grid = new GridMesh();
    meshes.add(grid);

    SphereMesh sphere = new SphereMesh(radius: 1.0, segmentV: 32, segmentH: 32)
      ..matrix.translate(0.0, 0.0, 0.0)
      ..matrix.scale(1.0)
      ..material = material;
    meshes.add(sphere);

    QuadMesh plane = new QuadMesh()
      ..matrix.translate(2.0, 0.0, 0.0)
      ..matrix.scale(1.0)
      ..matrix.rotateX(radians(-90.0))
      ..material = material;
    meshes.add(plane);

    CubeMesh cube = new CubeMesh()
      ..matrix.translate(0.0, 1.0, 2.0)
      ..matrix.scale(1.0)
      ..material = material;
    meshes.add(cube);
  }
}
