import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:async';
import 'dart:math' hide Point;

Juggler juggler;
Stage stage;
Random random = new Random();

/// The idea is to move an element from a container to another container by using local and global positions
Future main() async {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  juggler = renderLoop.juggler;

  Item c1 = new Item(itemWidth: 150, color: Color.Yellow)
  ..x = 100
  ..y = 150;
  c1.createItem(itemWidth: 50, posX: 30, posY: -20, color: Color.Gray);
  c1.item.createItem(itemWidth: 10, posX : 0, posY: 15, color: Color.Red);
  stage.addChild(c1);

  Item c2 = new Item(itemWidth: 200, color: Color.YellowGreen)
    ..x = 350
    ..y = 250;
  c2.createItem(itemWidth: 70, posX: -20, posY: 30, color: Color.Gold);
  c2.item.createItem(itemWidth: 10, posX : -10, posY: -25, color: Color.Green);
  stage.addChild(c2);

  DisplayObject movingObject = c1.item.item;
  DisplayObject targetObject = c2.item.item;

  //
  await juggler.delay(2);
  await moveItem(movingObject, targetObject);

  juggler.addChain([
    //check if item is correctly added
    new Tween(c2, 0.5, Transition.sine)
    ..delay = 1
    ..animate.y.by(20),

    //check if item is still accessible
    new Tween(movingObject, 0.5, Transition.sine)
      ..delay = 1
      ..animate.y.by(20)
  ]);

}

Future moveItem(DisplayObject startObject, DisplayObject targetObject) async {
  Point startPositionGlobal = startObject.parent.localToGlobal(new Point(startObject.x, startObject.y));
  Point destinationPositionGlobal = targetObject.parent.localToGlobal(new Point(targetObject.x, targetObject.y));

  startObject.parent.removeChild(startObject);

  await moveItemGlobal(startObject, startPositionGlobal, destinationPositionGlobal);

  Point destinationPositionLocal = targetObject.parent.globalToLocal(new Point(startObject.x, startObject.y));
  startObject
    ..x = destinationPositionLocal.x
    ..y = destinationPositionLocal.y;
  targetObject.parent.addChild(startObject);
}

Future moveItemGlobal(DisplayObject movingObject, Point startPositionGlobal, Point destinationPositionGlobal) async {
  //
  Completer completer = new Completer();

  movingObject
      ..x = startPositionGlobal.x
      ..y = startPositionGlobal.y;
  stage.addChild(movingObject);

  juggler.addTween(movingObject, 2)
  ..animate.x.to(destinationPositionGlobal.x)
  ..animate.y.to(destinationPositionGlobal.y)
  ..onComplete = ()async {
    completer.complete();
  };

  return completer.future;
}

class Item extends DisplayObjectContainer{
  Bitmap background;
  Item item;

  Item({int itemWidth : 20, int color : Color.Blue}){
    background = new Bitmap(new BitmapData(itemWidth,itemWidth,color));
    addChild(background
      ..pivotX = itemWidth / 2
      ..pivotY = itemWidth / 2
    );
  }

  void createItem({int posX : 0, int posY : 0, int itemWidth : 20, int color : Color.Gray}){
    if(item == null) {
      item = new Item(itemWidth: itemWidth, color: color)
        ..x = posX
        ..y = posY;
      addChild(item);
    }else{
      throw new StateError("Item exist");
    }
  }
}