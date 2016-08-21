import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

void main() {

  var canvas = html.querySelector('#stage');

  Stage stage = new Stage(canvas);

  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  Form form = new Form();
  stage.addChild(form);
}

class Form extends Sprite {

  Form() {
    Bitmap base = new Bitmap(new BitmapData(100,100, 0xFF000000));
    addChild(base);

//    Shape circleForm = new Shape()
//      ..graphics.circle(0, 0, 10)
//      ..graphics.fillColor(Color.Blue);
//    addChild(circleForm);
  }

}



