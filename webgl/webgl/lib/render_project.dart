import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/engine/engine_factory.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/project/project_factory.dart';

Future renderProjectFromPath(String projectPath, CanvasElement canvas) async {

  EngineFactory engineFactory = new EngineFactory();
  Engine engine = engineFactory.create(canvas, projectPath);

//  engine.assetsManager.onLoadProgress.listen((LoadProgressEvent loadprogressEvent){
//    print(loadprogressEvent);
//  });

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

  await engine.init(project);
  await engine.render();
}