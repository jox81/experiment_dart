//import 'package:vector_math/vector_math.dart';
//import '000.dart' as exp000;
//import '001.dart' as exp001;
//import '002.dart' as exp002;
//import '003.dart' as exp003;
//import '004.dart' as exp004;
//import 'dart:async';
//import 'package:webgl/src/gltf/camera/camera.dart';
//
//
//import 'package:webgl/src/webgl_objects/context.dart';
//@MirrorsUsed(
//    targets: const [
//      SceneViewExperiment,
//    ],
//    override: '*')
//import 'dart:mirrors';
//
//class SceneViewExperiment extends SceneJox{
//
//  SceneViewExperiment();
//
//  @override
//  Future setupScene() async {
//
//    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
//
//    CameraPerspective camera = new CameraPerspective(radians(45.0), 5.0, 1000.0)
//      ..targetPosition = new Vector3.zero()
//      ..translation = new Vector3(5.0, 7.5, 10.0)
//      ..showGizmo = true;
//    cameras.add(camera);
//    Engine.mainCamera = camera;
//
//    Mesh model = await exp004.experiment();
//    materials.add(model.material);
//    meshes.add(model);
//
//    //Animation
//    updateSceneFunction = () {
//      model.updateFunction();
//    };
//  }
//}
