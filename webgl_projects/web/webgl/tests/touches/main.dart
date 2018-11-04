import 'dart:html';
import 'package:webgl/src/interaction.dart';

TouchesManager touchesManager;
DivElement divInfos;

void main() {
  divInfos = querySelector('#infos') as DivElement;
  assert(divInfos != null || (throw "divInfos musn't be null !"));

  touchesManager = new TouchesManager();

  divInfos.onTouchStart.listen(onTouchStart);
  divInfos.onTouchEnd.listen(onTouchEnd);
  divInfos.onTouchEnter.listen(onTouchEnter);
  divInfos.onTouchLeave.listen(onTouchLeave);
  divInfos.onTouchMove.listen(onTouchMove);
  divInfos.onTouchCancel.listen(onTouchCancel);
}

void onTouchStart(TouchEvent event) {
  touchesManager.update(event);
  divInfos.innerHtml = touchesManager.getDebugInfos('onTouchStart');
}

void onTouchEnd(TouchEvent event) {
  touchesManager.update(event);
  divInfos.innerHtml = touchesManager.getDebugInfos('onTouchEnd');
}

void onTouchEnter(TouchEvent event) {
  touchesManager.update(event);
  divInfos.innerHtml = touchesManager.getDebugInfos('onTouchEnter');
}

void onTouchLeave(TouchEvent event) {
  touchesManager.update(event);
  divInfos.innerHtml = touchesManager.getDebugInfos('onTouchLeave');
}

void onTouchMove(TouchEvent event) {
  touchesManager.update(event);
  divInfos.innerHtml = touchesManager.getDebugInfos('onTouchMove');
}

void onTouchCancel(TouchEvent event) {
  touchesManager.update(event);
  divInfos.innerHtml = touchesManager.getDebugInfos('onTouchCancel');
}
