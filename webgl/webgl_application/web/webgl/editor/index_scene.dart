import 'dart:async';
import 'dart:html' hide Node;
import 'package:webgl_application/src/application.dart';
import 'package:webgl_application/src/services/projects.dart';
import 'samples/projects.dart';
import 'projects/projects.dart';
import 'package:webgl/src/shaders/shader_source.dart';

Future main() async {

  await ShaderSource.loadShaders();

  bool useSample = false;
  if(useSample){
    ProjectService.loader = loadSampleProjects;
  }else{
    ProjectService.loader = loadBaseProjects;
  }

  ProjectService service = new ProjectService();
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  await Application.build(canvas)
  ..project = (await service.getProjects())[0]
  ..render();

//  fullNodeExemple();
}

//void fullNodeExemple() {
//  Element mainView = querySelector('#mainView');
//  new NodeEditor.init(parent: mainView);
//
//  NodeItem nodeInt01 = new NodeInt(2)..position = new Point<int>(20, 160);
//  NodeItem nodeInt02 = new NodeInt(3)..position = new Point<int>(20, 240);
//  NodeItem nodeInt03 = new NodeInt(4)..position = new Point<int>(420, 360);
//  NodeItem nodeDivide = new NodeDivide()..position = new Point<int>(250, 120);
//  NodeItem nodeAdd = new NodeAdd()..position = new Point<int>(480, 200);
//  NodeItem nodeMultiply = new NodeMultiply<int>()..position = new Point<int>(690, 280);
//  NodeItem nodeLog = new NodeLog()..position = new Point<int>(900, 300);
//
//  // Connect Nodes
//  nodeInt01.outputFields[0].connectTo(nodeDivide.inputFields[0]);
//  nodeInt02.outputFields[0].connectTo(nodeAdd.inputFields[1]);
//  nodeInt02.outputFields[0].connectTo(nodeDivide.inputFields[1]);
//  nodeDivide.outputFields[0].connectTo(nodeAdd.inputFields[0]);
//  nodeAdd.outputFields[0].connectTo(nodeMultiply.inputFields[0]);
//  nodeInt03.outputFields[0].connectTo(nodeMultiply.inputFields[1]);
//  nodeMultiply.outputFields[0].connectTo(nodeLog.inputFields[0]);
//}