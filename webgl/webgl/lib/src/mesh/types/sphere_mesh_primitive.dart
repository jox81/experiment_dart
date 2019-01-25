import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class SphereMeshPrimitive extends MeshPrimitive {

  Matrix4 _matRotY = new Matrix4.identity();
  Matrix4 _matRotZ = new Matrix4.identity();

  Vector3 _tmpVec3 = new Vector3.zero();
  Vector3 _up = new Vector3(0.0, 1.0, 0.0);

  List<Vector3> sphereVerticesVector = [];

  SphereMeshPrimitive({double radius : 1.0, int segmentV: 32, int segmentH : 32}) {

    mode = DrawMode.TRIANGLES;

    segmentV = max(1,segmentV--);

    int totalZRotationSteps = 1 + segmentV;
    int totalYRotationSteps = segmentH;

    for (int zRotationStep = 0;
    zRotationStep <= totalZRotationSteps;
    zRotationStep++) {
      double normalizedZ = zRotationStep / totalZRotationSteps;
      double angleZ = (normalizedZ * pi);//part of vertical half circle

      for (int yRotationStep = 0;
      yRotationStep <= totalYRotationSteps;
      yRotationStep++) {
        double normalizedY = yRotationStep / totalYRotationSteps;
        double angleY = normalizedY * pi * 2;//part of horizontal full circle

        _matRotZ.setIdentity();//reset
        _matRotZ.rotateZ(-angleZ);

        _matRotY.setIdentity();//reset
        _matRotY.rotateY(angleY);

        _tmpVec3 = (_matRotY * _matRotZ * _up) as Vector3;//up vector transformed by the 2 rotations

        _tmpVec3.scale(-radius);// why - ?
        vertices.addAll(_tmpVec3.storage);
        sphereVerticesVector.add(_tmpVec3);

        _tmpVec3.normalize();
        normals.addAll(_tmpVec3.storage);

        uvs.addAll([normalizedY, 1 - normalizedZ]);
      }

      if (zRotationStep > 0) {
        var verticesCount = sphereVerticesVector.length;
        var firstIndex = verticesCount - 2 * (totalYRotationSteps + 1);
        for (;
        (firstIndex + totalYRotationSteps + 2) < verticesCount;
        firstIndex++) {
          indices.addAll([
            firstIndex,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 1
          ]);
          indices.addAll([
            firstIndex + totalYRotationSteps + 1,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 2
          ]);
        }
      }
    }
  }
}