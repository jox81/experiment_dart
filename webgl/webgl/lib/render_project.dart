import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl/src/camera/controller/perspective_camera/perspective_camera_controller_types/combined_perspective_camera_controller.dart';
import 'package:webgl/src/engine/engine_factory.dart';
import 'package:webgl/src/interaction/custom_interactionable.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/project/project_factory.dart';

Future renderProjectFromPath(String projectPath, CanvasElement canvas) async {

  EngineFactory engineFactory = new EngineFactory();
  Engine engine = engineFactory.create(canvas, projectPath);

  Engine.assetsManager.onLoadProgress.listen((LoadProgressEvent loadprogressEvent){
    print("name : ${loadprogressEvent.name}");
    print("lengthComputable : ${loadprogressEvent.progressEvent.lengthComputable}");
    print("loaded : ${loadprogressEvent.progressEvent.loaded} octets");
    print("total : ${loadprogressEvent.progressEvent.total} octets");
    print("% : ${loadprogressEvent.progressEvent.loaded / loadprogressEvent.progressEvent.total * 100}");
  });

  ProjectFactory projectFactory = new ProjectFactory();
  Project project = await projectFactory.create(projectPath);

  renderProject(engine, project);
}

Future renderProject(Engine engine, Project project) async {
  Element elementFPSText = querySelector("#fps");
  if(elementFPSText != null) elementFPSText.style.display = 'block';
  engine.onRender.listen((num value){
    elementFPSText.text = "${value.toStringAsFixed(2)} fps";
  });

  await engine.render(project);
}