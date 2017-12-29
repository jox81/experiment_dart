import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/material/material.dart';
import 'package:webgl/src/material/materials.dart';

class UtilsGeometry{

  /// Permet de retorver un point en WORLD depuis un point en SREEN
  /// il faut concidérer l'origine de screen en haut à gauche, y pointant vers le bas
  /// ! les coordonnées screen webgl sont en y inversé
  ///Les coordonnées x et y se trouvent sur le plan near de la camera
  ///Le pick Z indique la profondeur à laquelle il faut place le point dé-projeté, z ayant un range de 0.0 à 1.0
  ///En webgl, l'origine en screen se trouve en bas à gauche du plan near
  ///En webgl, l'axe y pointant vers le haut, x vers la droite
  static bool unProjectScreenPoint(CameraPerspective camera, Vector3 pickWorld, num screenX, num screenY, {num pickZ:0.0}) {
    num pickX = screenX;
    num pickY = Context.height - screenY;

    bool unProjected = unproject(camera.viewProjectionMatrix, 0, Context.width,
        0, Context.height, pickX, pickY, pickZ, pickWorld);

    return unProjected;
  }

  static bool pickRayFromScreenPoint(CameraPerspective camera, Vector3 outRayNear,
      Vector3 outRayFar, num screenX, num screenY) {
    num pickX = screenX;
    num pickY = screenY;

    bool rayPicked = pickRay(camera.viewProjectionMatrix, 0, Context.width,
        0, Context.height, pickX, pickY, outRayNear, outRayFar);

    return rayPicked;
  }

  /// Experiment with unProject
  static List<PointMesh> unProjectMultiScreenPoints(CameraPerspective camera) {
    List<PointMesh> resultPoints = [];

    num pickX = 0.0;
    num pickY = Context.height * 0.25;
    num pickZ = 0.0;

    Vector3 pickWorld = new Vector3.zero();

    for (num i = 0.0; i < 1.0; i += 0.1) {
      pickX = i * Context.width;
      UtilsGeometry.unProjectScreenPoint(camera, pickWorld, pickX, pickY, pickZ:pickZ);

      resultPoints.add(new PointMesh()
        ..translation = pickWorld
        ..primitive.material = new MaterialPoint(pointSize:5.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0))
        ..visible = true);
    }
    return resultPoints;
  }

  /// May be buggy for some models like the sphere mesh
  /// How to hide vertices after shown ?
  static List<PointMesh> drawModelVertices(Mesh model) {
    List<PointMesh> resultPoints = [];
    MaterialPoint material = new MaterialPoint(pointSize:4.0 ,color: new Vector4(1.0, 1.0, 0.0, 1.0));

    for(Triangle triangle in model.getFaces()){
      resultPoints.addAll(drawTriangleVertices(triangle, material));
    }
    return resultPoints;
  }

  /// Draw a point for each vertex of the triangle
  static List<PointMesh> drawTriangleVertices(Triangle triangle, MaterialPoint material) {
    List<PointMesh> resultPoints = [];

    List<Vector3> vertices = [triangle.point0, triangle.point1, triangle.point2];

    for(Vector3 vertex in vertices){
      resultPoints.add(new PointMesh()
        ..translation = vertex
        ..primitive.material = material);
    }
    return resultPoints;
  }

  /// Find ray with mouse coord in the camera
  static Ray findRay(CameraPerspective camera, num screenX, num screenY) {
    Vector3 outRayNear = new Vector3.zero();
    UtilsGeometry.unProjectScreenPoint(camera, outRayNear, screenX, screenY);

    Vector3 direction = outRayNear - camera.translation;
    return new Ray.originDirection(outRayNear, direction);
  }

  /// Draw a point on the model intersected with the ray
  static List<PointMesh> findModelHitPoint(Mesh model, Ray ray) {
    List<PointMesh> resultPoints = [];
    Material material = new MaterialPoint(pointSize:8.0 ,color: new Vector4(1.0, 0.0, 0.0, 1.0));

    for(Triangle triangle in model.getFaces()) {
      double distance = ray.intersectsWithTriangle(triangle);

      if(distance != null) {
        resultPoints.add(new PointMesh()
          ..translation = ray.at(distance)
          ..primitive.material = material);
      }
    }

    return resultPoints;
  }

  static Mesh findModelFromMouseCoords(CameraPerspective camera, num x, num y, List<Mesh> models) {
    Ray ray = UtilsGeometry.findRay(camera, x, y);
    Mesh modelHit = UtilsGeometry.findModelHit(models, ray);
    return modelHit;
  }

  /// Find the first hit model in the list using the ray
  static Mesh findModelHit(List<Mesh> models, Ray ray) {
    Mesh modelHit;
    num distanceHit;

    for(Mesh model in models){
      for(Triangle triangle in model.getFaces()) {
        num distance = ray.intersectsWithTriangle(triangle);

        if(distance != null) {
          if(modelHit == null || distance < distanceHit) {
            modelHit = model;
            distanceHit = distance;
          }
        }
      }
    }

    return modelHit;
  }
}