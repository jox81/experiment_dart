import 'package:webgl/src/project/project.dart';

abstract class ProjectDebugger {
  Project debug(Project project, {bool doProjectLog, bool isDebug});
}