//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/camera/camera.dart';
//import 'package:webgl/src/context.dart';
//import 'package:webgl/src/light/light.dart';
//import 'dart:async';
//
//
//
//@MirrorsUsed(
//    targets: const [
//      SceneViewPBR,
//    ],
//    override: '*')
//import 'dart:mirrors';
//
//class SceneViewPBR extends SceneJox{
//
//  SceneViewPBR();
//
//  @override
//  Future setupScene() async {
//
//    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
//
//    //Cameras
//    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
//    CameraPerspective camera = new CameraPerspective(radians(45.0), 0.1, 1000.0)
//      ..targetPosition = new Vector3.zero()
//      ..translation = new Vector3(0.0, 10.0, 5.0);
//    Context.mainCamera = camera;
//
//    //Lights
//    PointLight pointlLight = new PointLight()
//      ..translation = new Vector3(10.0, 10.0, 10.0);
//    light = pointlLight;
//    lights.add(pointlLight);
//
//    //Materials
////  MaterialBase materialBase = new MaterialBase();
////  application.materials.add(materialBase);
//
//    MaterialPBR materialPBR = new MaterialPBR(pointlLight);
//    materials.add(materialPBR);
//
//    //Sphere
//    SphereMesh sphere = new SphereMesh(radius: 1.0, segmentV: 48, segmentH: 48);
//    sphere.matrix.translate(0.0, 0.0, 0.0);
//    sphere.material = materialPBR;
//    //sphere.mode = RenderingContext.LINES;
//    meshes.add(sphere);
//
//  }
//}