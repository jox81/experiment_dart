import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';

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
  static List<GLTFNode> unProjectMultiScreenPoints(CameraPerspective camera) {
    List<GLTFNode> resultPoints = [];

    num pickX = 0.0;
    num pickY = Context.height * 0.25;
    num pickZ = 0.0;

    Vector3 pickWorld = new Vector3.zero();

    for (num i = 0.0; i < 1.0; i += 0.1) {
      pickX = i * Context.width;
      UtilsGeometry.unProjectScreenPoint(camera, pickWorld, pickX, pickY, pickZ:pickZ);

      GLTFMesh meshPoint = new GLTFMesh.point()
        ..primitives[0].material = new MaterialPoint(pointSize:5.0, color: new Vector4(1.0, 0.0, 0.0,1.0));
      GLTFNode nodePoint = new GLTFNode()
        ..mesh = meshPoint
        ..translation = pickWorld;

      resultPoints.add(nodePoint);
    }
    return resultPoints;
  }

  /// May be buggy for some nodes like the sphere mesh
  /// How to hide vertices after shown ?
  static List<GLTFNode> drawNodeVertices(GLTFMesh mesh) {
    List<GLTFNode> resultPoints = [];

    MaterialPoint material = new MaterialPoint(pointSize:4.0, color: new Vector4(1.0, 0.0, 0.0,1.0));

    for(Triangle triangle in mesh.getFaces()){
      resultPoints.addAll(drawTriangleVertices(triangle, material));
    }
    return resultPoints;
  }

  /// Draw a point for each vertex of the triangle
  static List<GLTFNode> drawTriangleVertices(Triangle triangle, MaterialPoint material) {
    List<GLTFNode> resultPoints = [];

    List<Vector3> vertices = [triangle.point0, triangle.point1, triangle.point2];

    for(Vector3 vertex in vertices){

      GLTFMesh meshPoint = new GLTFMesh.point()
        ..primitives[0].material = material;
      GLTFNode nodePoint = new GLTFNode()
        ..mesh = meshPoint
        ..translation = vertex;

      resultPoints.add(nodePoint);
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

  /// Draw a point on the node intersected with the ray
  static List<GLTFNode> findNodeHitPoint(GLTFNode node, Ray ray) {
    List<GLTFNode> resultPoints = [];
    MaterialPoint material = new MaterialPoint(pointSize:8.0, color: new Vector4(1.0, 0.0, 0.0,1.0));

    for(Triangle triangle in node.mesh.getFaces()) {
      double distance = ray.intersectsWithTriangle(triangle);

      if(distance != null) {
        GLTFMesh meshPoint = new GLTFMesh.point()
          ..primitives[0].material = material;
        GLTFNode nodePoint = new GLTFNode()
          ..mesh = meshPoint
          ..translation = ray.at(distance);

        resultPoints.add(nodePoint);
      }
    }

    return resultPoints;
  }

  static GLTFNode findNodeFromMouseCoords(CameraPerspective camera, num x, num y, List<GLTFNode> nodes) {
    Ray ray = UtilsGeometry.findRay(camera, x, y);
    GLTFNode itemHit = UtilsGeometry.findNodeHit(nodes, ray);
    return itemHit;
  }

  /// Find the first hit node in the list using the ray
  static GLTFNode findNodeHit(List<GLTFNode> nodes, Ray ray) {
    GLTFNode itemHit;
    num distanceHit;

    for(GLTFNode node in nodes){
      if (node.mesh != null) {
        for(Triangle triangle in node.mesh.getFaces()) {
          num distance = ray.intersectsWithTriangle(triangle..transform(node.matrix));

          if(distance != null) {
            if(itemHit == null || distance < distanceHit) {
              itemHit = node;
              distanceHit = distance;
            }
          }
        }
      }
    }

    return itemHit;
  }
}