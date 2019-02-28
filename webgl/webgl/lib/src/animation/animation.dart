import 'dart:async';
import 'package:webgl/src/animation/animation_player.dart';
import 'package:webgl/src/animation/ease.dart';
import 'package:webgl/src/utils/utils_math.dart';

export 'package:webgl/src/animation/ease.dart';

class Animation {
  final num start;
  final num end;
  final num duration;
  final EaseFunction _easeFunction;

  StreamController _onStartController = new StreamController.broadcast();
  Stream get onStart => _onStartController.stream;

  StreamController<num> _onUpdateController = new StreamController<num>.broadcast();
  Stream<num> get onUpdate => _onUpdateController.stream;

  StreamController _onEndController = new StreamController.broadcast();
  Stream get onEnd => _onEndController.stream;

  num _startTime;
  num _currentTime;

  Completer _completer = new Completer();

  bool _isFirstTime = true;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Animation._(this.start, this.end, this.duration, this._easeFunction);

  Animation(num duration):this._(0.0, 1.0, duration, Ease.linear);

  Animation.startEnd(num start, num end, num duration, {EaseFunction ease : Ease.linear}):this._(start, end, duration, ease);

  Future play({num time}) async {
    if(_completer.isCompleted) return false;

    if(_isFirstTime){
      _isFirstTime = false;

      _onStartController.add(null);

      animationPlayer.add(this);
      return _completer.future;
    }

    _startTime ??= time;
    _currentTime = time - _startTime;

    if(_currentTime < duration * 1000){
      _isPlaying = true;
      _onUpdateController.add(UtilsMath.lerp(start, end, _easeFunction(_currentTime / (duration * 1000))));
    }else{
      _isPlaying = false;
      _completer.complete();
      _onEndController.add(null);
    }
  }
}