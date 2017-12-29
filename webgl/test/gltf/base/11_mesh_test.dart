import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/project.dart';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/gtlf/gltf_creation.dart';
void main() {
  group('Mesh', () {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/mesh/empty.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      List<GLTFMesh> meshes = gltf.meshes;
      expect(meshes.length, 0);
    });

    test("Array length", () async {
      String gltfPath = 'gltf/tests/base/data/mesh/valid_full.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      List<GLTFMesh> meshes = gltf.meshes;
      expect(meshes.length, 1);
    });

    test("Property primitive", () async {
      String gltfPath = 'gltf/tests/base/data/mesh/valid_full.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      GLTFMesh mesh = gltf.meshes[0];
      expect(mesh, isNotNull);

      expect(mesh.primitives.length, 1);
    });

    test("Property weights", () async {
      String gltfPath = 'gltf/tests/base/data/mesh/valid_full.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      GLTFMesh mesh = gltf.meshes[0];
      expect(mesh, isNotNull);

      expect(mesh.weights.length, 2);
    });
  });

  group('MeshPrimitive', () {
    test("Property primitive", () async {
      String gltfPath = 'gltf/tests/base/data/mesh/valid_full.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      GLTFMesh mesh = gltf.meshes[0];
      expect(mesh, isNotNull);

      GLTFMeshPrimitive primitive = mesh.primitives[0];
      expect(primitive, isNotNull);

      expect(primitive.attributes.length, isNotNull);
      expect(primitive.drawMode, DrawMode.TRIANGLES);

    });
  });
}