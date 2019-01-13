import 'package:webgl/src/interaction/interactionnable.dart';

typedef Interactionable GetInteractionableItem();

class CustomInteractionable extends Interactionable{
  final GetInteractionableItem _item;

  CustomInteractionable(this._item);

  ///Mouse

  @override
  void onMouseDown(int screenX, int screenY) => _item()?.onMouseDown(screenX, screenY);

  @override
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton) => _item()?.onMouseMove(deltaX, deltaY, isMiddleMouseButton);

  @override
  void onMouseUp(int screenX, int screenY) => _item()?.onMouseUp(screenX, screenY);

  @override
  void onMouseWheel(num deltaY) => _item()?.onMouseWheel(deltaY);

  ///Touch

  @override
  void onTouchEnd(int screenX, int screenY) => _item()?.onTouchEnd(screenX, screenY);

  @override
  void onTouchMove(double deltaX, double deltaY, {num scaleChange}) => _item()?.onTouchMove(deltaX, deltaY);

  @override
  void onTouchStart(int screenX, int screenY) => _item()?.onTouchStart(screenX, screenY);

  ///Keyboard

  @override
  void onKeyPressed(List<bool> currentlyPressedKeys) => _item()?.onKeyPressed(currentlyPressedKeys);
}