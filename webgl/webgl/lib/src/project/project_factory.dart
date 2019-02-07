import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/project/project.dart';

class ProjectFactory{
  Future<Project> create(String projectPath) async{
    Project project;
    if(projectPath.endsWith('.gltf')){
      project = await Engine.assetManager.loadGLTFProject(projectPath, useWebPath : false);
      await project.debug(doProjectLog : false, isDebug:false);
    }
    return project;
  }
}