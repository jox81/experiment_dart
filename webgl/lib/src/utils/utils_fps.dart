import 'dart:html';

class UtilsFps {

  static DateTime timeNow = new DateTime.now();
  static DateTime timeLast = new DateTime.now();
  static int fps = 0;
  static double _computedFps = 0.0;

  ///Display the animation's FPS in the element.
  static void showFps(Element element) {

    if (element == null) return;

    timeNow = new DateTime.now();
    fps++;

    if (timeNow.millisecondsSinceEpoch - timeLast.millisecondsSinceEpoch >= 1000) {

      _computedFps = fps * 1000.0 / (timeNow.millisecondsSinceEpoch - timeLast.millisecondsSinceEpoch);

      element.text = "${_computedFps.toStringAsFixed(2)} fps";

      //reset
      timeLast = timeNow;
      fps = 0;
    }
  }
}