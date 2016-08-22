import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:async';
import 'dart:math' hide Point;

Juggler juggler;
Stage stage;

Random random = new Random();

Item c1, c2;
DisplayObject movingObject;
DisplayObject targetObject;

/// The idea is to move an element from a container to another container by using local and global positions
Future main() async {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  juggler = renderLoop.juggler;

  Sprite topContainer = new Sprite();
  stage.addChild(topContainer);

  init(topContainer);

  await moveItem(movingObject, targetObject, topContainer);
}

void init(DisplayObjectContainer topContainer){
  c1 = new Item(itemWidth: 150, color: Color.Yellow)
    ..x = 200
    ..y = 200;
  c1.createInnerItem(itemWidth: 50, color: Color.Gray)
    ..x = 0
    ..y = 0;
  c1.innerItem.createInnerItem(itemWidth: 10, color: Color.Red)
    ..x = 0
    ..y = 0;
  topContainer.addChild(c1);

  movingObject = c1.innerItem.innerItem;

  num targetWidth = 10;
  targetObject = new Bitmap(new BitmapData(targetWidth,targetWidth, Color.Green))
    ..pivotX = targetWidth / 2
    ..pivotY = targetWidth / 2
    ..x = 500
    ..y = 500;
  topContainer.addChild(targetObject);
}

Future moveItem(DisplayObject startObject, DisplayObject targetObject, DisplayObjectContainer topContainer) async {
  await juggler.delay(2);

  Point startPositionGlobal;
  startPositionGlobal = startObject.parent.localToGlobal(new Point(startObject.x,startObject.y));
  print(startPositionGlobal);
  startObject.removeFromParent();

  Point destinationPositionGlobal;
  destinationPositionGlobal = targetObject.parent.localToGlobal(new Point(targetObject.x,targetObject.y));
  print(destinationPositionGlobal);

  Point pStart = topContainer.globalToLocal(startPositionGlobal);
  startObject
    ..x = pStart.x
    ..y = pStart.y;
  topContainer.addChild(startObject);

  Point pEnd =  topContainer.globalToLocal(destinationPositionGlobal);

  await moveTo(startObject, pEnd,topContainer);

  //Add to target
  Point destinationPositionLocal = targetObject.parent.globalToLocal(new Point(destinationPositionGlobal.x, destinationPositionGlobal.y));
  startObject
    ..x = destinationPositionLocal.x
    ..y = destinationPositionLocal.y;
  targetObject.parent.addChild(startObject);
}

Future moveTo(DisplayObject startObject, Point pEnd, DisplayObjectContainer topContainer) async {
  //Should be in topContainerSpace

  Completer completer = new Completer();

  Point pMiddle = new Point(500,100); //Absolute position

  AnimationChain ac = new AnimationChain()
    ..add(new Tween(startObject, .5)
      ..animate.x.to(pMiddle.x)
      ..animate.y.to(pMiddle.y))
    ..add(new Tween(startObject, 1)
      ..animate.x.to(pEnd.x)
      ..animate.y.to(pEnd.y))
    ..onComplete = () async {
      completer.complete();
    };
  juggler.add(ac);

  return completer.future;
}

class Item extends DisplayObjectContainer{
  Bitmap background;
  Item innerItem;

  Item({int itemWidth : 20, int color : Color.Blue}){
    background = new Bitmap(new BitmapData(itemWidth,itemWidth,color));
    addChild(background
      ..pivotX = itemWidth / 2
      ..pivotY = itemWidth / 2
    );
  }

  Item createInnerItem({int itemWidth : 20, int color : Color.Gray}){
    if(innerItem == null) {
      innerItem = new Item(itemWidth: itemWidth, color: color);
      addChild(innerItem);
    }else{
      throw new StateError("Item exist");
    }
    return innerItem;
  }
}