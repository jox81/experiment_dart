import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:async';

void main() {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // draw a red circle
  var shape = new Shape();
  shape.graphics.rect(100, 100, 120, 60);
  shape.graphics.fillColor(Color.Red);
  stage.addChild(shape);


  Sprite paletDropZone = new Sprite();
  paletDropZone.addChild(new Bitmap(new BitmapData(100,100)));
  stage.addChild(paletDropZone);

  paletDropZone.onMouseClick.listen(dropPaletClickListener);

//
//  //Old Style
//  // shape.addEventListener("testClick", dropPaletClickListener);
//  shape.on("testClick").listen(dropPaletClickListener);
}



class DropPaletButton {
}

abstract class Clickable implements DisplayObject {
  Stream<Clickable> get onClick;
  set enabled(bool value);
}

void dropPaletClickListener(MouseEvent event) {
}
