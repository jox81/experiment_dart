import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/light.dart';
import 'dart:async';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      SceneViewPBR,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewPBR extends Scene{

  SceneViewPBR();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    GLTFCameraPerspective camera = new GLTFCameraPerspective(radians(45.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(0.0, 10.0, 5.0);
    Context.mainCamera = camera;

    //Lights
    PointLight pointlLight = new PointLight()
      ..position = new Vector3(10.0, 10.0, 10.0);
    light = pointlLight;
    lights.add(pointlLight);

    //Materials
//  MaterialBase materialBase = new MaterialBase();
//  application.materials.add(materialBase);

    MaterialPBR materialPBR = new MaterialPBR(pointlLight);
    materials.add(materialPBR);

    //Sphere
    SphereModel sphere = new SphereModel(radius: 1.0, segmentV: 48, segmentH: 48);
    sphere.transform.translate(0.0, 0.0, 0.0);
    sphere.material = materialPBR;
    //sphere.mode = RenderingContext.LINES;
    models.add(sphere);

  }
}