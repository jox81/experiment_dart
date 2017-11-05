import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/accessor_sparse.dart';
import 'package:webgl/src/gtlf/accessor_sparse_indices.dart';
import 'package:webgl/src/gtlf/accessor_sparse_values.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@TestOn("dartium")
Future main() async {
  group("Accessor", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource(
          'gltf/tests/base/data/accessor/empty.gltf',
          useWebPath: true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFAccessor> accessors = gltf.accessors;
      expect(accessors.length, 0);
    });

    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource(
          'gltf/tests/base/data/accessor/valid_full.gltf',
          useWebPath: true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFAccessor> accessors = gltf.accessors;
      expect(accessors.length, 1);
    });

    test("base properties", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource(
          'gltf/tests/base/data/accessor/valid_full.gltf',
          useWebPath: true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFAccessor accessor = gltf.accessors[0];

      expect(accessor.byteOffset, 0);
      expect(accessor.count, 4);
      expect(accessor.componentType, ShaderVariableType.FLOAT);
      expect(accessor.typeString, "VEC3");
//      expect(accessor.type, ShaderVariableType.FLOAT_VEC3);// Todo (jpu) :
      expect(accessor.min, [
        0.0,
        0.0,
        0.0
      ]);
      expect(accessor.max, [
        1.0,
        1.0,
        1.0
      ]);
      expect(accessor.normalized, false);
      expect(accessor.sparse, isNotNull);
    });

    test("base properties GLTFAccessorSparse", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource(
          'gltf/tests/base/data/accessor/valid_full.gltf',
          useWebPath: true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFAccessorSparse sparse = gltf.accessors[0].sparse;
      expect(sparse, isNotNull);
      expect(sparse.count, 2);
      expect(sparse.indices, isNotNull);
      expect(sparse.values, isNotNull);
    });

    test("base properties GLTFAccessorSparseIndices", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource(
          'gltf/tests/base/data/accessor/valid_full.gltf',
          useWebPath: true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFAccessorSparseIndices indices = gltf.accessors[0].sparse.indices;
      expect(indices, isNotNull);
      expect(indices.byteOffset, 24);
      expect(indices.componentType, ShaderVariableType.UNSIGNED_BYTE);
    });

    test("base properties GLTFAccessorSparseValues", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource(
          'gltf/tests/base/data/accessor/valid_full.gltf',
          useWebPath: true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFAccessorSparseValues values = gltf.accessors[0].sparse.values;
      expect(values, isNotNull);
      expect(values.byteOffset, 0);
    });
  });
}
