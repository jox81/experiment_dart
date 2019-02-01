import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/render_project.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/utils/utils_geometry.dart';
import 'projects/scene_view_cubemap.dart';

Future main() async {
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFEngine engine = new GLTFEngine(canvas);

  CubeMapProject cubeMapProject = await CubeMapProject.build();

  canvas.onMouseDown.listen((MouseEvent event){
    GLTFNode node = UtilsGeometry.findNodeFromMouseCoords(Engine.mainCamera, event.client.x, event.client.y, cubeMapProject.nodes);
    if(node != null) {
      cubeMapProject.nodeInteractionnable.node = node;
      print('node switch > ${node.name}');
      print('${event.client.x}, ${event.client.y}');
    }
  });

  await renderProject(engine, cubeMapProject);
}