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
