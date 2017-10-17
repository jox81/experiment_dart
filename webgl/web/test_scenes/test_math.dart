import 'package:vector_math/vector_math.dart';

void main() {
  num viewportX = 0.0;
  num viewportY = 0.0;

  double viewportWidth = 100.0;
  double viewportHeight = viewportWidth;
  double aspectRatio = viewportWidth / viewportHeight;

  num pickX = 0.0;
  num pickY = 0.0;
  num pickZ = 0.0;

  double left = -viewportWidth * 0.5;
  double right = viewportWidth * 0.5;

  double bottom = -viewportWidth * 0.5;
  double top = viewportWidth * 0.5;

  double zNear = viewportWidth * 0.5;
  double zFar = -viewportWidth * 0.5;

  Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
  Vector3 cameraPosition = new Vector3(0.0, 0.0, viewportWidth * 0.5);
  Vector3 cameraFocusPosition = new Vector3(0.0, 0.0, 0.0);
  double fovYRadians = radians(45.0);

  Vector3 pickWorld = new Vector3.zero(); //Screen to world found point

//  Matrix4 orthoMatrix =
//      makeOrthographicMatrix(left, right, bottom, top, zNear, zFar);

//  Matrix4 viewMatrix =
//      makeViewMatrix(cameraPosition, cameraFocusPosition, upDirection);

//  Matrix4 perspectiveMatrix =
//      makePerspectiveMatrix(fovYRadians, aspectRatio, zNear, zFar);

  Matrix4 frustrumMatrix =
      makeFrustumMatrix(left, right, bottom, top, zNear, zFar);

  Matrix4 cameraMatrix = frustrumMatrix;

  for (num i = 0.0; i < 1.0; i += 0.1) {
    pickX = i * viewportWidth;
//    bool unprojected = unproject(cameraMatrix, viewportX, viewportWidth,
//        viewportY, viewportHeight, pickX, pickY, pickZ, pickWorld);
    print('$i : $pickWorld');
  }

  final c0 = new Vector3.zero();
  final c1 = new Vector3.zero();
  final c2 = new Vector3.zero();
  final c3 = new Vector3.zero();
  final c4 = new Vector3.zero();
  final c5 = new Vector3.zero();
  final c6 = new Vector3.zero();
  final c7 = new Vector3.zero();

  Frustum frustum =
  new Frustum.matrix(frustrumMatrix);
  frustum.calculateCorners(c0, c1, c2, c3, c4, c5, c6, c7);

}
