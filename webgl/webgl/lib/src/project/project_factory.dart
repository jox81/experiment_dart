import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/project/project.dart';

class ProjectFactory{
  Future<Project> create(String projectPath) async{
    Project project;
    if(projectPath.endsWith('.gltf')){
      project = await new GLTFProjectLoader().load(projectPath, useWebPath:false);
      await project.debug(doProjectLog : false, isDebug:false);
    }
    return project;
  }
}