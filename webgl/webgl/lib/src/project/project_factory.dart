import 'package:webgl/src/gltf/creation.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/project/project.dart';
import 'package:webgl/src/project/project_debugger.dart';

class ProjectFactory{
  Future<Project> create(String projectPath) async{
    Project project;
    if(projectPath.endsWith('.gltf')){
      project = await GLTFCreation.loadGLTFProject(projectPath, useWebPath : false);

      ProjectDebugger projectDebugger = new GLTFProjectDebugger();
      await projectDebugger.debug(project, doProjectLog : false, isDebug:false);
    }
    return project;
  }
}