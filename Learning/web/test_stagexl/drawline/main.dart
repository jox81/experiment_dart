import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

void main() {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  GraphicsGradient gradient = new GraphicsGradient.linear(230, 0, 370, 200);
  gradient.addColorStop(0, 0xFF8ED6FF);
  gradient.addColorStop(1, 0xFF004CB3);


  var shape = new Shape();
  shape.graphics.beginPath();
  shape.graphics.moveTo(50, 50);
  shape.graphics.lineTo(250, 150);
  shape.graphics.lineTo(100, 150);
  shape.graphics.closePath();

  shape.graphics.strokeColor(Color.Blue, 5);
  shape.applyCache(0,0, 300, 300);
  stage.addChild(shape);

}
