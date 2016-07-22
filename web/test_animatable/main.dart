import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

void main() {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var juggler = renderLoop.juggler;

  // draw a red circle
  var shape = new Shape();
  shape.graphics.rect(100, 100, 120, 60);
  shape.graphics.fillColor(Color.Red);
  stage.addChild(shape);

  var tweenBack;
  var tweenGO;

  tweenGO = new Tween(shape, 2.0, Transition.linear);
  tweenGO.animate.x.to(0);
  tweenGO.animate.y.to(200);
  tweenGO.onComplete = () => juggler.add(tweenBack);

  tweenBack = new Tween(shape, 2.0, Transition.linear);
  tweenBack.animate.x.to(0);
  tweenBack.animate.y.to(0);
  tweenBack.onComplete = () => juggler.add(tweenGO);

  juggler.add(tweenGO);

  Tween getTweenGo() {

  }
}
