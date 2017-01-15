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

class SceneViewVectors extends Scene{

  SceneViewVectors();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    Camera camera = new Camera(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(3.0, 10.0, 10.0)
      ..cameraController = new CameraController();
    Context.mainCamera = camera;

    AxisModel axis = new AxisModel();
    models.add(axis);

    GridModel grid = new GridModel();
    models.add(grid);

    VectorModel vectorModelA = new VectorModel(new Vector3(3.0,0.0,-3.0));
    models.add(vectorModelA);

    VectorModel vectorModelB = new VectorModel(new Vector3(-2.0,0.0,-2.0));
    models.add(vectorModelB);

    VectorModel vectorModelR = new VectorModel(vectorModelA.vec + vectorModelB.vec);
    models.add(vectorModelR);


    VectorModel vectorModelRMatrixView = new VectorModel(Context.mainCamera.perspectiveMatrix * new Vector3(1.0,1.0,1.0))
      ..material = new MaterialBaseColor(new Vector4(0.6,0.2,0.2,1.0));
    models.add(vectorModelRMatrixView);
    print(vectorModelRMatrixView.vec);

    VectorModel vectorModelvpMatrix = new VectorModel(Context.mainCamera.vpMatrix * Context.modelViewMatrix * new Vector3(1.0,1.0,1.0))
      ..material = new MaterialBaseColor(new Vector4(0.6,0.2,0.2,1.0));
    models.add(vectorModelvpMatrix);
    print(vectorModelvpMatrix.vec);
  }
}
