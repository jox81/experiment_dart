import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

void main() {

  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;
  var stage = new Stage(canvas);
  stage.backgroundColor = Color.Gray;

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var juggler = renderLoop.juggler;

  Bitmap b = new Bitmap(new BitmapData(20,20, Color.Red));
  stage.addChild(b);

  var filter = new ColorMatrixFilter.adjust(brightness: 1.0);

  Translation translation = new Translation(0,1, 10, Transition.sine)
  ..onUpdate = (value){
    print(value);
    filter.adjustBrightness(value);
    b.removeCache();
    b.filters = [filter];
    b.applyCache(0,0, 20,20);
  };

  juggler.add(translation);

}
