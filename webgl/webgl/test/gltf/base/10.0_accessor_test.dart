import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/accessor/accessor_sparse.dart';
import 'package:webgl/src/gltf/accessor/accessor_sparse_indices.dart';
import 'package:webgl/src/gltf/accessor/accessor_sparse_values.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

import '../../data/gltf_helper.dart';

@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {
  group("Accessor", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/accessor/empty.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFAccessor> accessors = gltf.accessors;
      expect(accessors.length, 0);
    });

    test("Array length", () async {
      String gltfPath =
          '${testFolderRelativePath}/gltf/tests/base/data/accessor/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFAccessor> accessors = gltf.accessors;
      expect(accessors.length, 1);
    });

    test("base properties", () async {
      String gltfPath =
          '${testFolderRelativePath}/gltf/tests/base/data/accessor/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

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
      String gltfPath =
          '${testFolderRelativePath}/gltf/tests/base/data/accessor/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      GLTFAccessorSparse sparse = gltf.accessors[0].sparse;
      expect(sparse, isNotNull);
      expect(sparse.count, 2);
      expect(sparse.indices, isNotNull);
      expect(sparse.values, isNotNull);
    });

    test("base properties GLTFAccessorSparseIndices", () async {
      String gltfPath =
          '${testFolderRelativePath}/gltf/tests/base/data/accessor/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      GLTFAccessorSparseIndices indices = gltf.accessors[0].sparse.indices;
      expect(indices, isNotNull);
      expect(indices.byteOffset, 24);
      expect(indices.componentType, ShaderVariableType.UNSIGNED_BYTE);
    });

    test("base properties GLTFAccessorSparseValues", () async {
      String gltfPath =
          '${testFolderRelativePath}/gltf/tests/base/data/accessor/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      await gltf.debug(doProjectLog : false, isDebug:false);

      GLTFAccessorSparseValues values = gltf.accessors[0].sparse.values;
      expect(values, isNotNull);
      expect(values.byteOffset, 0);
    });
  });
}
