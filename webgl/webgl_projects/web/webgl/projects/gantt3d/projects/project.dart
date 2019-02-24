import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/textures/text_style.dart';
import 'package:webgl/src/utils/utils_geometry.dart';

import 'package:webgl/gltf.dart';

class Gantt3dProject extends GLTFProject{

  Gantt3dProject._();
  static Future<Gantt3dProject> build() async {
    await AssetLibrary.loadDefault();
    return await new Gantt3dProject._().._setup();
  }

  Future _setup() async{

    NodeInteractionnable nodeInteractionnable = new NodeInteractionnable();
    nodeInteractionnable.controller = new Drive2dNodeController();
    addInteractable(nodeInteractionnable);

    canvas.onMouseDown.listen((MouseEvent event){
      GLTFNode node = UtilsGeometry.findNodeFromMouseCoords(Engine.mainCamera, event.client.x, event.client.y, nodes);
      if(node != null) {
        nodeInteractionnable.node = node;
        print('node switch > ${node.name}');
        print('${event.client.x}, ${event.client.y}');
      }
    });
    
    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.850, 0.847, 0.807, 1.0);

    //Cameras
    GLTFCameraPerspective camera = new
    GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);
    Engine.mainCamera = camera;

//    ProjectItem gameItem1 = new ProjectItem(scene)
//    ..devWeek = 14
//    ..testWeek = 4
//    ..draw(scene);

    ProjectContainer projectContainer = new ProjectContainer();

    RessourceItem jpu = new RessourceItem('jpu');
    RessourceItem jer = new RessourceItem('jer');

    ProductItem faelorn = new ProductItem('faelorn');
    ProductItem component = new ProductItem('component');

    TimeItem timeItem1 = new TimeItem(new DateTime(2019, 1, 1));
    TimeItem timeItem2 = new TimeItem(new DateTime(2019, 1, 2));
    TimeItem timeItem3 = new TimeItem(new DateTime(2019, 1, 3));
    TimeItem timeItem4 = new TimeItem(new DateTime(2019, 1, 4));
    TimeItem timeItem5 = new TimeItem(new DateTime(2019, 1, 5));

    projectContainer.addProjectItem(new ProjectItem(timeItem1, faelorn, jpu));
    projectContainer.addProjectItem(new ProjectItem(timeItem2, faelorn, jpu));
    projectContainer.addProjectItem(new ProjectItem(timeItem3, faelorn, jpu));
    projectContainer.addProjectItem(new ProjectItem(timeItem4, component, jpu));
    projectContainer.addProjectItem(new ProjectItem(timeItem5, component, jpu));

    projectContainer.addProjectItem(new ProjectItem(timeItem1, faelorn, jer));
    projectContainer.addProjectItem(new ProjectItem(timeItem2, component, jer));
    projectContainer.addProjectItem(new ProjectItem(timeItem3, component, jer));
    projectContainer.addProjectItem(new ProjectItem(timeItem4, component, jer));
    projectContainer.addProjectItem(new ProjectItem(timeItem5, faelorn, jer));

    projectContainer.draw(scene);
  }
}

class ProjectContainer{
  final Set<TimeItem> timeItems = new Set();
  final Set<ProductItem> productItems = new Set();
  final Set<RessourceItem> ressourceItems = new Set();

  final Set<ProjectItem> projectItems = new Set();

  ProjectContainer(){

  }

  void addTimeItem(TimeItem item){
    timeItems.add(item);
  }

  void addProductItem(ProductItem item){
    productItems.add(item);
  }

  void addRessourceItem(RessourceItem item){
    ressourceItems.add(item);
  }

  void addProjectItem(ProjectItem item){
    timeItems.add(item.timeItem);
    productItems.add(item.productItem);
    ressourceItems.add(item.ressourceItem);

    projectItems.add(item);
  }

  void draw(GLTFScene scene){
    _drawAxis(scene);
    projectItems.forEach((p){
      scene.addNode(p);

      double timeCoord = p.timeItem.date.day * 1.0;
      double productCoord = (productItems.toList(growable: false).indexOf(p.productItem) + 1) * 1.0;
      double ressourceCoord = (ressourceItems.toList(growable: false).indexOf(p.ressourceItem) + 1) * -1.0;

      p.scale = new Vector3.all(0.5);
      p.translate(new Vector3(timeCoord, productCoord, ressourceCoord));
    });
  }

  void _drawAxis(GLTFScene scene){
    for (int i = 1; i <= timeItems.length; ++i) {
      GLTFNode timeCoord = new GLTFNode.cube()
        ..material = new MaterialBaseColor(new Vector4(1.0, 0.0, 0.0, 1.0))
        ..matrix.translate( i * 1.0, 0.0, 0.0)
        ..matrix.scale(.1);
      scene.addNode(timeCoord);

      GLTFNode labelNode = new GLTFNode.label(timeItems.toList()[i-1].date.toString(), 128, 64, new TextStyle())
//        ..rotation = new Quaternion.axisAngle(new Vector3(0.0, 0.0, 1.0), radians(90))
//        ..rotation = new Quaternion.axisAngle(new Vector3(1.0, 0.0, 0.0), radians(90))
        ..rotation = new Quaternion.axisAngle(new Vector3(0.0, 1.0, 0.0), radians(-90))
        ..rotation = new Quaternion.axisAngle(new Vector3(1.0, 1.0, 0.0), radians(180))
        ..matrix.translate( i * 1.0, 0.0, 0.0);
      scene.addNode(labelNode);
    }
    for (int i = 1; i <= productItems.length; ++i) {
      GLTFNode productCoord = new GLTFNode.cube()
        ..material = new MaterialBaseColor(new Vector4(0.0, 1.0, 0.0, 1.0))
        ..matrix.translate( 0.0, i * 1.0, 0.0)
        ..matrix.scale(.1);
      scene.addNode(productCoord);
    }
    for (int i = 1; i <= ressourceItems.length; ++i) {
      GLTFNode ressourceCoord = new GLTFNode.cube()
        ..material = new MaterialBaseColor(new Vector4(0.0, 0.0, 1.0, 1.0))
        ..matrix.translate( 0.0, 0.0, i * -1.0)
        ..matrix.scale(.1);
      scene.addNode(ressourceCoord);
    }
  }
}

class ProjectItem extends GLTFNode{
  final TimeItem timeItem;
  final ProductItem productItem;
  final RessourceItem ressourceItem;

  String get name => 'ProjectItem : $productItem, $ressourceItem, $timeItem';

  ProjectItem(this.timeItem, this.productItem,this.ressourceItem ):super.cube(){
    material = new MaterialBaseColor(new Vector4(1.0, 1.0, 0.0, 1.0));
  }
}

class ProductItem{
  final String name;

  ProductItem(this.name);

  @override
  String toString() {
    return 'ProductItem{name: $name}';
  }
}

class TimeItem{
  final DateTime date;

  TimeItem(this.date);

  @override
  String toString() {
    return 'TimeItem{date: $date}';
  }
}

class RessourceItem{
  final String name;

  RessourceItem(this.name);

  @override
  String toString() {
    return 'RessourceItem{name: $name}';
  }
}
