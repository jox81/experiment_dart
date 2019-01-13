abstract class Interactionable{
  //Mouse
  void onMouseDown(int screenX, int screenY);
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton);
  void onMouseUp(int screenX, int screenY);
  void onMouseWheel(num deltaY);

  //Touch
  void onTouchStart(int screenX, int screenY);
  void onTouchMove(double deltaX, double deltaY, {num scaleChange});
  void onTouchEnd(int screenX, int screenY);
}

typedef Interactionable GetInteractionableItem();

class CustomInteractionnable extends Interactionable{
  final GetInteractionableItem _item;

  CustomInteractionnable(this._item);

  @override
  void onMouseDown(int screenX, int screenY) => _item().onMouseDown(screenX, screenY);

  @override
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton) => _item().onMouseMove(deltaX, deltaY, isMiddleMouseButton);

  @override
  void onMouseUp(int screenX, int screenY) => _item().onMouseUp(screenX, screenY);

  @override
  void onMouseWheel(num deltaY) => _item().onMouseWheel(deltaY);

  @override
  void onTouchEnd(int screenX, int screenY) => _item().onTouchEnd(screenX, screenY);

  @override
  void onTouchMove(double deltaX, double deltaY, {num scaleChange}) => _item().onTouchMove(deltaX, deltaY);

  @override
  void onTouchStart(int screenX, int screenY) => _item().onTouchStart(screenX, screenY);
}