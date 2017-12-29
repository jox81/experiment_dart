import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/project.dart';
@MirrorsUsed(
    targets: const [
      SceneViewPrimitives,
    ],
    override: '*')
import 'dart:mirrors';

Project getPrimitivesProject(){
  Project project = new Project();

  Scene scene = new SceneViewPrimitives();
  project.addScene(scene);
  project.scene = scene;

  return project;
}

class SceneViewPrimitives extends Scene{

  CameraPerspective camera;
  CameraPerspective camera2;
  CameraPerspective camera3;

  int cameraIndex = 0;

  SceneViewPrimitives();

  //Todo : move to global
  void switchCamera(){
    cameraIndex += 1;
    cameraIndex %= cameras.length;
    Context.mainCamera = cameras[cameraIndex];
  }

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    camera = new CameraPerspective(radians(45.0), 5.0, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(5.0, 7.5, 10.0)
      ..showGizmo = true;
    cameras.add(camera);
    Context.mainCamera = camera;

    camera2 = new CameraPerspective(radians(37.0), 0.5, 10.0)
      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
      ..translation = new Vector3(2.0, 2.0, 2.0)
      ..showGizmo = true;
    cameras.add(camera2);

    camera3 = new CameraPerspective(radians(37.0), 1.0, 100.0)
      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
      ..translation = new Vector3(10.0, 10.0, 10.0)
      ..showGizmo = false;
    cameras.add(camera3);

    //Material
//    MaterialPoint materialPoint = new MaterialPoint(pointSize:5.0);
//    MaterialBase materialBase = new MaterialBase();
//
//    AxisMesh axis = new AxisMesh();
//    meshes.add(axis);

    PointMesh point = new PointMesh()
      ..name = 'point'
      ..translation = new Vector3(-5.0, 0.0, -3.0);
    meshes.add(point);

    TriangleMesh triangle = new TriangleMesh()
      ..name = 'triangle'
      ..translation = new Vector3(0.0, 0.0, -5.0);
    meshes.add(triangle);

    QuadMesh quad = new QuadMesh()
      ..name = "quad"
      ..translation = new Vector3(5.0, 0.0, -5.0);
    meshes.add(quad);

    PyramidMesh pyramid = new PyramidMesh()
      ..name = "pyramid"
      ..translation = new Vector3(-5.0, 0.0, 0.0);
    meshes.add(pyramid);

    CubeMesh cube = new CubeMesh()
      ..name = "cube"
      ..translation = new Vector3(0.0, 0.0, 0.0);
    meshes.add(cube);

    SphereMesh sphere = new SphereMesh()
      ..name = "sphere"
      ..translation = new Vector3(5.0, 0.0, 0.0);
    meshes.add(sphere);

  }
}
