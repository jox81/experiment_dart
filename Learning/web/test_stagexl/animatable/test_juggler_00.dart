import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:async';
import 'dart:math';

Juggler juggler;
void main() {

  var canvas = html.querySelector('#stage');

  Stage stage = new Stage(canvas);

  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  juggler = renderLoop.juggler;

  Form form = new Form();
  form.trajectory = new Trajectory(stage.stageWidth, stage.stageHeight);
  stage.addChild(form);

  juggler.add(form);
}

class Coord{
  final num x;
  final num y;

  Coord(this.x, this.y);
}

class Trajectory{
  List<Coord> coords;

  Trajectory(int areaWith, int areaHeight) {
    createTrajectory(areaWith, areaHeight);
  }

  void createTrajectory(int areaWith, int areaHeight) {
    Random random = new Random();
    coords = new List();
    int coordCount = random.nextInt(100);
    for (int i = 0; i < 100; i++){
      coords.add(new Coord(random.nextDouble() * areaWith, random.nextDouble() * areaHeight));
    }
  }
}

class Form extends Sprite implements Animatable{

  Trajectory _trajectory;
  set trajectory(Trajectory trajectory){
    _trajectory = trajectory;
  }

  int get steps => _trajectory.coords.length;
  int _currentStep = 0;
  num _deltaTimeStep = .01;

  Form() {
    var rectangleForm = new Shape()
      ..graphics.rect(-20, -20, 40, 40)
      ..graphics.fillColor(Color.Red);
    var circleForm = new Shape()
      ..graphics.circle(0, 0, 10)
      ..graphics.fillColor(Color.Blue);
    addChild(rectangleForm);
    addChild(circleForm);
  }

  num _totalTime = 0.0;
  num _currentTime = 0.0;
  num _deltaTime = 0.0;
  Coord coord;

  Translation translation;
  @override
  bool advanceTime(num deltaTime) {
    _currentTime += deltaTime;

    //Todo : play animation trajectory
    print('_totalTime : ${_currentTime}');
    print('_trajectory.coords.length : ${_trajectory.coords.length}');
    print('div : ${_currentTime ~/ _deltaTimeStep}');

    _currentStep = _currentTime ~/ _deltaTimeStep;
    if(_currentStep > _trajectory.coords.length -1) return false;

    coord = _trajectory.coords[_currentStep];
    x = coord.x;
    y = coord.y;

    return true;
  }
}

/*
remarque:
mauvaise solution car des indices sont sautés. hors tous les indices doivent être joués
 */

