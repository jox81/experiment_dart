import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      SceneViewWebGLEdit,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewWebGLEdit extends SceneJox{

  SceneViewWebGLEdit();

  void editVector3(){
    currentSelection = new CustomEditElement(new Vector3(1.0,2.0,3.0));
  }

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    CameraPerspective camera = new CameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(3.0, 10.0, 10.0);
    Context.mainCamera = camera;

    MultiLineMesh line = new MultiLineMesh([
      new Vector3.all(0.0),
      new Vector3(10.0, 0.0, 0.0),
      new Vector3(10.0, 0.0, 10.0),
      new Vector3(10.0, 10.0, 10.0),
    ]);
    meshes.add(line);

    TriangleMesh triangle = new TriangleMesh()
      ..name = 'triangle'
      ..material = new MaterialBase();
    meshes.add(triangle);

  }

}
