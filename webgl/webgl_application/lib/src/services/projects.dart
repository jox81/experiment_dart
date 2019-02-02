import 'dart:async';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:angular/angular.dart';

// Todo (jpu) :
// - charger / décharger une scene proprement

typedef List<GLTFProject> ProjectLoader();

@Injectable()
class ProjectService {
  static Function loader;
  static List<GLTFProject> projects;
  Future<List<GLTFProject>> getProjects()  async {
   return (await loader()) as List<GLTFProject>;
  }
}
