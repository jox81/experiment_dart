import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      SceneViewTexturing,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewTexturing extends SceneJox{

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
    CameraPerspective(radians(25.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

    //Lights
    ambientLight.color.setFrom(ambientColor);

    DirectionalLight directionalLight = new DirectionalLight()
      ..color.setFrom(directionalColor)
      ..direction.setFrom(directionalColor);
    lights.add(directionalLight);

    PointLight pointLight = new PointLight()
      ..color.setFrom(directionalColor)
      ..translation = new Vector3(20.0, 20.0, 20.0);
    lights.add(pointLight);

    //Materials
    ImageElement imageCrate = await TextureUtils.loadImage("./images/crate.gif");

    WebGLTexture texture = await TextureUtils.createTexture2DFromImage(imageCrate)
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
    TriangleMesh triangle = new TriangleMesh()
      ..name = 'triangle'
      ..matrix.translate(-5.0, 0.0, 5.0)
      ..material = materialBaseTexture;
    meshes.add(triangle);

    // create square
    QuadMesh square = new QuadMesh()
      ..matrix.translate(0.0, 0.0, 0.0)
      ..matrix.rotateX(radians(90.0))
      ..material = materialBaseTexture;
    meshes.add(square);

    // create square
    QuadMesh squareX = new QuadMesh()
      ..matrix.translate(0.0, 0.0, 5.0)
      ..material = materialBaseTexture;
    meshes.add(squareX);

    //create Pyramide
    PyramidMesh pyramid = new PyramidMesh()
      ..matrix.translate(5.0, 1.0, 0.0)
      ..material = materialBaseTexture;
    meshes.add(pyramid);

    //Create Cube
    CubeMesh cube = new CubeMesh();
    cube.matrix.translate(-5.0, 1.0, 0.0);
    cube.material = materialBaseTexture;
    meshes.add(cube);

    //Sphere
    SphereMesh sphere = new SphereMesh(radius: 1.5, segmentV: 48, segmentH: 48)
      ..matrix.translate(0.0, 0.0, -5.0)
      ..material = materialBaseTexture;
    meshes.add(sphere);

//    ImageElement imageFabricBump = await TextureUtils.loadImage("./images/fabric_bump.jpg");
//    texture.image = imageFabricBump;


    //Animation
    updateSceneFunction = () {
      triangle.matrix.rotateZ((radians(60.0) * Time.deltaTime) / 1000.0);
      squareX.matrix.rotateX((radians(180.0) * Time.deltaTime) / 1000.0);
      pyramid..matrix.rotateY((radians(90.0) * Time.deltaTime) / 1000.0);
      cube.matrix.rotateY((radians(45.0) * Time.deltaTime) / 1000.0);
    };

  }
}
