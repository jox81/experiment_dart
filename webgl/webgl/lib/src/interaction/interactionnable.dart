/// Un [Interactionable] permet de gèrer un ensemble d'elements avec lesquels l'tuilisateur peut interagir.
/// Le comportement qu'aura certaines interactions y est défini
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

  //KeyBoard
  void onKeyPressed(List<bool> currentlyPressedKeys);
}
